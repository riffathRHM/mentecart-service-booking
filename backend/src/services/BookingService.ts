import { Booking, BookingStatus, PaymentStatus, IBooking } from '../models/Booking';
import { Cart } from '../models/Cart';
import { ServiceSlot } from '../models/ServiceSlot';
import { Service } from '../models/Service';
import { User } from '../models/User';
import { logger } from '../config/logger';
import {
  NotFoundError,
  ConflictError,
  ValidationError,
  InternalServerError,
} from '../utils/errors';
import config from '../config/env';
import mongoose from 'mongoose';

export interface CheckoutPayload {
  paymentMethod: 'cash' | 'pay_on_arrival' | 'credit_card' | 'payhere';
  address?: {
    street: string;
    city: string;
    zipCode: string;
    country: string;
  };
}

export class BookingService {
  /**
   * Atomically decrements slot capacity to prevent overbooking
   * Uses MongoDB findOneAndUpdate with atomic operation
   */
  private async reserveSlotCapacity(
    slotId: string,
    quantity: number
  ): Promise<boolean> {
    try {
      const result = await ServiceSlot.findByIdAndUpdate(
        slotId,
        {
          $inc: { bookedCapacity: quantity },
        },
        {
          new: true,
          runValidators: true,
        }
      );

      if (!result || result.availableCapacity < 0) {
        throw new Error('Capacity check failed');
      }

      return true;
    } catch (error) {
      logger.error({ error, slotId }, 'Failed to reserve slot capacity');
      throw error;
    }
  }

  private async releaseSlotCapacity(
    slotId: string,
    quantity: number
  ): Promise<void> {
    try {
      await ServiceSlot.findByIdAndUpdate(
        slotId,
        {
          $inc: { bookedCapacity: -quantity },
        },
        { new: true }
      );
    } catch (error) {
      logger.error({ error, slotId }, 'Failed to release slot capacity');
    }
  }

