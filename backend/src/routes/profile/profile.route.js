import express from 'express';
import {
  createBio,
  createProfile,
  createProfileImage,
  getBioByUser,
  getProfilebyUser,
  updateBio,
  updateProfile,
  getProfilebySellerId,
} from '../../controller/profile/profile.controller.js';
import upload from '../../services/multer.service.js';
import {
  authMiddleware,
  authProfileMiddleware,
} from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';

const router = express.Router();

router.post(
  '/',
  authProfileMiddleware(Role.SELLER),
  upload.fields([{ name: 'cardImage' }, { name: 'image' }]),
  createProfile
);

router.post(
  '/bio',
  authMiddleware(Role.SELLER),
  upload.single('image'),
  createBio
);

router.patch('/bio', authMiddleware(Role.SELLER), updateBio);
router.get('/bio', authMiddleware(Role.SELLER), getBioByUser);
router.get('/', authMiddleware(Role.CONSUMER), getProfilebyUser);
router.get(
  '/seller/:id',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  getProfilebySellerId
);

router.post(
  '/image',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  upload.single('image'),
  createProfileImage
);

router.patch('/', authMiddleware(Role.CONSUMER), updateProfile);

export default router;
