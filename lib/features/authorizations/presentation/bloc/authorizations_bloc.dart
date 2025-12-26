import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_authorizations_usecase.dart';
import '../../domain/usecases/request_authorization_usecase.dart';
import 'authorizations_event.dart';
import 'authorizations_state.dart';

class AuthorizationsBloc extends Bloc<AuthorizationsEvent, AuthorizationsState> {
  final GetAuthorizationsUseCase getAuthorizationsUseCase;
  final RequestAuthorizationUseCase requestAuthorizationUseCase;

  AuthorizationsBloc({
    required this.getAuthorizationsUseCase,
    required this.requestAuthorizationUseCase,
  }) : super(AuthorizationsInitial()) {
    on<GetAuthorizationsEvent>(_onGetAuthorizations);
    on<RequestAuthorizationEvent>(_onRequestAuthorization);
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

  Future<void> _onRequestAuthorization(
    RequestAuthorizationEvent event,
    Emitter<AuthorizationsState> emit,
  ) async {
    emit(AuthorizationRequesting());
    final result = await requestAuthorizationUseCase(event.authorization);
    result.fold(
      (failure) => emit(AuthorizationsError(failure.message)),
      (_) => emit(AuthorizationRequestSuccess()),
    );
  }
}
