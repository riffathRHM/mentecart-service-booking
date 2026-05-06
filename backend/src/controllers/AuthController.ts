import { Request, Response } from 'express';
import { authService } from '../services/AuthService';
import { logger } from '../config/logger';
import { AuthRequest } from '../middleware/auth';

export class AuthController {
  static async signup(req: Request, res: Response): Promise<void> {
    const { name, email, password } = req.body;

    const result = await authService.signup({ name, email, password });

    res.status(201).json({
      statusCode: 201,
      message: 'User registered successfully',
      data: result,
    });
  }

  static async login(req: Request, res: Response): Promise<void> {
    const { email, password } = req.body;

    const result = await authService.login({ email, password });

    res.status(200).json({
      statusCode: 200,
      message: 'Login successful',
      data: result,
    });
  }

  static async getCurrentUser(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: 'Unauthorized',
        errorCode: 'UNAUTHORIZED',
      });
      return;
    }

    const user = await authService.getCurrentUser(req.userId);

    res.status(200).json({
      statusCode: 200,
      message: 'User retrieved successfully',
      data: user,
    });
  }

  static async refreshToken(req: Request, res: Response): Promise<void> {
    const { refreshToken } = req.body;

    if (!refreshToken) {
      res.status(400).json({
        statusCode: 400,
        message: 'Refresh token is required',
        errorCode: 'MISSING_REFRESH_TOKEN',
      });
      return;
    }

    const result = await authService.refreshAccessToken(refreshToken);

    res.status(200).json({
      statusCode: 200,
      message: 'Token refreshed successfully',
      data: result,
    });
  }
}