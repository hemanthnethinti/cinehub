/**
 * @module models/conversation.model
 * @description Conversation schema for messaging.
 */
const mongoose = require('mongoose');

const toJSON = require('./plugins/toJSON.plugin');
const paginate = require('./plugins/paginate.plugin');
const softDelete = require('./plugins/softDelete.plugin');

const conversationSchema = new mongoose.Schema(
  {
    participants: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
      },
    ],
    latestMessage: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Message',
    },
    unreadCount: {
      type: Map,
      of: Number,
      default: {},
    },
    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
  },
  {
    timestamps: true,
    collection: 'conversations',
  },
);

// ── Indexes ─────────────────────────────────

conversationSchema.index({ participants: 1 });
conversationSchema.index({ updatedAt: -1 });

// ── Plugins ─────────────────────────────────

conversationSchema.plugin(toJSON);
conversationSchema.plugin(paginate);
conversationSchema.plugin(softDelete);

const Conversation = mongoose.model('Conversation', conversationSchema);

module.exports = Conversation;
