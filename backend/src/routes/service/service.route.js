import express from 'express';
import {
  createService,
  getServices,
} from '../../controller/service/service.controller.js';
const router = express.Router();

router.post('/', createService);
router.get('/', getServices);

export default router;
