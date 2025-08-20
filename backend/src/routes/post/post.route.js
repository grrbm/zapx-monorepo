import express from 'express';
import upload from '../../services/multer.service.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  createPost,
  deletePost,
  getPost,
  getPostById,
  getPostBySellerId,
  updatePost,
} from '../../controller/post/post.controller.js';

const router = express.Router();

router.post(
  '/',
  authMiddleware([Role.SELLER, Role.ADMIN]),
  upload.fields([{ name: 'image' }]),
  createPost
);

router.get(
  '/',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getPost
);

router.get(
  '/seller/:id',
  authMiddleware([Role.SELLER, Role.ADMIN, Role.CONSUMER]),
  getPostBySellerId
);

router.get(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getPostById
);

router.delete(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  deletePost
);

router.patch(
  '/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  updatePost
);

export default router;
