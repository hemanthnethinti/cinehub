/**
 * @module api/v1/messaging/messaging.controller
 * @description Controller for messaging endpoints.
 */
const httpStatus = require('http-status');
const { catchAsync, ApiResponse } = require('../../../utils');
const messagingService = require('./messaging.service');

const getConversations = catchAsync(async (req, res) => {
  const result = await messagingService.getConversations(req.user.id, req.query);
  
  // Transform unreadCount from Map to Integer for the specific user
  result.results = result.results.map(conv => {
    const convObj = conv.toJSON ? conv.toJSON() : conv;
    convObj.unreadCount = convObj.unreadCount && convObj.unreadCount[req.user.id] ? convObj.unreadCount[req.user.id] : 0;
    return convObj;
  });

  res.status(httpStatus.OK).json(ApiResponse.paginated(result, 'Conversations retrieved successfully'));
});

const getMessages = catchAsync(async (req, res) => {
  const result = await messagingService.getMessages(req.user.id, req.params.id, req.query);
  res.status(httpStatus.OK).json(ApiResponse.paginated(result, 'Messages retrieved successfully'));
});

const sendMessage = catchAsync(async (req, res) => {
  const message = await messagingService.sendMessage(req.user.id, req.params.id, req.body);
  res.status(httpStatus.CREATED).json(ApiResponse.ok(message, 'Message sent successfully'));
});

const markAsRead = catchAsync(async (req, res) => {
  await messagingService.markAsRead(req.user.id, req.params.id);
  res.status(httpStatus.OK).json(ApiResponse.ok(null, 'Conversation marked as read'));
});

module.exports = {
  getConversations,
  getMessages,
  sendMessage,
  markAsRead,
};
