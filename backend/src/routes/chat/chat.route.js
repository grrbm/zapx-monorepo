import express from 'express';
import {
  createChat,
  getAllChats,
  getChatByChatId,
} from '../../controller/chat/chat.controller.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import upload from '../../services/multer.service.js';

const router = express.Router();

router.post(
  '/message',
  authMiddleware([Role.CONSUMER, Role.SELLER, Role.ADMIN]),
  upload.array('files'),
  createChat
);

router.get(
  '/',
  authMiddleware([Role.CONSUMER, Role.SELLER, Role.ADMIN]),
  getAllChats
);

router.get(
  '/:chatId',
  authMiddleware([Role.CONSUMER, Role.SELLER, Role.ADMIN]),
  getChatByChatId
);

export default router;
