/**
 * @module repositories/message.repository
 * @description Repository for Message model operations.
 */
const BaseRepository = require('./base.repository');
const { Message } = require('../models');

class MessageRepository extends BaseRepository {
  constructor() {
    super(Message);
  }

  /**
   * Get messages for a conversation with pagination
   * @param {string} conversationId - Conversation ID
   * @param {Object} options - Pagination options
   * @returns {Promise<Object>}
   */
  async getConversationMessages(conversationId, options) {
    const filter = { conversation: conversationId };
    const mergedOptions = {
      ...options,
      populate: 'sender',
      sort: { createdAt: -1 },
    };
    return this.paginate(filter, mergedOptions);
  }

  /**
   * Mark messages as read by a user
   * @param {string} conversationId - Conversation ID
   * @param {string} userId - User ID
   * @returns {Promise<Object>}
   */
  async markAsRead(conversationId, userId) {
    return this.model.updateMany(
      { 
        conversation: conversationId, 
        readBy: { $ne: userId } 
      },
      { 
        $addToSet: { readBy: userId },
        $set: { status: 'read' }
      }
    );
  }
}

module.exports = new MessageRepository();
