import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mentecart_mobile/core/di/injection_container.dart';
import 'package:mentecart_mobile/presentation/router/routes.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: '.env');
  
  // Setup service locator
  await setupServiceLocator();
  
  runApp(const MyApp());
}