/**
 * @module repositories/conversation.repository
 * @description Repository for Conversation model operations.
 */
const BaseRepository = require('./base.repository');
const { Conversation } = require('../models');

class ConversationRepository extends BaseRepository {
  constructor() {
    super(Conversation);
  }

  /**
   * Find a conversation between specific participants
   * @param {string[]} participantIds - Array of user IDs
   * @returns {Promise<Object>}
   */
  async findByParticipants(participantIds) {
    return this.model.findOne({
      participants: { $all: participantIds, $size: participantIds.length },
    });
  }

  /**
   * Find user's conversations with pagination and populated fields
   * @param {string} userId - User ID
   * @param {Object} options - Pagination options
   * @returns {Promise<Object>}
   */
  async getUserConversations(userId, options) {
    const filter = { participants: userId };
    const mergedOptions = {
      ...options,
      populate: [
        { path: 'participants', select: 'firstName lastName email profilePicture' },
        { path: 'latestMessage' },
      ],
      sort: { updatedAt: -1 },
    };
    return this.paginate(filter, mergedOptions);
  }

  /**
   * Increment unread count for specific users
   * @param {string} conversationId - Conversation ID
   * @param {string[]} userIds - Users to increment count for
   * @returns {Promise<Object>}
   */
  async incrementUnreadCounts(conversationId, userIds) {
    const inc = {};
    userIds.forEach(id => {
      inc[`unreadCount.${id}`] = 1;
    });
    return this.model.findByIdAndUpdate(
      conversationId,
      { $inc: inc },
      { new: true }
    );
  }

  /**
   * Reset unread count for a user
   * @param {string} conversationId - Conversation ID
   * @param {string} userId - User ID
   * @returns {Promise<Object>}
   */
  async resetUnreadCount(conversationId, userId) {
    return this.model.findByIdAndUpdate(
      conversationId,
      { $set: { [`unreadCount.${userId}`]: 0 } },
      { new: true }
    );
  }

  /**
   * Update latest message reference
   * @param {string} conversationId - Conversation ID
   * @param {string} messageId - Message ID
   * @returns {Promise<Object>}
   */
  async updateLatestMessage(conversationId, messageId) {
    return this.model.findByIdAndUpdate(
      conversationId,
      { latestMessage: messageId },
      { new: true }
    );
  }
}

module.exports = new ConversationRepository();
