import { Request, Response } from "express";
import { cartService } from "../services/CartService";
import { AuthRequest } from "../middleware/auth";

export class CartController {
  static async getCart(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: "Unauthorized",
        errorCode: "UNAUTHORIZED",
      });
      return;
    }

    const cart = await cartService.getCart(req.userId);

    res.status(200).json({
      statusCode: 200,
      message: "Cart retrieved successfully",
      data: cart || { userId: req.userId, items: [], totalAmount: 0 },
    });
  }

  static async addToCart(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: "Unauthorized",
        errorCode: "UNAUTHORIZED",
      });
      return;
    }

    const { serviceId, date, quantity = 1 } = req.body;

    const cart = await cartService.addToCart(req.userId, {
      serviceId,
      date,
      quantity,
    });

    res.status(200).json({
      statusCode: 200,
      message: "Item added to cart successfully",
      data: cart,
    });
  }
  static async updateCartItem(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: "Unauthorized",
        errorCode: "UNAUTHORIZED",
      });
      return;
    }

    const itemId = Array.isArray(req.params.itemId)
      ? req.params.itemId[0]
      : req.params.itemId;

    if (!itemId) {
      res.status(400).json({
        statusCode: 400,
        message: "Invalid item id",
        errorCode: "INVALID_ITEM_ID",
      });
      return;
    }

    const { quantity, date } = req.body;

    const cart = await cartService.updateCartItem(req.userId, itemId, {
      quantity,
      date,
    });

    res.status(200).json({
      statusCode: 200,
      message: "Cart item updated successfully",
      data: cart,
    });
  }
  static async removeFromCart(req: AuthRequest, res: Response): Promise<void> {
    if (!req.userId) {
      res.status(401).json({
        statusCode: 401,
        message: "Unauthorized",
        errorCode: "UNAUTHORIZED",
      });
      return;
    }

    const itemId = Array.isArray(req.params.itemId)
      ? req.params.itemId[0]
      : req.params.itemId;

    if (!itemId) {
      res.status(400).json({
        statusCode: 400,
        message: "Invalid item id",
        errorCode: "INVALID_ITEM_ID",
      });
      return;
    }

    const cart = await cartService.removeFromCart(req.userId, itemId);

    res.status(200).json({
      statusCode: 200,
      message: "Item removed from cart successfully",
      data: cart,
    });
  }
}
