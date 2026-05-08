import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/constants/app_colors.dart';
import 'package:mentecart_mobile/core/constants/app_typography.dart';
import 'package:mentecart_mobile/core/constants/app_strings.dart';
import 'package:mentecart_mobile/core/constants/app_dimensions.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_event.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_state.dart';
import 'package:mentecart_mobile/presentation/widgets/booking/booking_card.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const GetBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.bookings),
        elevation: 0,
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BookingsLoaded) {
            final bookings = state.bookings;

            if (bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bookmark_outline,
                      size: 80,
                      color: AppColors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noBookings,
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/home');
                      },
                      child: const Text(AppStrings.browseServices),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingDefault),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingCard(
                  booking: booking,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/booking-detail',
                      arguments: booking.id,
                    );
                  },
                );
              },
            );
          } else if (state is BookingError) {
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