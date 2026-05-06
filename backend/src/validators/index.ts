import { z } from 'zod';

// Auth Schemas
export const signupSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Invalid email format'),
  password: z.string().min(8, 'Password must be at least 8 characters'),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

// Service Schemas
export const serviceQuerySchema = z.object({
  page: z.string().transform(Number).pipe(z.number().int().positive()).default(1).optional(),
  limit: z.string().transform(Number).pipe(z.number().int().positive().max(100)).default(20).optional(),
  category: z.string().optional(),
  search: z.string().optional(),
});

export const createServiceSchema = z.object({
  title: z.string().min(3, 'Title must be at least 3 characters'),
  description: z.string().min(10, 'Description must be at least 10 characters'),
  price: z.number().positive('Price must be positive'),
  duration: z.number().int().positive('Duration must be positive (minutes)'),
  category: z.string().min(2, 'Category must be at least 2 characters'),
  capacityPerSlot: z.number().int().positive('Capacity must be positive'),
  image: z.string().url('Image must be a valid URL').optional(),
});

// Cart Schemas
export const addToCartSchema = z.object({
  serviceId: z.string().min(1, 'Service ID is required'),
  date: z.string().datetime('Invalid date format'),
  quantity: z.number().int().positive('Quantity must be positive').default(1),
});

export const updateCartItemSchema = z.object({
  quantity: z.number().int().positive('Quantity must be positive').optional(),
  date: z.string().datetime('Invalid date format').optional(),
});

// Booking Schemas
export const checkoutSchema = z.object({
  paymentMethod: z.enum(['cash', 'pay_on_arrival', 'credit_card', 'payhere']).optional().default('cash'),
  address: z.object({
    street: z.string().min(5),
    city: z.string().min(2),
    zipCode: z.string().min(3),
    country: z.string().min(2),
  }).optional(),
});

export const cancelBookingSchema = z.object({
  reason: z.string().optional(),
});

// Type exports
export type SignupPayload = z.infer<typeof signupSchema>;
export type LoginPayload = z.infer<typeof loginSchema>;
export type ServiceQuery = z.infer<typeof serviceQuerySchema>;
export type CreateServicePayload = z.infer<typeof createServiceSchema>;
export type AddToCartPayload = z.infer<typeof addToCartSchema>;
export type UpdateCartItemPayload = z.infer<typeof updateCartItemSchema>;
export type CheckoutPayload = z.infer<typeof checkoutSchema>;
export type CancelBookingPayload = z.infer<typeof cancelBookingSchema>;