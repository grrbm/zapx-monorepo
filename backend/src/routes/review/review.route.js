import express from 'express';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  createReviewBooking,
  createReviewPost,
  createReviewUser,
  getReviewsByBooking,
  getReviewsByPost,
  getReviewsByUser,
} from '../../controller/review/review.controller.js';

const router = express.Router();

router.post(
  '/user/:sellerId',
  authMiddleware([Role.CONSUMER]),
  createReviewUser
);

router.get(
  '/user/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getReviewsByUser
);

router.post('/post/:id', authMiddleware([Role.CONSUMER]), createReviewPost);

router.get(
  '/post/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getReviewsByPost
);

router.post(
  '/booking/:id',
  authMiddleware([Role.CONSUMER]),
  createReviewBooking
);

router.get(
  '/booking/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getReviewsByBooking
);

export default router;
