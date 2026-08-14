process.env.NODE_ENV = 'test';
process.env.APP_URL = 'http://localhost:5000';
process.env.CLIENT_URL = 'http://localhost:3000';
process.env.MONGODB_URI = 'mongodb://127.0.0.1:27017/cinehub-test';
process.env.JWT_ACCESS_SECRET = 'test-access-secret-with-at-least-thirty-two-characters';
process.env.JWT_REFRESH_SECRET = 'test-refresh-secret-with-at-least-thirty-two-characters';

jest.mock('../src/api/v1/messaging/messaging.service', () => ({
  getConversations: jest.fn(),
  createConversation: jest.fn(),
  getMessages: jest.fn(),
  sendMessage: jest.fn(),
  markAsRead: jest.fn(),
}));

const messagingService = require('../src/api/v1/messaging/messaging.service');
const controller = require('../src/api/v1/messaging/messaging.controller');

function makeResponse() {
  return {
    status: jest.fn().mockReturnThis(),
    json: jest.fn().mockReturnThis(),
  };
}

async function runHandler(handler, req, res) {
  const next = jest.fn();
  handler(req, res, next);
  await new Promise((resolve) => { setImmediate(resolve); });
  expect(next).not.toHaveBeenCalled();
}

describe('messaging controller response contract', () => {
  beforeEach(() => jest.clearAllMocks());

  test('returns conversations in the standard flat paginated envelope', async () => {
    messagingService.getConversations.mockResolvedValue({
      docs: [
        {
          id: 'conversation-1',
          unreadCount: { 'user-1': 3, 'user-2': 1 },
        },
      ],
      pagination: { page: 1, totalDocs: 1, totalPages: 1 },
    });
    const req = { user: { _id: { toString: () => 'user-1' } }, query: {} };
    const res = makeResponse();

    await runHandler(controller.getConversations, req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json).toHaveBeenCalledWith(expect.objectContaining({
      status: 'success',
      message: 'Conversations retrieved successfully',
      data: [{ id: 'conversation-1', unreadCount: 3 }],
      meta: { pagination: { page: 1, totalDocs: 1, totalPages: 1 } },
    }));
  });

  test('returns messages in the standard flat paginated envelope', async () => {
    messagingService.getMessages.mockResolvedValue({
      docs: [{ id: 'message-1', text: 'Hello' }],
      pagination: { page: 1, totalDocs: 1, totalPages: 1 },
    });
    const req = {
      user: { _id: { toString: () => 'user-1' } },
      params: { id: 'conversation-1' },
      query: {},
    };
    const res = makeResponse();

    await runHandler(controller.getMessages, req, res);

    expect(res.status).toHaveBeenCalledWith(200);
    expect(res.json.mock.calls[0][0].data).toEqual([
      { id: 'message-1', text: 'Hello' },
    ]);
    expect(res.json.mock.calls[0][0].meta.pagination.totalDocs).toBe(1);
  });
});
