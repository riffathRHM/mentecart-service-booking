import mongoose, { Document, Schema } from 'mongoose';

export interface IServiceSlot extends Document {
  serviceId: mongoose.Types.ObjectId;
  date: Date;
  startTime: string; // HH:MM format
  endTime: string; // HH:MM format
  totalCapacity: number;
  bookedCapacity: number;
  availableCapacity: number;
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const serviceSlotSchema = new Schema<IServiceSlot>(
  {
    serviceId: {
      type: Schema.Types.ObjectId,
      ref: 'Service',
      required: true,
      index: true,
    },
    date: {
      type: Date,
      required: true,
      index: true,
    },
    startTime: {
      type: String,
      required: true,
      match: [/^\d{2}:\d{2}$/, 'Start time must be in HH:MM format'],
    },
    endTime: {
      type: String,
      required: true,
      match: [/^\d{2}:\d{2}$/, 'End time must be in HH:MM format'],
    },
    totalCapacity: {
      type: Number,
      required: true,
      min: 1,
    },
    bookedCapacity: {
      type: Number,
      default: 0,
      min: 0,
    },
    availableCapacity: {
      type: Number,
      required: true,
      min: 0,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for efficient slot lookup
serviceSlotSchema.index({ serviceId: 1, date: 1 });
serviceSlotSchema.index({ serviceId: 1, date: 1, isActive: 1 });

// Validator to ensure availableCapacity = totalCapacity - bookedCapacity
serviceSlotSchema.pre('save', async function () {
  this.availableCapacity = this.totalCapacity - this.bookedCapacity;
  if (this.availableCapacity < 0) {
    throw new Error('Available capacity cannot be negative');
  }
});

export const ServiceSlot = mongoose.model<IServiceSlot>('ServiceSlot', serviceSlotSchema);