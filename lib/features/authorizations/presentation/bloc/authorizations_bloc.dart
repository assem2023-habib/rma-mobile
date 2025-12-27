import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_authorizations_usecase.dart';
import '../../domain/usecases/get_authorization_by_id_usecase.dart';
import '../../domain/usecases/create_authorization_usecase.dart';
import '../../domain/usecases/cancel_authorization_usecase.dart';
import 'authorizations_event.dart';
import 'authorizations_state.dart';

class AuthorizationsBloc
    extends Bloc<AuthorizationsEvent, AuthorizationsState> {
  final GetAuthorizationsUseCase getAuthorizationsUseCase;
  final GetAuthorizationByIdUseCase getAuthorizationByIdUseCase;
  final CreateAuthorizationUseCase createAuthorizationUseCase;
  final CancelAuthorizationUseCase cancelAuthorizationUseCase;

  AuthorizationsBloc({
    required this.getAuthorizationsUseCase,
    required this.getAuthorizationByIdUseCase,
    required this.createAuthorizationUseCase,
    required this.cancelAuthorizationUseCase,
  }) : super(AuthorizationsInitial()) {
    on<GetAuthorizationsEvent>(_onGetAuthorizations);
    on<GetAuthorizationByIdEvent>(_onGetAuthorizationById);
    on<CreateAuthorizationEvent>(_onCreateAuthorization);
    on<CancelAuthorizationEvent>(_onCancelAuthorization);
  }

  Future<void> _onGetAuthorizations(
    GetAuthorizationsEvent event,
    Emitter<AuthorizationsState> emit,
  ) async {
    emit(AuthorizationsLoading());
    final result = await getAuthorizationsUseCase();
    result.fold(
      (failure) => emit(AuthorizationsError(failure.message)),
      (authorizations) => emit(AuthorizationsLoaded(authorizations)),
    );
  }

  Future<void> _onGetAuthorizationById(
    GetAuthorizationByIdEvent event,
    Emitter<AuthorizationsState> emit,
  ) async {
    emit(AuthorizationsLoading());
    final result = await getAuthorizationByIdUseCase(event.id);
    result.fold(
      (failure) => emit(AuthorizationsError(failure.message)),
      (authorization) => emit(AuthorizationDetailLoaded(authorization)),
    );
  }

  Future<void> _onCreateAuthorization(
    CreateAuthorizationEvent event,
    Emitter<AuthorizationsState> emit,
  ) async {
    emit(AuthorizationActionInProgress());
    final result = await createAuthorizationUseCase(
      parcelId: event.parcelId,
      authorizedUserType: event.authorizedUserType,
      authorizedUserId: event.authorizedUserId,
      authorizedFirstName: event.authorizedFirstName,
      authorizedLastName: event.authorizedLastName,
      authorizedPhone: event.authorizedPhone,
      authorizedNationalNumber: event.authorizedNationalNumber,
      authorizedAddress: event.authorizedAddress,
      authorizedCityId: event.authorizedCityId,
      authorizedBirthday: event.authorizedBirthday,
    );
    result.fold(
      (failure) => emit(AuthorizationsError(failure.message)),
      (authorization) =>
          emit(const AuthorizationActionSuccess('تم إنشاء التخويل بنجاح')),
    );
  }

  Future<void> _onCancelAuthorization(
    CancelAuthorizationEvent event,
    Emitter<AuthorizationsState> emit,
  ) async {
    emit(AuthorizationActionInProgress());
    final result = await cancelAuthorizationUseCase(event.id);
    result.fold(
      (failure) => emit(AuthorizationsError(failure.message)),
      (_) => emit(const AuthorizationActionSuccess('تم إلغاء التخويل بنجاح')),
    );
  }
}
