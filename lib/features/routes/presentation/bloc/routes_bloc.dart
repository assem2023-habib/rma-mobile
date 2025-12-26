import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_routes_usecase.dart';
import 'routes_event.dart';
import 'routes_state.dart';

class RoutesBloc extends Bloc<RoutesEvent, RoutesState> {
  final GetRoutesUseCase getRoutesUseCase;

  RoutesBloc({required this.getRoutesUseCase}) : super(RoutesInitial()) {
    on<GetRoutesEvent>(_onGetRoutes);
  }

  Future<void> _onGetRoutes(
    GetRoutesEvent event,
    Emitter<RoutesState> emit,
  ) async {
    emit(RoutesLoading());
    final result = await getRoutesUseCase();
    result.fold(
      (failure) => emit(RoutesError(failure.message)),
      (routes) => emit(RoutesLoaded(routes)),
    );
  }
}
