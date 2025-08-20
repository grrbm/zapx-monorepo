import express from 'express';
import {
  favouriteOrUnFavourite,
  getFavoritesUser,
} from '../../controller/favourite/favourite.controller.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';

const router = express.Router();

router.post(
  '/seller/:sellerId',
  authMiddleware([Role.CONSUMER]),
  favouriteOrUnFavourite
);

router.get('/seller', authMiddleware([Role.CONSUMER]), getFavoritesUser);

export default router;
