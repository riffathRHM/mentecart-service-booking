import { Router } from "express";
import { AuthController } from "../controllers/AuthController";
import { validateBody } from "../middleware/validation";
import { signupSchema,loginSchema,serviceQuerySchema,addToCartSchema,updateCartItemSchema,checkoutSchema,cancelBookingSchema} from "../validators";
import { asyncHandler } from "../middleware/errorHandler";
import { authMiddleware } from '../middleware/auth';
import { validateQuery } from "../middleware/validation";
import { ServiceController } from "../controllers/ServiceController";
import { CartController } from "../controllers/CartController";
import { BookingController } from "../controllers/BookingController";

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
router.get(
  '/services/:id/slots',
  asyncHandler(ServiceController.getServiceWithSlots)
);

//cart Routes
router.get('/cart', authMiddleware, asyncHandler(CartController.getCart));
router.post(
  '/cart/items',
  authMiddleware,
  validateBody(addToCartSchema),
  asyncHandler(CartController.addToCart)
);
router.patch(
  '/cart/items/:itemId',
  authMiddleware,
  validateBody(updateCartItemSchema),
  asyncHandler(CartController.updateCartItem)
);
 
router.delete(
  '/cart/items/:itemId',
  authMiddleware,
  asyncHandler(CartController.removeFromCart)
);

//booking routes
router.post(
  '/bookings/checkout',
  authMiddleware,
  validateBody(checkoutSchema),
  asyncHandler(BookingController.checkout)
);

 
router.get('/bookings', authMiddleware, asyncHandler(BookingController.getBookings));
 
router.get(
  '/bookings/:id',
  authMiddleware,
  asyncHandler(BookingController.getBookingById)
);
 
router.post(
  '/bookings/:id/cancel',
  authMiddleware,
  validateBody(cancelBookingSchema),
  asyncHandler(BookingController.cancelBooking)
);
export default router;