import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';

class TrackBookingPage extends StatefulWidget {
  final String bookingId;

  const TrackBookingPage({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<TrackBookingPage> createState() => _TrackBookingPageState();
}

class _TrackBookingPageState extends State<TrackBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Booking'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.paddingDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Info Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking ID',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.bookingId.substring(0, 8),
                            style: AppTypography.headingSmall,
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.confirmed.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Text(
                          'Confirmed',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.confirmed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Timeline
            Text(
              'Service Timeline',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 20),

            // Timeline Items
            _buildTimelineItem(
              title: 'Booking Confirmed',
              subtitle: 'May 10, 2026 - 2:30 PM',
              isCompleted: true,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Payment Received',
              subtitle: 'May 10, 2026 - 2:35 PM',
              isCompleted: true,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Service Assigned',
              subtitle: 'May 10, 2026 - 2:40 PM',
              isCompleted: true,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'On the Way',
              subtitle: 'May 15, 2026 - 9:30 AM',
              isCompleted: false,
              isLast: false,
            ),
            _buildTimelineItem(
              title: 'Service Completed',
              subtitle: 'May 15, 2026 - 11:00 AM',
              isCompleted: false,
              isLast: true,
            ),

            const SizedBox(height: 32),

            // Service Provider Info
            Text(
              'Service Provider',
              style: AppTypography.headingMedium,
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusDefault),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusCircle),
                    ),
                    child: Center(
                      child: Text(
                        'JD',
                        style: AppTypography.headingMedium.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: AppTypography.headingSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                            
                             Icons.star,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '4.8 (120 reviews)',
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.phone, color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Dot & Line
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isCompleted ? AppColors.confirmed : AppColors.lightGrey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted ? AppColors.confirmed : AppColors.grey,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 12,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isCompleted ? AppColors.confirmed : AppColors.lightGrey,
              ),
          ],
        ),
        const SizedBox(width: 16),

        // Content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                if (!isLast) const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}