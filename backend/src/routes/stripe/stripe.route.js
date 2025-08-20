import { Role } from '@prisma/client';
import express from 'express';
import {
  getCards,
  getSellerBalance,
  paymentIntent,
  refundPayment,
  saveCard,
  setupIntent,
  storePaymentDetails,
  withdrawSellerBalance,
} from '../../controller/stripe/stripe.controller.js';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
const router = express.Router();

router.get('/setup-intent', authMiddleware([Role.CONSUMER]), setupIntent);
router.post('/payment', authMiddleware([Role.CONSUMER]), paymentIntent);
router.post('/save-card', authMiddleware([Role.CONSUMER]), saveCard);
router.get('/get-cards', authMiddleware([Role.CONSUMER]), getCards);
router.patch('/booking', authMiddleware([Role.CONSUMER]), storePaymentDetails);
router.get('/seller-balance', authMiddleware([Role.SELLER]), getSellerBalance);
router.get(
  '/seller-withdraw-balance',
  authMiddleware([Role.SELLER]),
  withdrawSellerBalance
);
router.post(
  '/refund',
  authMiddleware([Role.CONSUMER, Role.ADMIN, Role.SELLER]),
  refundPayment
);
// for booking complete check booking controller

export default router;
