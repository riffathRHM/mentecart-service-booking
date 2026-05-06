import { Router } from "express";
import { AuthController } from "../controllers/AuthController";
import { validateBody } from "../middleware/validation";
import { signupSchema } from "../validators";
import { asyncHandler } from "../middleware/errorHandler";

const router = Router();

// Signup Route
router.post(
  "/auth/signup",
  validateBody(signupSchema),
  asyncHandler(AuthController.signup)
);

export default router;