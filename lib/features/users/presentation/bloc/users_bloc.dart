import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/search_users_usecase.dart';
import '../../../../core/entities/pagination_entity.dart';

// Events
abstract class UsersEvent extends Equatable {
  const UsersEvent();
  @override
  List<Object?> get props => [];
}

class SearchUsersEvent extends UsersEvent {
  final String query;
  final int? page;
  const SearchUsersEvent(this.query, {this.page});
  @override
  List<Object?> get props => [query, page];
}

// States
abstract class UsersState extends Equatable {
  const UsersState();
  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {}
class UsersLoading extends UsersState {}
class UsersLoaded extends UsersState {
  final Pagination<UserEntity> usersPagination;
  const UsersLoaded(this.usersPagination);
  @override
  List<Object?> get props => [usersPagination];
}
class UsersError extends UsersState {
  final String message;
  const UsersError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final SearchUsersUseCase searchUsersUseCase;

  UsersBloc({required this.searchUsersUseCase}) : super(UsersInitial()) {
    on<SearchUsersEvent>((event, emit) async {
      if (event.query.isEmpty) {
        emit(UsersInitial());
        return;
      }
      emit(UsersLoading());
      final result = await searchUsersUseCase(
        userName: event.query,
        page: event.page,
      );
      result.fold(
        (failure) => emit(const UsersError('فشل البحث عن المستخدمين')),
        (pagination) => emit(UsersLoaded(pagination)),
      );
    });
  }
}
