import express from 'express';

import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  createBankDetail,
  deleteBankDetail,
  getAllBankDetails,
  getBankByCardId,
  updateBankDetail,
} from '../../controller/bankDetail/bankDetail.controller.js';

const router = express.Router();

router.post(
  '/',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  createBankDetail
);

router.get(
  '/',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  getAllBankDetails
);

router.get(
  '/:bankDetailId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  getBankByCardId
);

router.patch(
  '/:bankDetailId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  updateBankDetail
);

router.delete(
  '/:bankDetailId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  deleteBankDetail
);

export default router;
