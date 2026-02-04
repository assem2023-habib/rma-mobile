import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_admin_shipments_usecase.dart';
import '../../domain/usecases/depart_shipment_usecase.dart';
import '../../domain/usecases/arrive_shipment_usecase.dart';
import 'shipments_event.dart';
import 'shipments_state.dart';

class ShipmentsBloc extends Bloc<ShipmentsEvent, ShipmentsState> {
  final GetAdminShipmentsUseCase getAdminShipmentsUseCase;
  final DepartShipmentUseCase departShipmentUseCase;
  final ArriveShipmentUseCase arriveShipmentUseCase;

  ShipmentsBloc({
    required this.getAdminShipmentsUseCase,
    required this.departShipmentUseCase,
    required this.arriveShipmentUseCase,
  }) : super(ShipmentsInitial()) {
    on<GetAdminShipmentsEvent>(_onGetAdminShipments);
    on<DepartShipmentEvent>(_onDepartShipment);
    on<ArriveShipmentEvent>(_onArriveShipment);
  }

  Future<void> _onGetAdminShipments(
    GetAdminShipmentsEvent event,
    Emitter<ShipmentsState> emit,
  ) async {
    emit(ShipmentsLoading());
    final result = await getAdminShipmentsUseCase(NoParams());
    result.fold(
      (failure) => emit(ShipmentsError(failure.message)),
      (shipments) => emit(ShipmentsLoaded(shipments)),
    );
  }

  Future<void> _onDepartShipment(
    DepartShipmentEvent event,
    Emitter<ShipmentsState> emit,
  ) async {
    emit(ShipmentsLoading());
    final result = await departShipmentUseCase(event.id);
    result.fold(
      (failure) => emit(ShipmentsError(failure.message)),
      (_) => emit(const ShipmentActionSuccess('تم تسجيل انطلاق الشحنة بنجاح')),
    );
  }

  Future<void> _onArriveShipment(
    ArriveShipmentEvent event,
    Emitter<ShipmentsState> emit,
  ) async {
    emit(ShipmentsLoading());
    final result = await arriveShipmentUseCase(event.id);
    result.fold(
      (failure) => emit(ShipmentsError(failure.message)),
      (_) => emit(const ShipmentActionSuccess('تم تسجيل وصول الشحنة بنجاح')),
    );
  }
}
