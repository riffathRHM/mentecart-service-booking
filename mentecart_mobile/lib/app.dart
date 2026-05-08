import 'package:flutter/material.dart';
import 'router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MenteCart UI',

      // Splash screen will run first
      initialRoute: '/',

      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}