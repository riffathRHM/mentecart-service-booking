import 'package:flutter/material.dart';
import 'package:mentecart_mobile/presentation/pages/auth/login_page.dart';
import 'package:mentecart_mobile/presentation/pages/auth/signup_page.dart';
import 'package:mentecart_mobile/presentation/pages/bookings/booking_detail_page.dart';
import 'package:mentecart_mobile/presentation/pages/bookings/bookings_page.dart';
import 'package:mentecart_mobile/presentation/pages/bookings/track_booking_page.dart';
import 'package:mentecart_mobile/presentation/pages/cart/cart_page.dart';
import 'package:mentecart_mobile/presentation/pages/cart/checkout_page.dart';
import 'package:mentecart_mobile/presentation/pages/home/home_page.dart';
import 'package:mentecart_mobile/presentation/pages/service_detail/service_detail_page.dart';
import 'package:mentecart_mobile/presentation/pages/splash/splash_page.dart';
import 'routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Splash & Auth Routes
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashPage(),
          settings: settings,
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );

      case AppRoutes.signup:
        return MaterialPageRoute(
          builder: (_) => const SignupPage(),
          settings: settings,
        );

      // Home Route
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );

      // Service Detail Route
      case AppRoutes.serviceDetail:
        final serviceId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ServiceDetailPage(serviceId: serviceId),
          settings: settings,
        );

      // Cart Routes
      case AppRoutes.cart:
        return MaterialPageRoute(
          builder: (_) => const CartPage(),
          settings: settings,
        );

      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => const CheckoutPage(),
          settings: settings,
        );

      // Booking Routes
      case AppRoutes.bookings:
        return MaterialPageRoute(
          builder: (_) => const BookingsPage(),
          settings: settings,
        );

      case AppRoutes.bookingDetail:
        final bookingId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BookingDetailPage(bookingId: bookingId),
          settings: settings,
        );

      case AppRoutes.trackBooking:
        final bookingId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TrackBookingPage(bookingId: bookingId),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}