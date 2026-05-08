import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mentecart_mobile/core/utils/logger.dart';
import 'package:mentecart_mobile/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/auth/login_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/auth/signup_usecase.dart';
import 'package:mentecart_mobile/domain/usecases/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignupUsecase signupUsecase;
  final LoginUsecase loginUsecase;
  final GetCurrentUserUsecase getCurrentUserUsecase;

  AuthBloc({
    required this.signupUsecase,
    required this.loginUsecase,
    required this.getCurrentUserUsecase,
  }) : super(const AuthInitial()) {
    on<SignupEvent>(_onSignup);
    on<LoginEvent>(_onLogin);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSignup(SignupEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final result = await signupUsecase(
        SignupParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      result.fold(
        (failure) => emit(AuthError(failure.message, errorCode: failure.errorCode)),
        (authResponse) {
          AppLogger.info('User signed up: ${authResponse.user.email}');
          emit(
            AuthAuthenticated(
              userId: authResponse.user.id,
              name: authResponse.user.name,
              email: authResponse.user.email,
            ),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Signup error: $e');
      emit(AuthError('An error occurred during signup'));
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());

    try {
      final result = await loginUsecase(
        LoginParams(email: event.email, password: event.password),
      );

      result.fold(
        (failure) => emit(AuthError(failure.message, errorCode: failure.errorCode)),
        (authResponse) {
          AppLogger.info('User logged in: ${authResponse.user.email}');
          emit(
            AuthAuthenticated(
              userId: authResponse.user.id,
              name: authResponse.user.name,
              email: authResponse.user.email,
            ),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Login error: $e');
      emit(AuthError('An error occurred during login'));
    }
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await getCurrentUserUsecase(const NoParams());

      result.fold(
        (failure) => emit(const AuthUnauthenticated()),
        (user) {
          AppLogger.info('Got current user: ${user.email}');
          emit(
            AuthAuthenticated(
              userId: user.id,
              name: user.name,
              email: user.email,
            ),
          );
        },
      );
    } catch (e) {
      AppLogger.error('Get current user error: $e');
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    try {
      AppLogger.info('User logged out');
      emit(const AuthUnauthenticated());
    } catch (e) {
      AppLogger.error('Logout error: $e');
    }
  }
}