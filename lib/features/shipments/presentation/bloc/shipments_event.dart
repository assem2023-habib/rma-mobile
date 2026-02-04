import 'package:equatable/equatable.dart';

abstract class ShipmentsEvent extends Equatable {
  const ShipmentsEvent();

  @override
  List<Object> get props => [];
}

class GetAdminShipmentsEvent extends ShipmentsEvent {}

class DepartShipmentEvent extends ShipmentsEvent {
  final int id;
  const DepartShipmentEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ArriveShipmentEvent extends ShipmentsEvent {
  final int id;
  const ArriveShipmentEvent(this.id);

  @override
  List<Object> get props => [id];
}
