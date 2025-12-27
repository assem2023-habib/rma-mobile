import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/new_password_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../domain/usecases/confirm_email_otp_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final NewPasswordUseCase newPasswordUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ConfirmEmailOtpUseCase confirmEmailOtpUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.forgotPasswordUseCase,
    required this.newPasswordUseCase,
    required this.verifyEmailUseCase,
    required this.confirmEmailOtpUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<NewPasswordRequested>(_onNewPasswordRequested);
    on<VerifyEmailRequested>(_onVerifyEmailRequested);
    on<ConfirmEmailOtpRequested>(_onConfirmEmailOtpRequested);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      email: event.email,
      password: event.password,
      passwordConfirmation: event.passwordConfirmation,
      phone: event.phone,
      birthday: event.birthday,
      cityId: event.cityId,
      nationalNumber: event.nationalNumber,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await forgotPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const ForgotPasswordSuccess(message: 'تم إرسال رمز التحقق')),
    );
  }

  Future<void> _onNewPasswordRequested(
    NewPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await newPasswordUseCase(
      email: event.email,
      otpCode: event.otpCode,
      newPassword: event.newPassword,
      newPasswordConfirmation: event.newPasswordConfirmation,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) =>
          emit(const NewPasswordSuccess(message: 'تم تغيير كلمة المرور بنجاح')),
    );
  }

  Future<void> _onVerifyEmailRequested(
    VerifyEmailRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await verifyEmailUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) =>
          emit(const VerifyEmailSuccess(message: 'تم إرسال رمز التحقق للبريد')),
    );
  }

  Future<void> _onConfirmEmailOtpRequested(
    ConfirmEmailOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await confirmEmailOtpUseCase(event.email, event.otpCode);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) =>
          emit(const ConfirmEmailOtpSuccess(message: 'تم تفعيل الحساب بنجاح')),
    );
  }
}
