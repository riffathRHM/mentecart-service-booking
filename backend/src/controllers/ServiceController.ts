import { Request, Response } from 'express';
import { serviceService } from '../services/ServiceService';

export class ServiceController {

  static async getServices(req: Request, res: Response): Promise<void> {
    const page =
      typeof req.query.page === 'string'
        ? parseInt(req.query.page)
        : 1;

    const limit =
      typeof req.query.limit === 'string'
        ? parseInt(req.query.limit)
        : 20;

    const category =
      typeof req.query.category === 'string'
        ? req.query.category
        : undefined;

    const search =
      typeof req.query.search === 'string'
        ? req.query.search
        : undefined;

    const result = await serviceService.getServices({
      page,
      limit,
      category,
      search,
    });

    res.status(200).json({
      statusCode: 200,
      message: 'Services retrieved successfully',
      data: result,
    });
  }

  static async getServiceById(req: Request, res: Response): Promise<void> {
    const id =
      typeof req.params.id === 'string'
        ? req.params.id
        : undefined;

    if (!id) {
      res.status(400).json({
        statusCode: 400,
        message: 'Invalid service id',
        errorCode: 'INVALID_ID',
      });
      return;
    }

    const service = await serviceService.getServiceById(id);

    res.status(200).json({
      statusCode: 200,
      message: 'Service retrieved successfully',
      data: service,
    });
  }

  static async getServiceWithSlots(req: Request, res: Response): Promise<void> {
    const id =
      typeof req.params.id === 'string'
        ? req.params.id
        : undefined;

    if (!id) {
      res.status(400).json({
        statusCode: 400,
        message: 'Invalid service id',
        errorCode: 'INVALID_ID',
      });
      return;
    }

    const fromDate = new Date();

    const result = await serviceService.getServiceWithSlots(id, fromDate);

    res.status(200).json({
      statusCode: 200,
      message: 'Service with slots retrieved successfully',
      data: result,
    });
  }

  static async getAvailableSlots(req: Request, res: Response): Promise<void> {
    const id =
      typeof req.params.id === 'string'
        ? req.params.id
        : undefined;

    const date =
      typeof req.query.date === 'string'
        ? req.query.date
        : undefined;

    if (!id) {
      res.status(400).json({
        statusCode: 400,
        message: 'Invalid service id',
        errorCode: 'INVALID_ID',
      });
      return;
    }

    if (!date) {
      res.status(400).json({
        statusCode: 400,
        message: 'Date query parameter is required',
        errorCode: 'MISSING_DATE',
      });
      return;
    }

    const slots = await serviceService.getAvailableSlots(
      id,
      new Date(date)
    );

    res.status(200).json({
      statusCode: 200,
      message: 'Available slots retrieved successfully',
      data: slots,
    });
  }
}