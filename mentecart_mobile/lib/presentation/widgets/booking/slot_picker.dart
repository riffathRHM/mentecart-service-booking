import 'package:flutter/material.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';

class SlotPickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final Function(String) onSlotSelected;

  const SlotPickerWidget({
    Key? key,
    required this.onDateSelected,
    required this.onSlotSelected,
  }) : super(key: key);

  @override
  State<SlotPickerWidget> createState() => _SlotPickerWidgetState();
}

class _SlotPickerWidgetState extends State<SlotPickerWidget> {
  DateTime? _selectedDate;
  String? _selectedSlot;

  final List<String> _timeSlots = [
    '09:00',
    '10:30',
    '14:00',
    '15:30',
    '17:00',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker
        Text(
          'Select Date',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        GestureDetector(
          onTap: () async {
            final selected = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );

            if (selected != null) {
              setState(() => _selectedDate = selected);
              widget.onDateSelected(selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingDefault,
              vertical: AppDimensions.paddingMedium,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.lightGrey),
              borderRadius: BorderRadius.circular(AppDimensions.radiusDefault),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Pick a date',
                  style: AppTypography.bodyMedium,
                ),
                const Icon(Icons.calendar_today, color: AppColors.primary),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Time Slot Picker
        Text(
          'Select Time',
          style: AppTypography.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: _timeSlots.length,
          itemBuilder: (context, index) {
            final slot = _timeSlots[index];
            final isSelected = _selectedSlot == slot;

            return GestureDetector(
              onTap: () {
                setState(() => _selectedSlot = slot);
                widget.onSlotSelected(slot);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.veryLightGrey,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.lightGrey,
                  ),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusDefault),
                ),
                child: Center(
                  child: Text(
                    slot,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isSelected ? AppColors.white : AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}