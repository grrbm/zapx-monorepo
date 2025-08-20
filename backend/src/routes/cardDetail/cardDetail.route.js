import express from 'express';
import {
  createCardDetil,
  deleteCardDetail,
  getAllCardDetails,
  getCardByCardId,
  updateCardDetail,
} from '../../controller/cardDetail/cardDetail.controller.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';

const router = express.Router();

router.post('/', authMiddleware([Role.CONSUMER]), createCardDetil);

router.get('/', authMiddleware([Role.CONSUMER]), getAllCardDetails);

router.get('/:cardId', authMiddleware([Role.CONSUMER]), getCardByCardId);
router.patch('/:cardId', authMiddleware([Role.CONSUMER]), updateCardDetail);
router.delete('/:cardId', authMiddleware([Role.CONSUMER]), deleteCardDetail);

export default router;
