import { User, IUser } from '../models/User';
import { TokenService } from './TokenService';
import { logger } from '../config/logger';
import {
  AuthenticationError,
  ValidationError,
  ConflictError,
  InternalServerError,
} from '../utils/errors';

export interface SignupPayload {
  name: string;
  email: string;
  password: string;
}

export interface LoginPayload {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: {
    id: string;
    name: string;
    email: string;
  };
  accessToken: string;
  refreshToken?: string;
  expiresIn: string;
}

export class AuthService {
  async signup(payload: SignupPayload): Promise<AuthResponse> {
    try {
      const { name, email, password } = payload;

      // Check if user already exists
      const existingUser = await User.findOne({ email: email.toLowerCase() });
      if (existingUser) {
        throw new ConflictError('Email already registered', 'EMAIL_TAKEN');
      }

      // Create new user
      const user = new User({
        name: name.trim(),
        email: email.toLowerCase(),
        password,
      });

      await user.save();
      logger.info({ userId: user._id, email: user.email }, 'User registered');

      // Generate tokens
      const tokens = TokenService.generateTokens(user._id.toString());

      return {
        user: {
          id: user._id.toString(),
          name: user.name,
          email: user.email,
        },
        ...tokens,
      };
    } catch (error) {
      if (error instanceof ConflictError) {
        throw error;
      }
      logger.error({ error }, 'Signup failed');
      throw new InternalServerError('Registration failed');
    }
  }

  async login(payload: LoginPayload): Promise<AuthResponse> {
    try {
      const { email, password } = payload;

      // Find user and explicitly select password field
      const user = await User.findOne({ email: email.toLowerCase() }).select(
        '+password'
      );

      if (!user) {
        throw new AuthenticationError('Invalid credentials', 'INVALID_EMAIL');
      }

      // Compare passwords
      const isPasswordValid = await user.comparePassword(password);
      if (!isPasswordValid) {
        logger.warn({ email }, 'Failed login attempt');
        throw new AuthenticationError('Invalid credentials', 'INVALID_PASSWORD');
      }

      logger.info({ userId: user._id, email: user.email }, 'User logged in');

      // Generate tokens
      const tokens = TokenService.generateTokens(user._id.toString());

      return {
        user: {
          id: user._id.toString(),
          name: user.name,
          email: user.email,
        },
        ...tokens,
      };
    } catch (error) {
      if (error instanceof AuthenticationError) {
        throw error;
      }
      logger.error({ error }, 'Login failed');
      throw new InternalServerError('Login failed');
    }
  }

  async getCurrentUser(userId: string): Promise<{
    id: string;
    name: string;
    email: string;
  }> {
    try {
      const user = await User.findById(userId);

      if (!user) {
        throw new AuthenticationError('User not found', 'USER_NOT_FOUND');
      }

      return {
        id: user._id.toString(),
        name: user.name,
        email: user.email,
      };
    } catch (error) {
      if (error instanceof AuthenticationError) {
        throw error;
      }
      logger.error({ error, userId }, 'Failed to get current user');
      throw new InternalServerError('Failed to get user');
    }
  }

  async refreshAccessToken(refreshToken: string): Promise<{
    accessToken: string;
    expiresIn: string;
  }> {
    try {
      const payload = TokenService.verifyRefreshToken(refreshToken);

      const user = await User.findById(payload.userId);
      if (!user) {
        throw new AuthenticationError('User not found', 'USER_NOT_FOUND');
      }

      const newAccessToken = TokenService.generateAccessToken(user._id.toString());

      return {
        accessToken: newAccessToken,
        expiresIn: '24h',
      };
    } catch (error) {
      logger.debug({ error }, 'Token refresh failed');
      throw new AuthenticationError('Invalid refresh token', 'INVALID_TOKEN');
    }
  }
}

export const authService = new AuthService();