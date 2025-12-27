import 'package:equatable/equatable.dart';

abstract class ParcelsEvent extends Equatable {
  const ParcelsEvent();

  @override
  List<Object> get props => [];
}

class GetParcelsEvent extends ParcelsEvent {}

class GetParcelByIdEvent extends ParcelsEvent {
  final int id;
  const GetParcelByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateParcelEvent extends ParcelsEvent {
  final int routeId;
  final String receiverName;
  final String receiverAddress;
  final String receiverPhone;
  final double weight;
  final bool isPaid;

  const CreateParcelEvent({
    required this.routeId,
    required this.receiverName,
    required this.receiverAddress,
    required this.receiverPhone,
    required this.weight,
    required this.isPaid,
  });

  @override
  List<Object> get props => [
        routeId,
        receiverName,
        receiverAddress,
        receiverPhone,
        weight,
        isPaid,
      ];
}

class UpdateParcelEvent extends ParcelsEvent {
  final int id;
  final String? receiverName;
  final String? receiverAddress;
  final String? receiverPhone;
  final double? weight;

  const UpdateParcelEvent({
    required this.id,
    this.receiverName,
    this.receiverAddress,
    this.receiverPhone,
    this.weight,
  });

  @override
  List<Object> get props => [
        id,
        if (receiverName != null) receiverName!,
        if (receiverAddress != null) receiverAddress!,
        if (receiverPhone != null) receiverPhone!,
        if (weight != null) weight!,
      ];
}

class DeleteParcelEvent extends ParcelsEvent {
  final int id;
  const DeleteParcelEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchParcelsEvent extends ParcelsEvent {
  final String query;
  const SearchParcelsEvent(this.query);

  @override
  List<Object> get props => [query];
}
