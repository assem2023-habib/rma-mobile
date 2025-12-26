import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_parcel_usecase.dart';
import 'new_parcel_event.dart';
import 'new_parcel_state.dart';

class NewParcelBloc extends Bloc<NewParcelEvent, NewParcelState> {
  final CreateParcelUseCase createParcelUseCase;

  NewParcelBloc({required this.createParcelUseCase}) : super(NewParcelInitial()) {
    on<CreateParcelEvent>(_onCreateParcel);
  }

  Future<void> _onCreateParcel(
    CreateParcelEvent event,
    Emitter<NewParcelState> emit,
  ) async {
    emit(NewParcelLoading());
    final result = await createParcelUseCase(event.parcel);
    result.fold(
      (failure) => emit(NewParcelError(failure.message)),
      (_) => emit(NewParcelSuccess()),
    );
  }
}
