import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_strings.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';
import 'package:mentecart_mobile/core/extensions/context_extensions.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_event.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_state.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_state.dart';
import 'package:mentecart_mobile/presentation/widgets/cart/payment_method.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'cash';
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _zipCodeController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _streetController = TextEditingController();
    _cityController = TextEditingController();
    _zipCodeController = TextEditingController();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.checkout),
        elevation: 0,
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingError) {
            context.showErrorSnackBar(state.message);
          } else if (state is BookingSuccess) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('Booking Confirmed'),
                content: Text('Booking ID: ${state.bookingId}'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/bookings');
                    },
                    child: const Text('View Bookings'),
                  ),
                ],
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingDefault),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                _buildSectionTitle(AppStrings.orderSummary),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      final cart = state.cart;
                      return Container(
                        padding: const EdgeInsets.all(
                          AppDimensions.paddingDefault,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightGrey),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusDefault,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${AppStrings.itemsCount}: ${cart.items.length}',
                                  style: AppTypography.bodyMedium,
                                ),
                                Text(
                                  '\$${cart.totalAmount.toStringAsFixed(2)}',
                                  style: AppTypography.headingSmall.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),

                // Delivery Address
                _buildSectionTitle(AppStrings.address),
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(
                    hintText: AppStrings.street,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusDefault,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Street is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          hintText: AppStrings.city,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusDefault,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _zipCodeController,
                        decoration: InputDecoration(
                          hintText: AppStrings.zipCode,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusDefault,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Zip code is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Payment Method
                _buildSectionTitle(AppStrings.paymentMethod),
                PaymentMethodWidget(
                  selectedMethod: _selectedPaymentMethod,
                  onMethodChanged: (method) {
                    setState(() => _selectedPaymentMethod = method);
                  },
                ),
                const SizedBox(height: 32),

                // Complete Order Button
                BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppDimensions.buttonHeightLarge,
                      child: ElevatedButton(
                        onPressed: state is BookingLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<BookingBloc>().add(
                                        CheckoutEvent(
                                          paymentMethod: _selectedPaymentMethod,
                                          address: {
                                            'street': _streetController.text,
                                            'city': _cityController.text,
                                            'zipCode': _zipCodeController.text,
                                          },
                                        ),
                                      );
                                }
                              },
                        child: state is BookingLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : Text(
                                AppStrings.completeOrder,
                                style: AppTypography.button.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingDefault),
      child: Text(
        title,
        style: AppTypography.headingMedium,
      ),
    );
  }
}