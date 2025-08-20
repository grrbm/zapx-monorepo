import express from 'express';
import {
  deleteUser,
  forgotPassword,
  login,
  resetPassword,
  signup,
  verifyOTP,
} from '../../controller/auth/auth.controller.js';
import {
  authMiddleware,
  validateLogIn,
  validateSignUp,
} from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';

const router = express.Router();

router.post('/login', validateLogIn, login);

router.post('/signup', validateSignUp, signup);

router.post('/forgot-password', forgotPassword);

router.post('/verify-otp', verifyOTP);

router.post('/reset-password', resetPassword);
router.delete(
  '/delete',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  deleteUser
);

export default router;
