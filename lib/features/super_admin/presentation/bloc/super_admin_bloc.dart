import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rma_customer/features/super_admin/domain/entities/super_admin_stats_entity.dart';
import 'package:rma_customer/features/super_admin/domain/usecases/get_global_parcels_usecase.dart';
import 'package:rma_customer/features/super_admin/domain/usecases/get_super_admin_stats_usecase.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../parcels/domain/entities/parcel.dart';


// Events
abstract class SuperAdminEvent extends Equatable {
  const SuperAdminEvent();
  @override
  List<Object?> get props => [];
}

class GetSuperAdminStatsEvent extends SuperAdminEvent {}

class GetGlobalParcelsEvent extends SuperAdminEvent {
  final int page;
  const GetGlobalParcelsEvent({this.page = 1});
  @override
  List<Object?> get props => [page];
}

// States
abstract class SuperAdminState extends Equatable {
  const SuperAdminState();
  @override
  List<Object?> get props => [];
}

class SuperAdminInitial extends SuperAdminState {}

class SuperAdminLoading extends SuperAdminState {}

class SuperAdminStatsLoaded extends SuperAdminState {
  final SuperAdminStatsEntity stats;
  const SuperAdminStatsLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class GlobalParcelsLoaded extends SuperAdminState {
  final List<Parcel> parcels;
  final int page;
  const GlobalParcelsLoaded(this.parcels, this.page);
  @override
  List<Object?> get props => [parcels, page];
}

class SuperAdminError extends SuperAdminState {
  final String message;
  const SuperAdminError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class SuperAdminBloc extends Bloc<SuperAdminEvent, SuperAdminState> {
  final GetSuperAdminStatsUseCase getSuperAdminStatsUseCase;
  final GetGlobalParcelsUseCase getGlobalParcelsUseCase;

  SuperAdminBloc({
    required this.getSuperAdminStatsUseCase,
    required this.getGlobalParcelsUseCase,
  }) : super(SuperAdminInitial()) {
    on<GetSuperAdminStatsEvent>((event, emit) async {
      emit(SuperAdminLoading());
      final result = await getSuperAdminStatsUseCase(NoParams());
      result.fold(
        (failure) => emit(SuperAdminError(failure.message)),
        (stats) => emit(SuperAdminStatsLoaded(stats)),
      );
    });

    on<GetGlobalParcelsEvent>((event, emit) async {
      emit(SuperAdminLoading());
      final result = await getGlobalParcelsUseCase(event.page);
      result.fold(
        (failure) => emit(SuperAdminError(failure.message)),
        (parcels) => emit(GlobalParcelsLoaded(parcels, event.page)),
      );
    });
  }
}
