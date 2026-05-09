import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:mentecart_mobile/core/di/injection_container.dart';
import 'package:mentecart_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/service/service_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_bloc.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await setupServiceLocator();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => getIt<AuthBloc>(),
        ),
        BlocProvider<ServiceBloc>(
          create: (_) => getIt<ServiceBloc>(),
        ),
        BlocProvider<CartBloc>(
          create: (_) => getIt<CartBloc>(),
        ),
        BlocProvider<BookingBloc>(
          create: (_) => getIt<BookingBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}