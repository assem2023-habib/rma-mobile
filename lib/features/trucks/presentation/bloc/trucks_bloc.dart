import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_trucks_usecase.dart';
import '../../domain/usecases/toggle_truck_status_usecase.dart';
import 'trucks_event.dart';
import 'trucks_state.dart';

class TrucksBloc extends Bloc<TrucksEvent, TrucksState> {
  final GetAllTrucksUseCase getAllTrucksUseCase;
  final ToggleTruckStatusUseCase toggleTruckStatusUseCase;

  TrucksBloc({
    required this.getAllTrucksUseCase,
    required this.toggleTruckStatusUseCase,
  }) : super(TrucksInitial()) {
    on<GetAllTrucksEvent>((event, emit) async {
      emit(TrucksLoading());
      final result = await getAllTrucksUseCase(NoParams());
      result.fold(
        (failure) => emit(TrucksError(failure.message)),
        (trucks) => emit(TrucksLoaded(trucks)),
      );
    });

    on<ToggleTruckStatusEvent>((event, emit) async {
      final result = await toggleTruckStatusUseCase(event.id);
      result.fold(
        (failure) => emit(TrucksError(failure.message)),
        (truck) => emit(TruckStatusToggled(truck)),
      );
    });
  }
}
