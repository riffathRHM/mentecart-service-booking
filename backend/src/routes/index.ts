import { Router } from "express";
import { AuthController } from "../controllers/AuthController";
import { validateBody } from "../middleware/validation";
import { signupSchema,loginSchema } from "../validators";
import { asyncHandler } from "../middleware/errorHandler";
import { authMiddleware } from '../middleware/auth';

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

export default router;