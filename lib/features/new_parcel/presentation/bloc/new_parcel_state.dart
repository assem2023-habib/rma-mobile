import 'package:equatable/equatable.dart';

abstract class NewParcelState extends Equatable {
  const NewParcelState();

  @override
  List<Object> get props => [];
}

class NewParcelInitial extends NewParcelState {}

class NewParcelLoading extends NewParcelState {}

class NewParcelSuccess extends NewParcelState {}

class NewParcelError extends NewParcelState {
  final String message;

  const NewParcelError(this.message);

  @override
  List<Object> get props => [message];
}
