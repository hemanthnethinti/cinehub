/**
 * @module models/message.model
 * @description Message schema for messaging conversations.
 */
const mongoose = require('mongoose');

const toJSON = require('./plugins/toJSON.plugin');
const paginate = require('./plugins/paginate.plugin');
const softDelete = require('./plugins/softDelete.plugin');

const messageSchema = new mongoose.Schema(
  {
    conversation: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Conversation',
      required: true,
      index: true,
    },
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },
    text: {
      type: String,
      required: true,
      trim: true,
    },
    attachments: [
      {
        type: String,
      },
    ],
    status: {
      type: String,
      enum: ['sent', 'delivered', 'read'],
      default: 'sent',
    },
    readBy: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
      },
    ],
  },
  {
    timestamps: true,
    collection: 'messages',
  },
);

// ── Indexes ─────────────────────────────────

messageSchema.index({ conversation: 1, createdAt: -1 });

// ── Plugins ─────────────────────────────────

messageSchema.plugin(toJSON);
messageSchema.plugin(paginate);
messageSchema.plugin(softDelete);

const Message = mongoose.model('Message', messageSchema);

module.exports = Message;
