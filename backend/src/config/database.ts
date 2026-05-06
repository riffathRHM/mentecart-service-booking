import mongoose from 'mongoose';
import config from './env';
import { logger } from './logger';

export const connectDB = async (): Promise<void> => {
  try {
    logger.info('Connecting to MongoDB...');
    
    await mongoose.connect(config.MONGO_URI, {
      // Connection pool size
      maxPoolSize: 10,
      minPoolSize: 5,
      // Retry settings
      retryWrites: true,
      w: 'majority',
      // Timeouts
      serverSelectionTimeoutMS: 5000,
      socketTimeoutMS: 45000,
    });

    logger.info('MongoDB connected successfully');
    console.log('Connected DB:', mongoose.connection.name);

    // Handle connection events
    mongoose.connection.on('disconnected', () => {
      logger.warn('MongoDB disconnected');
    });

    mongoose.connection.on('error', (error) => {
      logger.error({ error }, 'MongoDB connection error');
    });
  } catch (error) {
    logger.error({ error }, 'Failed to connect to MongoDB');
    process.exit(1);
  }
};

export const disconnectDB = async (): Promise<void> => {
  try {
    await mongoose.disconnect();
    logger.info('MongoDB disconnected');
  } catch (error) {
    logger.error({ error }, 'Error disconnecting from MongoDB');
    throw error;
  }
};