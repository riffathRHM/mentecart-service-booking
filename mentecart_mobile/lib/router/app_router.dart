import 'package:flutter/material.dart';
import '../presentation/pages/auth/signup_page.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/home/home_page.dart';
class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashPage());

      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case '/signup': 
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case '/home': 
        return MaterialPageRoute(builder: (_) => const HomePage());

       

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Page not found")),
          ),
        );
    }
  }
}