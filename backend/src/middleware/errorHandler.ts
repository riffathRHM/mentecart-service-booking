import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors';
import { logger } from '../config/logger';

interface ErrorResponse {
  statusCode: number;
  message: string;
  errorCode?: string;
  details?: unknown;
  [key: string]: unknown;
}

export const errorHandler = (
  error: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  // Log error
  if (error instanceof AppError) {
    logger.warn(
      {
        statusCode: error.statusCode,
        errorCode: error.errorCode,
        path: req.path,
        method: req.method,
      },
      error.message
    );
  } else {
    logger.error(
      {
        error,
        path: req.path,
        method: req.method,
      },
      'Unhandled error'
    );
  }

  // Handle AppError
  if (error instanceof AppError) {
    const response: ErrorResponse = {
      statusCode: error.statusCode,
      message: error.message,
      ...(error.errorCode && { errorCode: error.errorCode }),
    };

    res.status(error.statusCode).json(response);
    return;
  }

  // Handle MongoDB duplicate key error
  const mongoError = error as any;

  if (error.name === 'MongoServerError' && mongoError.code === 11000) {
    const field = Object.keys(mongoError.keyPattern || {})[0];

    res.status(409).json({
      statusCode: 409,
      message: `${field} already exists`,
      errorCode: 'DUPLICATE_ENTRY',
    });
    return;
  }

  // Handle Mongoose validation error
  if (error.name === 'ValidationError') {
    const validationError = error as any;

    res.status(400).json({
      statusCode: 400,
      message: 'Validation error',
      errorCode: 'VALIDATION_ERROR',
      details: validationError.errors,
    });
    return;
  }

  // Default error response
  res.status(500).json({
    statusCode: 500,
    message: 'Internal server error',
    errorCode: 'INTERNAL_ERROR',
  });
};

export const asyncHandler = (
  fn: (req: Request, res: Response, next: NextFunction) => Promise<void>
) => {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
};