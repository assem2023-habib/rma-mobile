import 'package:equatable/equatable.dart';
import '../../domain/entities/parcel.dart';

abstract class ParcelsState extends Equatable {
  const ParcelsState();
  
  @override
  List<Object> get props => [];
}

class ParcelsInitial extends ParcelsState {}

class ParcelsLoading extends ParcelsState {}

class ParcelsLoaded extends ParcelsState {
  final List<Parcel> parcels;
  const ParcelsLoaded({required this.parcels});

  @override
  List<Object> get props => [parcels];
}

class ParcelDetailLoaded extends ParcelsState {
  final Parcel parcel;
  const ParcelDetailLoaded({required this.parcel});

  @override
  List<Object> get props => [parcel];
}

class ParcelActionSuccess extends ParcelsState {
  final String message;
  const ParcelActionSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

class ParcelsError extends ParcelsState {
  final String message;
  const ParcelsError({required this.message});

  @override
  List<Object> get props => [message];
}
