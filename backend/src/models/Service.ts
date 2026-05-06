import mongoose, { Document, Schema } from 'mongoose';

export interface IService extends Document {
  title: string;
  description: string;
  price: number;
  duration: number; // in minutes
  category: string;
  capacityPerSlot: number;
  image?: string;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const serviceSchema = new Schema<IService>(
  {
    title: {
      type: String,
      required: [true, 'Service title is required'],
      trim: true,
      minlength: [3, 'Title must be at least 3 characters'],
      maxlength: [100, 'Title must not exceed 100 characters'],
      index: true,
    },
    description: {
      type: String,
      required: [true, 'Service description is required'],
      minlength: [10, 'Description must be at least 10 characters'],
    },
    price: {
      type: Number,
      required: [true, 'Price is required'],
      min: [0, 'Price cannot be negative'],
    },
    duration: {
      type: Number,
      required: [true, 'Duration is required'],
      min: [15, 'Duration must be at least 15 minutes'],
      max: [480, 'Duration must not exceed 8 hours'],
    },
    category: {
      type: String,
      required: [true, 'Category is required'],
      trim: true,
      index: true,
    },
    capacityPerSlot: {
      type: Number,
      required: [true, 'Capacity per slot is required'],
      min: [1, 'Capacity must be at least 1'],
      max: [100, 'Capacity must not exceed 100'],
    },
    image: {
      type: String,
      validate: {
        validator: function (v: string) {
          return !v || /^https?:\/\/.+\..+/.test(v);
        },
        message: 'Invalid image URL',
      },
    },
    isActive: {
      type: Boolean,
      default: true,
      index: true,
    },
  },
  {
    timestamps: true,
  }
);

// Index for search optimization
serviceSchema.index({ title: 'text', description: 'text' });

export const Service = mongoose.model<IService>('Service', serviceSchema);