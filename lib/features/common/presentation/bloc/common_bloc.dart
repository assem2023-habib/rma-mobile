import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_countries_usecase.dart';
import '../../domain/usecases/get_cities_usecase.dart';
import 'common_event.dart';
import 'common_state.dart';

class CommonBloc extends Bloc<CommonEvent, CommonState> {
  final GetCountriesUseCase getCountriesUseCase;
  final GetCitiesUseCase getCitiesUseCase;

  CommonBloc({
    required this.getCountriesUseCase,
    required this.getCitiesUseCase,
  }) : super(CommonInitial()) {
    on<GetCountriesRequested>(_onGetCountriesRequested);
    on<GetCitiesRequested>(_onGetCitiesRequested);
  }

  Future<void> _onGetCountriesRequested(
    GetCountriesRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await getCountriesUseCase();
    result.fold(
      (failure) => emit(CommonError(failure.message)),
      (countries) => emit(CountriesLoaded(countries)),
    );
  }

  Future<void> _onGetCitiesRequested(
    GetCitiesRequested event,
    Emitter<CommonState> emit,
  ) async {
    emit(CommonLoading());
    final result = await getCitiesUseCase(event.countryId);
    result.fold(
      (failure) => emit(CommonError(failure.message)),
      (cities) => emit(CitiesLoaded(cities)),
    );
  }
}
