import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rma_customer/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:rma_customer/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:rma_customer/features/profile/presentation/bloc/profile_event.dart';
import 'package:rma_customer/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateProfileUseCase updateProfileUseCase;
  final ChangePasswordUseCase changePasswordUseCase;

  ProfileBloc({
    required this.updateProfileUseCase,
    required this.changePasswordUseCase,
  }) : super(ProfileInitial()) {
    on<UpdateProfileRequested>(_onUpdateProfileRequested);
    on<ChangePasswordRequested>(_onChangePasswordRequested);
  }

  Future<void> _onUpdateProfileRequested(
    UpdateProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await updateProfileUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      phone: event.phone,
      cityId: event.cityId,
    );
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (user) => emit(ProfileUpdated(user: user)),
    );
  }

  Future<void> _onChangePasswordRequested(
    ChangePasswordRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await changePasswordUseCase(
      oldPassword: event.oldPassword,
      newPassword: event.newPassword,
    );
    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (_) => emit(PasswordChanged()),
    );
  }
}