  async checkout(
    userId: string,
    payload: CheckoutPayload
  ): Promise<IBooking> {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      // Get user cart
      const cart = await Cart.findOne({ userId }).session(session);
      if (!cart || cart.items.length === 0) {
        throw new ValidationError('Cart is empty', 'EMPTY_CART');
      }

      // Get user
      const user = await User.findById(userId).session(session);
      if (!user) {
        throw new NotFoundError('User');
      }

      // Validate booking limits per day
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const tomorrowStart = new Date(today);
      tomorrowStart.setDate(tomorrowStart.getDate() + 1);

      const bookingsToday = await Booking.countDocuments(
        {
          userId,
          createdAt: {
            $gte: today,
            $lt: tomorrowStart,
          },
          status: { $ne: BookingStatus.CANCELLED },
        },
        { session }
      );

      if (bookingsToday >= config.MAX_BOOKINGS_PER_DAY) {
        throw new ConflictError(
          `Maximum ${config.MAX_BOOKINGS_PER_DAY} bookings per day exceeded`,
          'MAX_BOOKINGS_EXCEEDED'
        );
      }

      // Prepare booking items and reserve capacity
      const bookingItems = [];
      const slotReservations: Array<{ slotId: string; quantity: number }> = [];

      for (const cartItem of cart.items) {
        // Get service
        const service = await Service.findById(cartItem.serviceId).session(session);
        if (!service) {
          throw new NotFoundError('Service');
        }

        // Get slot for the date
        const slotStartDate = new Date(cartItem.date);
        slotStartDate.setHours(0, 0, 0, 0);
        const slotEndDate = new Date(slotStartDate);
        slotEndDate.setHours(23, 59, 59, 999);

        const slot = await ServiceSlot.findOne(
          {
            serviceId: cartItem.serviceId,
            date: {
              $gte: slotStartDate,
              $lte: slotEndDate,
            },
            isActive: true,
            availableCapacity: { $gte: cartItem.quantity },
          },
          null,
          { session }
        );

        if (!slot) {
          throw new ConflictError(
            `No available slots for ${service.title} on selected date`,
            'NO_AVAILABLE_SLOTS'
          );
        }

        // ATOMIC: Reserve capacity
        const updated = await ServiceSlot.findByIdAndUpdate(
          slot._id,
          {
            $inc: { bookedCapacity: cartItem.quantity },
          },
          { new: true, session }
        );

        if (!updated || updated.availableCapacity < 0) {
          throw new ConflictError(
            'Service is now fully booked, please select another slot',
            'SLOT_FULLY_BOOKED'
          );
        }

        slotReservations.push({
          slotId: slot._id.toString(),
          quantity: cartItem.quantity,
        });

        bookingItems.push({
          serviceId: cartItem.serviceId,
          title: service.title,
          quantity: cartItem.quantity,
          date: cartItem.date,
          startTime: cartItem.startTime,
          endTime: cartItem.endTime,
          price: cartItem.price,
        });
      }

      // Calculate total amount
      const totalAmount = cart.items.reduce(
        (sum, item) => sum + item.price * item.quantity,
        0
      );

      // Determine payment status based on method
      const paymentStatus =
        payload.paymentMethod === 'cash' || payload.paymentMethod === 'pay_on_arrival'
          ? PaymentStatus.COMPLETED
          : PaymentStatus.PENDING;

      // Create booking
      const booking = new Booking({
        userId,
        items: bookingItems,
        totalAmount,
        status: BookingStatus.PENDING,
        paymentStatus,
        paymentMethod: payload.paymentMethod,
        address: payload.address,
        auditLog: [
          {
            status: BookingStatus.PENDING,
            timestamp: new Date(),
            reason: 'Booking created',
          },
        ],
      });

      await booking.save({ session });

      // If payment not required, confirm immediately
      if (
        payload.paymentMethod === 'cash' ||
        payload.paymentMethod === 'pay_on_arrival'
      ) {
        booking.status = BookingStatus.CONFIRMED;
        booking.auditLog.push({
          status: BookingStatus.CONFIRMED,
          timestamp: new Date(),
          reason: 'Auto-confirmed for cash payment',
        });
        await booking.save({ session });
      }

      // Clear cart
      await Cart.updateOne({ userId }, { items: [] }, { session });

      await session.commitTransaction();
      logger.info(
        { userId, bookingId: booking._id, itemCount: bookingItems.length },
        'Booking created successfully'
      );

      return booking;
    } catch (error) {
      await session.abortTransaction();

      if (
        error instanceof NotFoundError ||
        error instanceof ConflictError ||
        error instanceof ValidationError
      ) {
        throw error;
      }

      logger.error({ error, userId }, 'Checkout failed');
      throw new InternalServerError('Checkout failed');
    } finally {
      session.endSession();
    }
  }

  async getBookings(userId: string): Promise<IBooking[]> {
    try {
      const bookings = await Booking.find({ userId }).sort({ createdAt: -1 });
      return bookings;
    } catch (error) {
      logger.error({ error, userId }, 'Failed to fetch bookings');
      throw new InternalServerError('Failed to fetch bookings');
    }
  }

  async getBookingById(userId: string, bookingId: string): Promise<IBooking> {
    try {
      if (!mongoose.Types.ObjectId.isValid(bookingId)) {
        throw new NotFoundError('Booking');
      }

      const booking = await Booking.findOne({
        _id: bookingId,
        userId,
      });

      if (!booking) {
        throw new NotFoundError('Booking');
      }

      return booking;
    } catch (error) {
      if (error instanceof NotFoundError) {
        throw error;
      }
      logger.error({ error, userId, bookingId }, 'Failed to fetch booking');
      throw new InternalServerError('Failed to fetch booking');
    }
  }

  async cancelBooking(
    userId: string,
    bookingId: string,
    reason?: string
  ): Promise<IBooking> {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      if (!mongoose.Types.ObjectId.isValid(bookingId)) {
        throw new NotFoundError('Booking');
      }

      const booking = await Booking.findOne({
        _id: bookingId,
        userId,
      }).session(session);

      if (!booking) {
        throw new NotFoundError('Booking');
      }

      // Check if booking can be cancelled
      if (
        booking.status === BookingStatus.CANCELLED ||
        booking.status === BookingStatus.FAILED
      ) {
        throw new ConflictError(
          'Booking cannot be cancelled in current state',
          'INVALID_STATUS'
        );
      }

      // Check cancellation cutoff time
      const cutoffTime = new Date();
      cutoffTime.setHours(
        cutoffTime.getHours() - config.BOOKING_CANCELLATION_CUTOFF_HOURS
      );

      if (booking.items[0].date < cutoffTime) {
        throw new ConflictError(
          `Bookings cannot be cancelled within ${config.BOOKING_CANCELLATION_CUTOFF_HOURS} hours of service`,
          'CANCELLATION_CUTOFF_EXCEEDED'
        );
      }

      // Release capacity for all items
      for (const item of booking.items) {
        // Find the slot and release capacity
        const slotStartDate = new Date(item.date);
        slotStartDate.setHours(0, 0, 0, 0);
        const slotEndDate = new Date(slotStartDate);
        slotEndDate.setHours(23, 59, 59, 999);

        await ServiceSlot.findOneAndUpdate(
          {
            serviceId: item.serviceId,
            date: { $gte: slotStartDate, $lte: slotEndDate },
            startTime: item.startTime,
          },
          {
            $inc: { bookedCapacity: -item.quantity },
          },
          { session }
        );
      }

      // Update booking status
      booking.status = BookingStatus.CANCELLED;
      booking.cancellationReason = reason;
      booking.cancellationTime = new Date();

      booking.auditLog.push({
        status: BookingStatus.CANCELLED,
        timestamp: new Date(),
        reason: reason || 'User cancelled',
      });

      // If payment was pending, mark as refunded
      if (booking.paymentStatus === PaymentStatus.COMPLETED) {
        booking.paymentStatus = PaymentStatus.REFUNDED;
      }

      await booking.save({ session });
      await session.commitTransaction();

      logger.info({ userId, bookingId }, 'Booking cancelled');
      return booking;
    } catch (error) {
      await session.abortTransaction();

      if (
        error instanceof NotFoundError ||
        error instanceof ConflictError
      ) {
        throw error;
      }

      logger.error({ error, userId, bookingId }, 'Failed to cancel booking');
      throw new InternalServerError('Failed to cancel booking');
    } finally {
      session.endSession();
    }
  }

  async confirmPayment(bookingId: string, paymentReference: string): Promise<IBooking> {
    try {
      const booking = await Booking.findByIdAndUpdate(
        bookingId,
        {
          status: BookingStatus.CONFIRMED,
          paymentStatus: PaymentStatus.COMPLETED,
          paymentReference,
          $push: {
            auditLog: {
              status: BookingStatus.CONFIRMED,
              timestamp: new Date(),
              reason: 'Payment confirmed',
              metadata: { paymentReference },
            },
          },
        },
        { new: true }
      );

      if (!booking) {
        throw new NotFoundError('Booking');
      }

      logger.info({ bookingId, paymentReference }, 'Booking confirmed via payment');
      return booking;
    } catch (error) {
      logger.error({ error, bookingId }, 'Failed to confirm payment');
      throw new InternalServerError('Failed to confirm payment');
    }
  }

  async failPayment(bookingId: string, reason?: string): Promise<IBooking> {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const booking = await Booking.findById(bookingId).session(session);

      if (!booking) {
        throw new NotFoundError('Booking');
      }

      // Release capacity
      for (const item of booking.items) {
        const slotStartDate = new Date(item.date);
        slotStartDate.setHours(0, 0, 0, 0);
        const slotEndDate = new Date(slotStartDate);
        slotEndDate.setHours(23, 59, 59, 999);

        await ServiceSlot.findOneAndUpdate(
          {
            serviceId: item.serviceId,
            date: { $gte: slotStartDate, $lte: slotEndDate },
            startTime: item.startTime,
          },
          {
            $inc: { bookedCapacity: -item.quantity },
          },
          { session }
        );
      }

      booking.status = BookingStatus.FAILED;
      booking.paymentStatus = PaymentStatus.FAILED;
      booking.auditLog.push({
        status: BookingStatus.FAILED,
        timestamp: new Date(),
        reason: reason || 'Payment failed',
      });

      await booking.save({ session });
      await session.commitTransaction();

      logger.info({ bookingId }, 'Booking marked as failed');
      return booking;
    } catch (error) {
      await session.abortTransaction();
      logger.error({ error, bookingId }, 'Failed to mark booking as failed');
      throw new InternalServerError('Failed to process payment failure');
    } finally {
      session.endSession();
    }
  }
}

export const bookingService = new BookingService();