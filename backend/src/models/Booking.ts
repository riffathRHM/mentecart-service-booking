import mongoose, { Document, Schema } from 'mongoose';

export enum BookingStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  COMPLETED = 'completed',
  CANCELLED = 'cancelled',
  FAILED = 'failed',
}

export enum PaymentStatus {
  PENDING = 'pending',
  COMPLETED = 'completed',
  FAILED = 'failed',
  REFUNDED = 'refunded',
}

export interface IBookingItem {
  serviceId: mongoose.Types.ObjectId;
  title: string;
  quantity: number;
  date: Date;
  startTime: string;
  endTime: string;
  price: number;
}

export interface IAuditLog {
  status: BookingStatus;
  timestamp: Date;
  reason?: string;
  metadata?: Record<string, any>;
}

export interface IBooking extends Document {
  userId: mongoose.Types.ObjectId;
  items: IBookingItem[];
  totalAmount: number;
  status: BookingStatus;
  paymentStatus: PaymentStatus;
  paymentMethod: 'cash' | 'pay_on_arrival' | 'credit_card' | 'payhere';
  address?: {
    street: string;
    city: string;
    zipCode: string;
    country: string;
  };
  auditLog: IAuditLog[];
  paymentReference?: string;
  cancellationReason?: string;
  cancellationTime?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const bookingItemSchema = new Schema<IBookingItem>(
  {
    serviceId: {
      type: Schema.Types.ObjectId,
      ref: 'Service',
      required: true,
    },
    title: {
      type: String,
      required: true,
    },
    quantity: {
      type: Number,
      required: true,
      min: 1,
    },
    date: {
      type: Date,
      required: true,
    },
    startTime: {
      type: String,
      required: true,
    },
    endTime: {
      type: String,
      required: true,
    },
    price: {
      type: Number,
      required: true,
      min: 0,
    },
  },
  { _id: false }
);

const auditLogSchema = new Schema<IAuditLog>(
  {
    status: {
      type: String,
      enum: Object.values(BookingStatus),
      required: true,
    },
    timestamp: {
      type: Date,
      default: Date.now,
    },
    reason: String,
    metadata: Schema.Types.Mixed,
  },
  { _id: false }
);

const bookingSchema = new Schema<IBooking>(
  {
    userId: {
      type: Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      index: true,
    },
    items: {
      type: [bookingItemSchema],
      required: true,
      validate: {
        validator: (v: IBookingItem[]) => v.length > 0,
        message: 'Booking must contain at least one item',
      },
    },
    totalAmount: {
      type: Number,
      required: true,
      min: 0,
    },
    status: {
      type: String,
      enum: Object.values(BookingStatus),
      default: BookingStatus.PENDING,
      index: true,
    },
    paymentStatus: {
      type: String,
      enum: Object.values(PaymentStatus),
      default: PaymentStatus.PENDING,
    },
    paymentMethod: {
      type: String,
      enum: ['cash', 'pay_on_arrival', 'credit_card', 'payhere'],
      required: true,
    },
    address: {
      street: String,
      city: String,
      zipCode: String,
      country: String,
    },
    auditLog: {
      type: [auditLogSchema],
      default: [],
    },
    paymentReference: String,
    cancellationReason: String,
    cancellationTime: Date,
  },
  {
    timestamps: true,
  }
);

// Index for efficient user booking queries
bookingSchema.index({ userId: 1, createdAt: -1 });
bookingSchema.index({ userId: 1, status: 1 });

export const Booking = mongoose.model<IBooking>('Booking', bookingSchema);