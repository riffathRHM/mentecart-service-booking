import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';

class PaymentMethodWidget extends StatelessWidget {
  final String selectedMethod;
  final Function(String) onMethodChanged;

  const PaymentMethodWidget({
    Key? key,
    required this.selectedMethod,
    required this.onMethodChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildPaymentOption(
          'cash',
          'Cash',
          Icons.payments,
          'Pay cash on arrival',
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'card',
          'Credit Card',
          Icons.credit_card,
          'Pay with debit/credit card',
        ),
        const SizedBox(height: 12),
        _buildPaymentOption(
          'paypal',
          'PayPal',
          Icons.account_balance_wallet,
          'Pay with PayPal',
        ),
      ],
    );
  }

  Widget _buildPaymentOption(
    String value,
    String title,
    IconData icon,
    String subtitle,
  ) {
    final isSelected = selectedMethod == value;
    return GestureDetector(
      onTap: () => onMethodChanged(value),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusDefault),
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: selectedMethod,
              onChanged: (newValue) => onMethodChanged(newValue!),
              activeColor: AppColors.primary,
            ),
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}