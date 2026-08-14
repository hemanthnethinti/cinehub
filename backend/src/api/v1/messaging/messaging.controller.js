/**
 * @module api/v1/messaging/messaging.controller
 * @description Controller for messaging endpoints.
 */
const { catchAsync, ApiResponse } = require('../../../utils');
const messagingService = require('./messaging.service');

/**
 * Resolve the current user's unread count from either a Mongoose Map or a
 * plain object produced by a lean query.
 * @param {Map|string|Object|null} unreadCount
 * @param {string} userId
 * @returns {number}
 */
function getUnreadCount(unreadCount, userId) {
  if (unreadCount instanceof Map) return unreadCount.get(userId) || 0;
  if (unreadCount && typeof unreadCount === 'object') return unreadCount[userId] || 0;
  return 0;
}

const getConversations = catchAsync(async (req, res) => {
  const userId = req.user._id.toString();
  const result = await messagingService.getConversations(userId, req.query);

  const conversations = result.docs.map((conversation) => {
    const value = conversation.toJSON ? conversation.toJSON() : { ...conversation };
    value.unreadCount = getUnreadCount(value.unreadCount, userId);
    return value;
  });

  ApiResponse.paginated(
    conversations,
    result.pagination,
    'Conversations retrieved successfully',
  ).send(res);
});

const createConversation = catchAsync(async (req, res) => {
  const conversation = await messagingService.createConversation(
    req.user._id.toString(),
    req.body.participantId,
  );
  ApiResponse.ok(conversation, 'Conversation ready').send(res);
});

const getMessages = catchAsync(async (req, res) => {
  const result = await messagingService.getMessages(
    req.user._id.toString(),
    req.params.id,
    req.query,
  );
  ApiResponse.paginated(
    result.docs,
    result.pagination,
    'Messages retrieved successfully',
  ).send(res);
});

const sendMessage = catchAsync(async (req, res) => {
  const message = await messagingService.sendMessage(
    req.user._id.toString(),
    req.params.id,
    req.body,
  );
  ApiResponse.created(message, 'Message sent successfully').send(res);
});

const markAsRead = catchAsync(async (req, res) => {
  await messagingService.markAsRead(req.user._id.toString(), req.params.id);
  ApiResponse.ok(null, 'Conversation marked as read').send(res);
});

module.exports = {
  getConversations,
  createConversation,
  getMessages,
  sendMessage,
  markAsRead,
};
