/**
 * @module api/v1/messaging/messaging.service
 * @description Business logic for the messaging module.
 */
const httpStatus = require('http-status');
const { ApiError } = require('../../../utils');
const conversationRepository = require('../../../repositories/conversation.repository');
const messageRepository = require('../../../repositories/message.repository');
const { User } = require('../../../models');

/**
 * Get user's conversations
 * @param {string} userId - Requesting user ID
 * @param {Object} options - Pagination options
 * @returns {Promise<Object>}
 */
const getConversations = async (userId, options) => {
  return conversationRepository.getUserConversations(userId, options);
};

/**
 * Get messages in a conversation
 * @param {string} userId - Requesting user ID
 * @param {string} conversationId - Conversation ID
 * @param {Object} options - Pagination options
 * @returns {Promise<Object>}
 */
const getMessages = async (userId, conversationId, options) => {
  const conversation = await conversationRepository.findById(conversationId);
  if (!conversation) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Conversation not found');
  }

  const isParticipant = conversation.participants.some(p => p.toString() === userId.toString());
  if (!isParticipant) {
    throw new ApiError(httpStatus.FORBIDDEN, 'Not a participant in this conversation');
  }

  return messageRepository.getConversationMessages(conversationId, options);
};

/**
 * Send a message
 * @param {string} userId - Sender user ID
 * @param {string} conversationId - Conversation ID (can be new participant ID if direct message)
 * @param {Object} body - Message body
 * @returns {Promise<Object>}
 */
const sendMessage = async (userId, conversationId, body) => {
  let conversation = await conversationRepository.findById(conversationId);

  // If conversation doesn't exist by ID, assume conversationId might be a target user ID
  // to start a new 1-on-1 conversation
  if (!conversation) {
    const targetUser = await User.findById(conversationId);
    if (!targetUser) {
      throw new ApiError(httpStatus.NOT_FOUND, 'Conversation or target user not found');
    }

    const participants = [userId, targetUser._id.toString()];
    conversation = await conversationRepository.findByParticipants(participants);

    if (!conversation) {
      conversation = await conversationRepository.create({
        participants,
        createdBy: userId,
        unreadCount: { [userId]: 0, [targetUser._id.toString()]: 0 }
      });
    }
  } else {
    const isParticipant = conversation.participants.some(p => p.toString() === userId.toString());
    if (!isParticipant) {
      throw new ApiError(httpStatus.FORBIDDEN, 'Not a participant in this conversation');
    }
  }

  // Create message
  const message = await messageRepository.create({
    conversation: conversation._id,
    sender: userId,
    text: body.content,
    attachments: body.mediaUrl ? [body.mediaUrl] : [],
    status: 'sent',
  });

  // Update conversation
  await conversationRepository.updateLatestMessage(conversation._id, message._id);
  
  const otherParticipants = conversation.participants
    .map(p => p.toString())
    .filter(p => p !== userId.toString());
  
  await conversationRepository.incrementUnreadCounts(conversation._id, otherParticipants);

  return messageRepository.findById(message._id).populate('sender');
};

/**
 * Mark a conversation as read
 * @param {string} userId - Requesting user ID
 * @param {string} conversationId - Conversation ID
 * @returns {Promise<void>}
 */
const markAsRead = async (userId, conversationId) => {
  const conversation = await conversationRepository.findById(conversationId);
  if (!conversation) {
    throw new ApiError(httpStatus.NOT_FOUND, 'Conversation not found');
  }

  const isParticipant = conversation.participants.some(p => p.toString() === userId.toString());
  if (!isParticipant) {
    throw new ApiError(httpStatus.FORBIDDEN, 'Not a participant in this conversation');
  }

  await messageRepository.markAsRead(conversationId, userId);
  await conversationRepository.resetUnreadCount(conversationId, userId);
};

module.exports = {
  getConversations,
  getMessages,
  sendMessage,
  markAsRead,
};
