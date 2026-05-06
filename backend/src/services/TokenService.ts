import jwt from 'jsonwebtoken';
import config from '../config/env';
import { logger } from '../config/logger';

export interface ITokenPayload {
  userId: string;
  iat?: number;
  exp?: number;
}

export interface IToken {
  accessToken: string;
  refreshToken?: string;
  expiresIn: string;
}

export class TokenService {
  static generateAccessToken(userId: string): string {
    try {
      return jwt.sign({ userId }, config.JWT_SECRET, {
        expiresIn: config.JWT_EXPIRY,
        issuer: 'mentecart',
        audience: 'mentecart-app',
      });
    } catch (error) {
      logger.error({ error }, 'Failed to generate access token');
      throw error;
    }
  }

  static generateRefreshToken(userId: string): string | undefined {
    if (!config.JWT_REFRESH_SECRET) return undefined;

    try {
      return jwt.sign({ userId }, config.JWT_REFRESH_SECRET, {
        expiresIn: config.JWT_REFRESH_EXPIRY,
        issuer: 'mentecart',
      });
    } catch (error) {
      logger.error({ error }, 'Failed to generate refresh token');
      throw error;
    }
  }

  static generateTokens(userId: string): IToken {
    const accessToken = this.generateAccessToken(userId);
    const refreshToken = this.generateRefreshToken(userId);

    return {
      accessToken,
      refreshToken,
      expiresIn: config.JWT_EXPIRY,
    };
  }

  static verifyAccessToken(token: string): ITokenPayload {
    try {
      return jwt.verify(token, config.JWT_SECRET, {
        issuer: 'mentecart',
        audience: 'mentecart-app',
      }) as ITokenPayload;
    } catch (error) {
      logger.debug({ error }, 'Access token verification failed');
      throw error;
    }
  }

  static verifyRefreshToken(token: string): ITokenPayload {
    if (!config.JWT_REFRESH_SECRET) {
      throw new Error('Refresh tokens not enabled');
    }

    try {
      return jwt.verify(token, config.JWT_REFRESH_SECRET, {
        issuer: 'mentecart',
      }) as ITokenPayload;
    } catch (error) {
      logger.debug({ error }, 'Refresh token verification failed');
      throw error;
    }
  }
}