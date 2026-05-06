import 'express-async-errors';
import express, { Request, Response } from 'express';
import cors from 'cors';
import config from './src/config/env';
import { connectDB } from './src/config/database';
import { logger, createRequestLogger } from './src/config/logger';
import { errorHandler } from './src/middleware/errorHandler';
import apiRouter from './src/routes';

const app = express();

// ============ Middleware ============

// Body parsing
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ limit: '10mb', extended: true }));

// CORS
app.use(
  cors({
    origin: config.CORS_ORIGIN,
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    maxAge: 86400, // 24 hours
  })
);

// Request logging
app.use((req, res, next) => {
  createRequestLogger(req, res);
  next();
});

// ============ Health Check ============

app.get('/health', (req: Request, res: Response) => {
  res.status(200).json({
    statusCode: 200,
    message: 'Server is running',
    data: {
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
    },
  });
});

// ============ API Routes ============

app.use('/api', apiRouter);

// ============ 404 Handler ============

app.use((req: Request, res: Response) => {
  res.status(404).json({
    statusCode: 404,
    message: `Route ${req.path} not found`,
    errorCode: 'NOT_FOUND',
  });
});

// ============ Error Handler ============

app.use(errorHandler);

// ============ Database Connection & Server Start ============

const startServer = async () => {
  try {
    // Connect to MongoDB
    await connectDB();

    // Start listening
    const server = app.listen(config.PORT, () => {
      logger.info(
        {
          port: config.PORT,
          environment: config.NODE_ENV,
          apiUrl: `http://localhost:${config.PORT}/api`,
        },
        '✓ Server started successfully'
      );
    });

    // Graceful shutdown
    process.on('SIGTERM', async () => {
      logger.info('SIGTERM signal received: closing HTTP server');
      server.close(async () => {
        logger.info('HTTP server closed');
        process.exit(0);
      });
    });

    process.on('SIGINT', async () => {
      logger.info('SIGINT signal received: closing HTTP server');
      server.close(async () => {
        logger.info('HTTP server closed');
        process.exit(0);
      });
    });
  } catch (error) {
    logger.error({ error }, 'Failed to start server');
    process.exit(1);
  }
};

// Start the server
startServer();

export default app;