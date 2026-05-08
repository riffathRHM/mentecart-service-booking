import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_strings.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';
import 'package:mentecart_mobile/core/extensions/context_extensions.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_event.dart';
import 'package:mentecart_mobile/presentation/bloc/service/service_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/service/service_event.dart';
import 'package:mentecart_mobile/presentation/bloc/service/service_state.dart';
import 'package:mentecart_mobile/presentation/widgets/common/loading_widget.dart';
import 'package:mentecart_mobile/presentation/widgets/booking/slot_picker.dart';

class ServiceDetailPage extends StatefulWidget {
  final String serviceId;

  const ServiceDetailPage({
    Key? key,
    required this.serviceId,
  }) : super(key: key);

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage> {
  DateTime? _selectedDate;
  String? _selectedSlot;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(
          GetServiceDetailEvent(serviceId: widget.serviceId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.serviceDetails),
        elevation: 0,
      ),
      body: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          if (state is ServiceLoading) {
            return const LoadingWidget();
          } else if (state is ServiceDetailLoaded) {
            final service = state.service;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service Image
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: AppColors.lightGrey,
                    child: service.image != null
                        ? CachedNetworkImage(
                            imageUrl: service.image!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const LoadingWidget(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : const Icon(Icons.image, size: 80),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(
                      AppDimensions.paddingDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          service.title,
                          style: AppTypography.displaySmall,
                        ),
                        const SizedBox(height: 8),

                        // Category
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSmall),
                          ),
                          child: Text(
                            service.category.toUpperCase(),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Price and Duration Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.price,
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${service.price.toStringAsFixed(2)}',
                                  style: AppTypography.headingMedium.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.duration,
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${service.duration} ${AppStrings.minutes}',
                                  style: AppTypography.headingSmall,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.capacity,
                                  style: AppTypography.caption,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${service.capacityPerSlot}',
                                  style: AppTypography.headingSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Description
                        Text(
                          AppStrings.description,
                          style: AppTypography.headingSmall,
                        ),
                        const SizedBox(height: 8),

                        Text(
                          service.description,
                          style: AppTypography.bodyMedium.copyWith(
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Available Slots
                        Text(
                          AppStrings.availableSlots,
                          style: AppTypography.headingSmall,
                        ),
                        const SizedBox(height: 16),

                        // Date Picker
                        SlotPickerWidget(
                          onDateSelected: (date) {
                            setState(() => _selectedDate = date);
                          },
                          onSlotSelected: (slot) {
                            setState(() => _selectedSlot = slot);
                          },
                        ),
                        const SizedBox(height: 24),

                        // Quantity Selector
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.quantity,
                              style: AppTypography.headingSmall,
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _quantity > 1
                                      ? () {
                                          setState(() => _quantity--);
                                        }
                                      : null,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.lightGrey,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _quantity.toString(),
                                    style: AppTypography.bodyMedium,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    setState(() => _quantity++);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Add to Cart Button
                        SizedBox(
                          width: double.infinity,
                          height: AppDimensions.buttonHeightLarge,
                          child: ElevatedButton(
                            onPressed: _selectedDate != null &&
                                    _selectedSlot != null
                                ? () {
                                    context.read<CartBloc>().add(
                                          AddToCartEvent(
                                            serviceId: service.id,
                                            date: _selectedDate.toString(),
                                            quantity: _quantity,
                                          ),
                                        );
                                    context.showSuccessSnackBar(
                                      'Added to cart',
                                    );
                                    Navigator.pop(context);
                                  }
                                : null,
                            child: Text(
                              AppStrings.addToCart,
                              style: AppTypography.button.copyWith(
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ServiceError) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}