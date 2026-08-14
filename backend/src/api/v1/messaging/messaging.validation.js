const Joi = require('joi');
Joi.objectId = () => Joi.string().pattern(/^[0-9a-fA-F]{24}$/, 'valid ObjectId');

const getConversations = {
  query: Joi.object().keys({
    page: Joi.number().integer().min(1),
    limit: Joi.number().integer().min(1),
  }),
};

const createConversation = {
  body: Joi.object().keys({
    participantId: Joi.objectId().required(),
  }),
};

const getMessages = {
  params: Joi.object().keys({
    id: Joi.objectId().required(),
  }),
  query: Joi.object().keys({
    page: Joi.number().integer().min(1),
    limit: Joi.number().integer().min(1),
  }),
};

const sendMessage = {
  params: Joi.object().keys({
    id: Joi.objectId().required(),
  }),
  body: Joi.object().keys({
    content: Joi.string().required(),
    mediaUrl: Joi.string().uri().allow(null, ''),
  }),
};

const markAsRead = {
  params: Joi.object().keys({
    id: Joi.objectId().required(),
  }),
};

module.exports = {
  getConversations,
  createConversation,
  getMessages,
  sendMessage,
  markAsRead,
};
