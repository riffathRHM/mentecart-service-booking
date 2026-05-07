import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  Size get screenSize => mediaQuery.size;

  double get screenWidth => screenSize.width;

  double get screenHeight => screenSize.height;

  EdgeInsets get padding => mediaQuery.padding;

  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  bool get isPortrait => mediaQuery.orientation == Orientation.portrait;

  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  bool get isPhoneScreen => screenWidth < 600;

  bool get isTabletScreen => screenWidth >= 600 && screenWidth < 1200;

  bool get isDesktopScreen => screenWidth >= 1200;

  double get topPadding => padding.top;

  double get bottomPadding => padding.bottom;

  void showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T, TO>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  void pop<T>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}