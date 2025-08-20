import express from 'express';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  getAllNotification,
  readAllNotification,
} from '../../controller/notification/notification.controller.js';

const router = express.Router();

router.get(
  '/',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getAllNotification
);

router.post(
  '/read-all-notification',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  readAllNotification
);

export default router;
