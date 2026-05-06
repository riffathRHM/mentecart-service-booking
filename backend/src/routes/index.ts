import { Router } from "express";
import { AuthController } from "../controllers/AuthController";
import { validateBody } from "../middleware/validation";
import { signupSchema,loginSchema,serviceQuerySchema } from "../validators";
import { asyncHandler } from "../middleware/errorHandler";
import { authMiddleware } from '../middleware/auth';
import { validateQuery } from "../middleware/validation";
import { ServiceController } from "../controllers/ServiceController";

const router = Router();

// Signup Route
router.post(
  "/auth/signup",
  validateBody(signupSchema),
  asyncHandler(AuthController.signup)
);

// login route
router.post(
  "/auth/login",
  validateBody(loginSchema),
  asyncHandler(AuthController.login)
);
router.get('/auth/me', authMiddleware, asyncHandler(AuthController.getCurrentUser));
router.post('/auth/refresh', asyncHandler(AuthController.refreshToken));

//---Services Routes---
router.get(
  '/services',
  validateQuery(serviceQuerySchema),
  asyncHandler(ServiceController.getServices)
);
router.get('/services/:id', asyncHandler(ServiceController.getServiceById));

export default router;