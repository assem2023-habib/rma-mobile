import 'package:equatable/equatable.dart';
import '../../domain/entities/new_parcel.dart';

abstract class NewParcelEvent extends Equatable {
  const NewParcelEvent();

  @override
  List<Object> get props => [];
}

class CreateParcelEvent extends NewParcelEvent {
  final NewParcel parcel;

  const CreateParcelEvent(this.parcel);

  @override
  List<Object> get props => [parcel];
}
