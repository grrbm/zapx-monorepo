import express from 'express';
import { Role } from '@prisma/client';
import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { updateFile } from '../../controller/fileUpdate/fileUpdate.controller.js';
import upload from '../../services/multer.service.js';

const router = express.Router();

router.patch(
  '/:fileId',
  authMiddleware([Role.CONSUMER, Role.SELLER]),
  upload.fields([{ name: 'file' }]),
  updateFile
);

export default router;
