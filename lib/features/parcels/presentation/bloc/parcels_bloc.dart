import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_parcels_usecase.dart';
import 'parcels_event.dart';
import 'parcels_state.dart';

class ParcelsBloc extends Bloc<ParcelsEvent, ParcelsState> {
  final GetParcelsUseCase getParcelsUseCase;

  ParcelsBloc({required this.getParcelsUseCase}) : super(ParcelsInitial()) {
    on<GetParcelsEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await getParcelsUseCase();
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (parcels) => emit(ParcelsLoaded(parcels: parcels)),
      );
    });

    on<SearchParcelsEvent>((event, emit) async {
      if (state is ParcelsLoaded) {
        final allParcels = (state as ParcelsLoaded).parcels;
        if (event.query.isEmpty) {
          emit(ParcelsLoaded(parcels: allParcels));
          return;
        }
        final filteredParcels = allParcels.where((parcel) =>
            parcel.trackingNumber.contains(event.query) ||
            parcel.receiverName.contains(event.query)).toList();
        emit(ParcelsLoaded(parcels: filteredParcels));
      }
    });
  }
}
