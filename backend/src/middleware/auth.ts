import { Request, Response, NextFunction } from 'express';
import { TokenService } from '../services/TokenService';
import { AuthenticationError } from '../utils/errors';
import { logger } from '../config/logger';

export interface AuthRequest extends Request {
  userId?: string;
}

export const authMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
): void => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      throw new AuthenticationError('No authorization header', 'NO_AUTH_HEADER');
    }

    const parts = authHeader.split(' ');
    if (parts.length !== 2 || parts[0].toLowerCase() !== 'bearer') {
      throw new AuthenticationError('Invalid authorization header', 'INVALID_AUTH_FORMAT');
    }

    const token = parts[1];

    try {
      const payload = TokenService.verifyAccessToken(token);
      req.userId = payload.userId;
      next();
    } catch (error) {
      logger.debug({ error }, 'Token verification failed');
      throw new AuthenticationError('Invalid token', 'INVALID_TOKEN');
    }
  } catch (error) {
    if (error instanceof AuthenticationError) {
      res.status(error.statusCode).json({
        statusCode: error.statusCode,
        message: error.message,
        errorCode: error.errorCode,
      });
    } else {
      res.status(500).json({
        statusCode: 500,
        message: 'Authentication failed',
        errorCode: 'AUTH_ERROR',
      });
    }
  }
};

export const optionalAuthMiddleware = (
  req: AuthRequest,
  res: Response,
  next: NextFunction
): void => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      return next();
    }

    const parts = authHeader.split(' ');
    if (parts.length === 2 && parts[0].toLowerCase() === 'bearer') {
      try {
        const payload = TokenService.verifyAccessToken(parts[1]);
        req.userId = payload.userId;
      } catch (error) {
        logger.debug({ error }, 'Optional token verification failed');
        // Continue without authentication
      }
    }

    next();
  } catch (error) {
    next();
  }
};