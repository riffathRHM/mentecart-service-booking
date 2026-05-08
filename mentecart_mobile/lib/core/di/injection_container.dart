import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mentecart_mobile/core/network/api_interceptor.dart';
import 'package:mentecart_mobile/core/network/api_client.dart';
import 'package:mentecart_mobile/data/datasources/local/auth_local_datasource.dart';
import 'package:mentecart_mobile/data/datasources/remote/auth_remote_datasource.dart';
import 'package:mentecart_mobile/data/datasources/remote/service_remote_datasource.dart';
import 'package:mentecart_mobile/data/datasources/remote/cart_remote_datasource.dart';
import 'package:mentecart_mobile/data/datasources/remote/booking_remote_datasource.dart';
import 'package:mentecart_mobile/domain/repositories/auth_repository.dart';
import 'package:mentecart_mobile/domain/repositories/service_repository.dart';
import 'package:mentecart_mobile/domain/repositories/cart_repository.dart';
import 'package:mentecart_mobile/domain/repositories/booking_repository.dart';
import 'package:mentecart_mobile/domain/usecases/auth/signup_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/service/get_services_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/service/get_service_detail_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/get_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/add_to_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/update_cart_item_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/cart/remove_from_cart_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/booking/checkout_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/booking/get_bookings_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/booking/cancel_booking_usecase.dart';
import 'package:mentecart_mobile/presentation/bloc/auth/auth_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/service/service_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/cart/cart_bloc.dart';
import 'package:mentecart_mobile/presentation/bloc/booking/booking_bloc.dart';

import '../../domain/repositories/auth_repository_impl.dart';
import '../../domain/repositories/booking_repository_impl.dart';
import '../../domain/repositories/cart_repository_impl.dart';
import '../../domain/repositories/service_repository_impl.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox('auth');
  await Hive.openBox('cache');

  // API Client
  getIt.registerSingleton<ApiClient>(ApiClient());

  // Remote Data Sources
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<ServiceRemoteDataSource>(
    ServiceRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<CartRemoteDataSource>(
    CartRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );
  getIt.registerSingleton<BookingRemoteDataSource>(
    BookingRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Local Data Sources
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(),
  );

  // Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerSingleton<ServiceRepository>(
    ServiceRepositoryImpl(
      remoteDataSource: getIt<ServiceRemoteDataSource>(),
    ),
  );
  getIt.registerSingleton<CartRepository>(
    CartRepositoryImpl(
      remoteDataSource: getIt<CartRemoteDataSource>(),
    ),
  );
  getIt.registerSingleton<BookingRepository>(
    BookingRepositoryImpl(
      remoteDataSource: getIt<BookingRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<SignupUsecase>(
    SignupUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LoginUsecase>(
    LoginUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetCurrentUserUsecase>(
    GetCurrentUserUsecase(repository: getIt<AuthRepository>()),
  );
  getIt.registerSingleton<GetServicesUsecase>(
    GetServicesUsecase(repository: getIt<ServiceRepository>()),
  );
  getIt.registerSingleton<GetServiceDetailUsecase>(
    GetServiceDetailUsecase(repository: getIt<ServiceRepository>()),
  );
  getIt.registerSingleton<GetCartUsecase>(
    GetCartUsecase(repository: getIt<CartRepository>()),
  );
  getIt.registerSingleton<AddToCartUsecase>(
    AddToCartUsecase(repository: getIt<CartRepository>()),
  );
  getIt.registerSingleton<UpdateCartItemUsecase>(
    UpdateCartItemUsecase(repository: getIt<CartRepository>()),
  );
  getIt.registerSingleton<RemoveFromCartUsecase>(
    RemoveFromCartUsecase(repository: getIt<CartRepository>()),
  );
  getIt.registerSingleton<CheckoutUsecase>(
    CheckoutUsecase(repository: getIt<BookingRepository>()),
  );
  getIt.registerSingleton<GetBookingsUsecase>(
    GetBookingsUsecase(repository: getIt<BookingRepository>()),
  );
  getIt.registerSingleton<CancelBookingUsecase>(
    CancelBookingUsecase(repository: getIt<BookingRepository>()),
  );

  // BLOCs
  getIt.registerSingleton<AuthBloc>(
    AuthBloc(
      signupUsecase: getIt<SignupUsecase>(),
      loginUsecase: getIt<LoginUsecase>(),
      getCurrentUserUsecase: getIt<GetCurrentUserUsecase>(),
    ),
  );
  getIt.registerSingleton<ServiceBloc>(
    ServiceBloc(
      getServicesUsecase: getIt<GetServicesUsecase>(),
      getServiceDetailUsecase: getIt<GetServiceDetailUsecase>(),
    ),
  );
  getIt.registerSingleton<CartBloc>(
    CartBloc(
      getCartUsecase: getIt<GetCartUsecase>(),
      addToCartUsecase: getIt<AddToCartUsecase>(),
      updateCartItemUsecase: getIt<UpdateCartItemUsecase>(),
      removeFromCartUsecase: getIt<RemoveFromCartUsecase>(),
    ),
  );
  getIt.registerSingleton<BookingBloc>(
    BookingBloc(
      checkoutUsecase: getIt<CheckoutUsecase>(),
      getBookingsUsecase: getIt<GetBookingsUsecase>(),
      cancelBookingUsecase: getIt<CancelBookingUsecase>(),
    ),
  );
}