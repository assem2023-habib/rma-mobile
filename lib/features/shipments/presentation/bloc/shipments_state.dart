import 'package:equatable/equatable.dart';
import '../../domain/entities/shipment_entity.dart';

abstract class ShipmentsState extends Equatable {
  const ShipmentsState();

  @override
  List<Object?> get props => [];
}

class ShipmentsInitial extends ShipmentsState {}

class ShipmentsLoading extends ShipmentsState {}

class ShipmentsLoaded extends ShipmentsState {
  final List<ShipmentEntity> shipments;
  const ShipmentsLoaded(this.shipments);

  @override
  List<Object?> get props => [shipments];
}

class ShipmentActionSuccess extends ShipmentsState {
  final String message;
  const ShipmentActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class ShipmentsError extends ShipmentsState {
  final String message;
  const ShipmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
