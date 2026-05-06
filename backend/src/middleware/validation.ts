import { Request, Response, NextFunction } from 'express';
import { z, ZodError } from 'zod';
import { logger } from '../config/logger';

export const validateRequest = <T extends z.ZodType>(schema: T) => {
  return async (req: Request, res: Response, next: NextFunction) => {
    try {
      const data = {
        body: req.body,
        query: req.query,
        params: req.params,
      };

      const validated: z.infer<T> = await schema.parseAsync(data);

      req.body = (validated as any).body ?? req.body;
      req.query = (validated as any).query ?? req.query;
      req.params = (validated as any).params ?? req.params;

      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const messages = error.issues
          .map((err) => `${err.path.join('.')}: ${err.message}`)
          .join(', ');

        logger.warn({ validationErrors: error.issues }, 'Validation failed');

        return res.status(400).json({
          statusCode: 400,
          message: `Validation failed: ${messages}`,
          errorCode: 'VALIDATION_ERROR',
        });
      }

      next(error);
    }
  };
};

export const validateBody = <T extends z.ZodType>(schema: T) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const validated: z.infer<T> = schema.parse(req.body);

      req.body = validated;
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const messages = error.issues
          .map((err) => `${err.path.join('.')}: ${err.message}`)
          .join(', ');

        logger.warn({ validationErrors: error.issues }, 'Body validation failed');

        return res.status(400).json({
          statusCode: 400,
          message: `Validation failed: ${messages}`,
          errorCode: 'VALIDATION_ERROR',
        });
      }

      next(error);
    }
  };
};

export const validateQuery = <T extends z.ZodType>(schema: T) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const validated: z.infer<T> = schema.parse(req.query);

      req.query = validated as any;
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        const messages = error.issues
          .map((err) => `${err.path.join('.')}: ${err.message}`)
          .join(', ');

        logger.warn({ validationErrors: error.issues }, 'Query validation failed');

        return res.status(400).json({
          statusCode: 400,
          message: `Validation failed: ${messages}`,
          errorCode: 'VALIDATION_ERROR',
        });
      }

      next(error);
    }
  };
};