import { Cart, ICart, ICartItem } from '../models/Cart';
import { Service } from '../models/Service';
import { ServiceSlot } from '../models/ServiceSlot';
import { logger } from '../config/logger';
import {
  NotFoundError,
  ConflictError,
  ValidationError,
  InternalServerError,
} from '../utils/errors';
import config from '../config/env';
import mongoose from 'mongoose';

export interface AddToCartPayload {
  serviceId: string;
  date: string;
  quantity: number;
}

export interface UpdateCartItemPayload {
  quantity?: number;
  date?: string;
}

export class CartService {
  async getCart(userId: string): Promise<ICart | null> {
    try {
      const cart = await Cart.findOne({ userId }).populate('items.serviceId');
      return cart;
    } catch (error) {
      logger.error({ error, userId }, 'Failed to fetch cart');
      throw new InternalServerError('Failed to fetch cart');
    }
  }

  async addToCart(userId: string, payload: AddToCartPayload): Promise<ICart> {
    try {
      const { serviceId, date, quantity } = payload;

      if (!mongoose.Types.ObjectId.isValid(serviceId)) {
        throw new ValidationError('Invalid service ID');
      }

      // Fetch service
      const service = await Service.findById(serviceId);
      if (!service) {
        throw new NotFoundError('Service');
      }

      const bookingDate = new Date(date);

      // Get available slot
      const slot = await ServiceSlot.findOne({
        serviceId,
        date: {
          $gte: new Date(bookingDate.setHours(0, 0, 0, 0)),
          $lte: new Date(bookingDate.setHours(23, 59, 59, 999)),
        },
        isActive: true,
        availableCapacity: { $gte: quantity },
      });

      if (!slot) {
        throw new ConflictError(
          'No available slots for selected date',
          'NO_AVAILABLE_SLOTS'
        );
      }

      // Get or create cart
      let cart = await Cart.findOne({ userId });
      if (!cart) {
        cart = new Cart({ userId, items: [] });
      }

      // Check if same service with same slot already exists
      const existingItemIndex = cart.items.findIndex(
        (item) =>
          item.serviceId.toString() === serviceId &&
          item.date.getTime() === bookingDate.getTime() &&
          item.startTime === slot.startTime
      );

      const expiryTime = new Date();
      expiryTime.setMinutes(expiryTime.getMinutes() + config.CART_EXPIRY_MINUTES);

      if (existingItemIndex >= 0) {
        // Update existing item
        cart.items[existingItemIndex].quantity += quantity;
        cart.items[existingItemIndex].expiresAt = expiryTime;
      } else {
        // Add new item
        cart.items.push({
          serviceId: new mongoose.Types.ObjectId(serviceId),
          quantity,
          date: bookingDate,
          startTime: slot.startTime,
          endTime: slot.endTime,
          price: service.price,
          addedAt: new Date(),
          expiresAt: expiryTime,
        } as any);
      }

      await cart.save();
      logger.info({ userId, serviceId, quantity }, 'Item added to cart');

      return cart;
    } catch (error) {
      if (
        error instanceof NotFoundError ||
        error instanceof ConflictError ||
        error instanceof ValidationError
      ) {
        throw error;
      }
      logger.error({ error, userId }, 'Failed to add item to cart');
      throw new InternalServerError('Failed to add item to cart');
    }
  }

  async updateCartItem(
    userId: string,
    itemId: string,
    payload: UpdateCartItemPayload
  ): Promise<ICart> {
    try {
      const cart = await Cart.findOne({ userId });
      if (!cart) {
        throw new NotFoundError('Cart');
      }

      const item = cart.items.find((i) => i._id?.toString() === itemId);
      if (!item) {
        throw new NotFoundError('Cart item');
      }

      if (payload.quantity !== undefined) {
        if (payload.quantity <= 0) {
          throw new ValidationError('Quantity must be greater than 0');
        }
        item.quantity = payload.quantity;
      }

      if (payload.date !== undefined) {
        item.date = new Date(payload.date);
      }

      // Reset expiry time
      const expiryTime = new Date();
      expiryTime.setMinutes(expiryTime.getMinutes() + config.CART_EXPIRY_MINUTES);
      item.expiresAt = expiryTime;

      await cart.save();
      logger.info({ userId, itemId }, 'Cart item updated');

      return cart;
    } catch (error) {
      if (error instanceof NotFoundError || error instanceof ValidationError) {
        throw error;
      }
      logger.error({ error, userId, itemId }, 'Failed to update cart item');
      throw new InternalServerError('Failed to update cart item');
    }
  }

  async removeFromCart(userId: string, itemId: string): Promise<ICart> {
    try {
      const cart = await Cart.findOne({ userId });
      if (!cart) {
        throw new NotFoundError('Cart');
      }

      const initialLength = cart.items.length;
      cart.items = cart.items.filter((i) => i._id?.toString() !== itemId);

      if (cart.items.length === initialLength) {
        throw new NotFoundError('Cart item');
      }

      await cart.save();
      logger.info({ userId, itemId }, 'Item removed from cart');

      return cart;
    } catch (error) {
      if (error instanceof NotFoundError) {
        throw error;
      }
      logger.error({ error, userId, itemId }, 'Failed to remove item from cart');
      throw new InternalServerError('Failed to remove item from cart');
    }
  }

  async clearCart(userId: string): Promise<void> {
    try {
      await Cart.updateOne({ userId }, { items: [] });
      logger.info({ userId }, 'Cart cleared');
    } catch (error) {
      logger.error({ error, userId }, 'Failed to clear cart');
      throw new InternalServerError('Failed to clear cart');
    }
  }
}

export const cartService = new CartService();