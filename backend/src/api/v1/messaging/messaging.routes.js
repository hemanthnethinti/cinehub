/**
 * @module api/v1/messaging/messaging.routes
 * @description Routes for messaging module.
 */
const express = require('express');
const { authenticate, validate } = require('../../../middleware');
const messagingValidation = require('./messaging.validation');
const messagingController = require('./messaging.controller');

const router = express.Router();

router.use(authenticate());

router
  .route('/conversations')
  .get(validate(messagingValidation.getConversations), messagingController.getConversations);

router
  .route('/conversations/:id/messages')
  .get(validate(messagingValidation.getMessages), messagingController.getMessages)
  .post(validate(messagingValidation.sendMessage), messagingController.sendMessage);

router
  .route('/conversations/:id/read')
  .patch(validate(messagingValidation.markAsRead), messagingController.markAsRead);

module.exports = router;
