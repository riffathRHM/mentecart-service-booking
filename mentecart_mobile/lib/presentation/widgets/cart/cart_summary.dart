import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';
import 'package:mentecart_mobile/domain/entities/cart/cart.dart';

class CartSummaryWidget extends StatelessWidget {
  final Cart cart;
  final VoidCallback onCheckout;

  const CartSummaryWidget({
    Key? key,
    required this.cart,
    required this.onCheckout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingDefault),
      decoration: BoxDecoration(
        color: AppColors.veryLightGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusLarge),
          topRight: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTypography.bodyMedium,
              ),
              Text(
                '\$${cart.totalPrice.toStringAsFixed(2)}',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Taxes',
                style: AppTypography.bodyMedium,
              ),
              Text(
                '\$0.00',
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Divider(color: AppColors.lightGrey),
          const SizedBox(height: 12),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTypography.headingMedium,
              ),
              Text(
                '\$${cart.totalPrice.toStringAsFixed(2)}',
                style: AppTypography.headingMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Checkout Button
          SizedBox(
            width: double.infinity,
            height: AppDimensions.buttonHeightLarge,
            child: ElevatedButton(
              onPressed: onCheckout,
              child: Text(
                'Proceed to Checkout',
                style: AppTypography.button.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}