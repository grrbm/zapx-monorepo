import express from 'express';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  createPortfolio,
  deletePortfolio,
  getPortfolio,
  getPortfolioById,
  getPortfolioByUser,
  updatePortfolio,
  getPortfolioBySellerId,
} from '../../controller/portfolio/portfolio.controller.js';
import upload from '../../services/multer.service.js';

const router = express.Router();

router.post(
  '/',
  authMiddleware([Role.SELLER, Role.ADMIN]),
  upload.fields([{ name: 'image' }]),
  createPortfolio
);

router.get(
  '/seller/:id',
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getPortfolioBySellerId
);

router.get(
  '/',
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getPortfolio
);
router.get('/seller', authMiddleware([Role.SELLER]), getPortfolioByUser);

router.get('/:id', authMiddleware([Role.SELLER, Role.ADMIN]), getPortfolioById);

router.delete(
  '/:id',
  authMiddleware([Role.SELLER, Role.ADMIN]),
  deletePortfolio
);

router.patch(
  '/:id',
  authMiddleware([Role.SELLER, Role.ADMIN]),
  updatePortfolio
);

export default router;
