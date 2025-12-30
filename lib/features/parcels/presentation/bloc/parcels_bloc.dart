import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/pagination_entity.dart';
import '../../domain/entities/parcel.dart';
import '../../domain/usecases/get_parcels_usecase.dart';
import '../../domain/usecases/get_returned_parcels_usecase.dart';
import '../../domain/usecases/get_parcel_by_id_usecase.dart';
import '../../domain/usecases/create_parcel_usecase.dart';
import '../../domain/usecases/update_parcel_usecase.dart';
import '../../domain/usecases/delete_parcel_usecase.dart';
import 'parcels_event.dart';
import 'parcels_state.dart';

class ParcelsBloc extends Bloc<ParcelsEvent, ParcelsState> {
  final GetParcelsUseCase getParcelsUseCase;
  final GetReturnedParcelsUseCase getReturnedParcelsUseCase;
  final GetParcelByIdUseCase getParcelByIdUseCase;
  final CreateParcelUseCase createParcelUseCase;
  final UpdateParcelUseCase updateParcelUseCase;
  final DeleteParcelUseCase deleteParcelUseCase;

  ParcelsBloc({
    required this.getParcelsUseCase,
    required this.getReturnedParcelsUseCase,
    required this.getParcelByIdUseCase,
    required this.createParcelUseCase,
    required this.updateParcelUseCase,
    required this.deleteParcelUseCase,
  }) : super(ParcelsInitial()) {
    on<GetParcelsEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await getParcelsUseCase();
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (parcels) => emit(ParcelsLoaded(parcels: parcels)),
      );
    });

    on<GetReturnedParcelsEvent>((event, emit) async {
      final isFirstPage = event.page == null || event.page == 1;

      if (isFirstPage) {
        emit(ParcelsLoading());
      }

      final result = await getReturnedParcelsUseCase(page: event.page);

      result.fold((failure) => emit(ParcelsError(message: failure.message)), (
        pagination,
      ) {
        if (isFirstPage) {
          emit(ReturnedParcelsLoaded(parcelsPagination: pagination));
        } else {
          if (state is ReturnedParcelsLoaded) {
            final currentState = state as ReturnedParcelsLoaded;
            final updatedParcels = List<Parcel>.from(
              currentState.parcelsPagination.data,
            )..addAll(pagination.data);

            emit(
              ReturnedParcelsLoaded(
                parcelsPagination: Pagination<Parcel>(
                  data: updatedParcels,
                  currentPage: pagination.currentPage,
                  lastPage: pagination.lastPage,
                  total: pagination.total,
                  perPage: pagination.perPage,
                ),
              ),
            );
          } else {
            emit(ReturnedParcelsLoaded(parcelsPagination: pagination));
          }
        }
      });
    });

    on<GetParcelByIdEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await getParcelByIdUseCase(event.id);
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (parcel) => emit(ParcelDetailLoaded(parcel: parcel)),
      );
    });

    on<CreateParcelEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await createParcelUseCase(
        routeId: event.routeId,
        receiverName: event.receiverName,
        receiverAddress: event.receiverAddress,
        receiverPhone: event.receiverPhone,
        weight: event.weight,
        isPaid: event.isPaid,
      );
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (parcel) =>
            emit(const ParcelActionSuccess(message: 'تم إنشاء الطرد بنجاح')),
      );
    });

    on<UpdateParcelEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await updateParcelUseCase(
        id: event.id,
        receiverName: event.receiverName,
        receiverAddress: event.receiverAddress,
        receiverPhone: event.receiverPhone,
        weight: event.weight,
      );
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (parcel) =>
            emit(const ParcelActionSuccess(message: 'تم تحديث الطرد بنجاح')),
      );
    });

    on<DeleteParcelEvent>((event, emit) async {
      emit(ParcelsLoading());
      final result = await deleteParcelUseCase(event.id);
      result.fold(
        (failure) => emit(ParcelsError(message: failure.message)),
        (_) => emit(const ParcelActionSuccess(message: 'تم حذف الطرد بنجاح')),
      );
    });

    on<SearchParcelsEvent>((event, emit) async {
      if (state is ParcelsLoaded) {
        final allParcels = (state as ParcelsLoaded).parcels;
        if (event.query.isEmpty) {
          emit(ParcelsLoaded(parcels: allParcels));
          return;
        }
        final filteredParcels = allParcels
            .where(
              (parcel) =>
                  parcel.trackingNumber.contains(event.query) ||
                  parcel.receiverName.contains(event.query),
            )
            .toList();
        emit(ParcelsLoaded(parcels: filteredParcels));
      }
    });
  }
}
