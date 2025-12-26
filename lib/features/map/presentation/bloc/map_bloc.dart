import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_parcel_location_usecase.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetParcelLocationUseCase getParcelLocationUseCase;

  MapBloc({required this.getParcelLocationUseCase}) : super(MapInitial()) {
    on<GetParcelLocationEvent>(_onGetParcelLocation);
  }

  Future<void> _onGetParcelLocation(
    GetParcelLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    final result = await getParcelLocationUseCase(event.parcelId);
    result.fold(
      (failure) => emit(MapError(failure.message)),
      (location) => emit(MapLoaded(location)),
    );
  }
}
