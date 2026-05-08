import { Response } from 'express';
import { bookingService } from '../services/BookingService';
import { AuthRequest } from '../middleware/auth';
import { getParamId } from '../utils/getParamId';

export class BookingController {

  static async checkout(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      });
      return;
    }

    const { paymentMethod, address } = req.body;

    const booking = await bookingService.checkout(req.userId, {
      paymentMethod: paymentMethod || 'cash',
      address,
    });

    res.status(201).json({
      statusCode: 201,
      message: 'Booking created successfully',
      data: booking,
    });
  }

  static async getBookings(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      });
      return;
    }

    const bookings = await bookingService.getBookings(req.userId);

    res.status(200).json({
      statusCode: 200,
      message: 'Bookings retrieved successfully',
      data: bookings,
    });
  }

  static async getBookingById(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      });
      return;
    }

    const id = getParamId(req.params.id);

    if (!id) {
      res.status(400).json({
        statusCode: 400,
        message: 'Invalid booking id',
        errorCode: 'INVALID_ID',
      });
      return;
    }

    const booking = await bookingService.getBookingById(req.userId, id);

    res.status(200).json({
      statusCode: 200,
      message: 'Booking retrieved successfully',
      data: booking,
    });
  }

  static async cancelBooking(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      });
      return;
    }

    const id = getParamId(req.params.id);

    if (!id) {
      res.status(400).json({
        statusCode: 400,
        message: 'Invalid booking id',
        errorCode: 'INVALID_ID',
      });
      return;
    }

    const { reason } = req.body;

    const booking = await bookingService.cancelBooking(
      req.userId,
      id,
      reason
    );

    res.status(200).json({
      statusCode: 200,
      message: 'Booking cancelled successfully',
      data: booking,
    });
  }
}