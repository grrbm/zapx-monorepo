import express from 'express';

import { authMiddleware } from '../../middlewares/authMiddleware.js';
import { Role } from '@prisma/client';
import {
  CompletedAppointments,
  dailyRevenue,
  todaySchedule,
  weeklyInsight,
} from '../../controller/dashboard/dashboard.controller.js';

const router = express.Router();

router.get('/insignt', authMiddleware([Role.SELLER]), weeklyInsight);

router.get('/graph', authMiddleware([Role.SELLER]), CompletedAppointments);

router.get('/dailyRevenue', authMiddleware([Role.SELLER]), dailyRevenue);
router.get('/todaySchedule', authMiddleware([Role.SELLER]), todaySchedule);

export default router;
