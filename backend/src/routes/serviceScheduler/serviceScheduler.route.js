import express from "express";
import { authMiddleware } from "../../middlewares/authMiddleware.js";
import { Role } from "@prisma/client";
import {
  deleteDiscount,
  updateDiscount,
} from "../../controller/discount/discount.controller.js";
import {
  createServiceScheduler,
  deleteServiceScheduler,
  getAllServiceBySchedulerId,
  getAllServiceScheduler,
  getAllServiceSchedulerBySellerId,
  updateServiceScheduler,
} from "../../controller/serviceScheduler/serviceScheduler.controller.js";

const router = express.Router();

router.get(
  "/",
  authMiddleware([Role.SELLER, Role.CONSUMER, Role.ADMIN]),
  getAllServiceScheduler
);

router.get(
  "/:sellerId",
  authMiddleware([Role.SELLER]),
  getAllServiceSchedulerBySellerId
);

router.get(
  "/consumer/:schedulerId",
  authMiddleware([Role.SELLER, Role.CONSUMER]),
  getAllServiceBySchedulerId
);

router.post(
  "/",
  authMiddleware([Role.SELLER, Role.ADMIN]),
  createServiceScheduler
);

router.delete(
  "/:id",
  authMiddleware([Role.SELLER, Role.ADMIN]),
  deleteServiceScheduler
);

router.patch(
  "/:id",
  authMiddleware([Role.SELLER, Role.ADMIN]),
  updateServiceScheduler
);

export default router;
