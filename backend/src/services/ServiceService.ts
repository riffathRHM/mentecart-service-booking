import { Service, IService } from '../models/Service';
import { ServiceSlot, IServiceSlot } from '../models/ServiceSlot';
import { logger } from '../config/logger';
import { NotFoundError, InternalServerError } from '../utils/errors';
import mongoose from 'mongoose';

export interface ServiceQuery {
  page: number;
  limit: number;
  category?: string;
  search?: string;
}

export interface ServiceListResponse {
  services: IService[];
  total: number;
  page: number;
  limit: number;
  hasMore: boolean;
}

export class ServiceService {

  async createService(serviceData: Partial<IService>): Promise<IService> {
    try {
      const service = new Service(serviceData);
      await service.save();

      logger.info(
        { serviceId: service._id, title: service.title },
        'Service created'
      );

      return service;
    } catch (error) {
      logger.error({ error }, 'Failed to create service');
      throw new InternalServerError('Failed to create service');
    }
  }

  async getServices(query: ServiceQuery): Promise<ServiceListResponse> {
    try {
      const { page, limit, category, search } = query;
      const skip = (page - 1) * limit;

      const filter: any = { isActive: true };

      if (category) {
        filter.category = category;
      }

      if (search) {
        filter.$or = [
          { title: { $regex: search, $options: 'i' } },
          { description: { $regex: search, $options: 'i' } },
        ];
      }

      const [services, total] = await Promise.all([
        Service.find(filter).skip(skip).limit(limit).lean(),
        Service.countDocuments(filter),
      ]);

      return {
        services,
        total,
        page,
        limit,
        hasMore: skip + limit < total,
      };
    } catch (error) {
      logger.error({ error }, 'Failed to fetch services');
      throw new InternalServerError('Failed to fetch services');
    }
  }

  async getServiceById(serviceId: string): Promise<IService> {
    try {
      if (!mongoose.Types.ObjectId.isValid(serviceId)) {
        throw new NotFoundError('Service');
      }

      const service = await Service.findById(serviceId);

      if (!service) {
        throw new NotFoundError('Service');
      }

      return service;
    } catch (error) {
      if (error instanceof NotFoundError) {
        throw error;
      }
      logger.error({ error, serviceId }, 'Failed to fetch service');
      throw new InternalServerError('Failed to fetch service');
    }
  }

  async getServiceWithSlots(
    serviceId: string,
    fromDate: Date
  ): Promise<{
    service: IService;
    slots: IServiceSlot[];
  }> {
    try {
      if (!mongoose.Types.ObjectId.isValid(serviceId)) {
        throw new NotFoundError('Service');
      }

      const service = await Service.findById(serviceId);

      if (!service) {
        throw new NotFoundError('Service');
      }

      const toDate = new Date(fromDate);
      toDate.setDate(toDate.getDate() + 30);

      const slots = await ServiceSlot.find({
        serviceId,
        date: {
          $gte: fromDate,
          $lt: toDate,
        },
        isActive: true,
        availableCapacity: { $gt: 0 },
      }).sort({ date: 1, startTime: 1 });

      return {
        service,
        slots: slots as unknown as IServiceSlot[],
      };
    } catch (error) {
      if (error instanceof NotFoundError) {
        throw error;
      }

      logger.error({ error, serviceId }, 'Failed to fetch service with slots');
      throw new InternalServerError('Failed to fetch service details');
    }
  }

  async getAvailableSlots(
    serviceId: string,
    date: Date
  ): Promise<IServiceSlot[]> {
    try {
      if (!mongoose.Types.ObjectId.isValid(serviceId)) {
        throw new NotFoundError('Service');
      }

      const startOfDay = new Date(date);
      startOfDay.setHours(0, 0, 0, 0);

      const endOfDay = new Date(date);
      endOfDay.setHours(23, 59, 59, 999);

      const slots = await ServiceSlot.find({
        serviceId,
        date: {
          $gte: startOfDay,
          $lte: endOfDay,
        },
        isActive: true,
        availableCapacity: { $gt: 0 },
      }).sort({ startTime: 1 });

      return slots as unknown as IServiceSlot[];
    } catch (error) {
      logger.error({ error, serviceId }, 'Failed to fetch available slots');
      throw new InternalServerError('Failed to fetch available slots');
    }
  }

  async createSlots(
    serviceId: string,
    slots: Partial<IServiceSlot>[]
  ): Promise<IServiceSlot[]> {
    try {
      if (!mongoose.Types.ObjectId.isValid(serviceId)) {
        throw new NotFoundError('Service');
      }

      const service = await Service.findById(serviceId);

      if (!service) {
        throw new NotFoundError('Service');
      }

      // 🔥 FIX: ensure serviceId is always set
      const enrichedSlots = slots.map((slot) => ({
        ...slot,
        serviceId: new mongoose.Types.ObjectId(serviceId),
      }));

      const createdSlots = await ServiceSlot.insertMany(enrichedSlots);

      logger.info(
        { serviceId, count: createdSlots.length },
        'Slots created'
      );

      return createdSlots as unknown as IServiceSlot[];
    } catch (error) {
      logger.error({ error, serviceId }, 'Failed to create slots');
      throw new InternalServerError('Failed to create slots');
    }
  }
}

export const serviceService = new ServiceService();