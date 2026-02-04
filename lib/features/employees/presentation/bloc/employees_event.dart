import 'package:equatable/equatable.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class GetAllEmployeesEvent extends EmployeesEvent {}

class AssignEmployeeEvent extends EmployeesEvent {
  final int userId;
  final int branchId;

  const AssignEmployeeEvent({required this.userId, required this.branchId});

  @override
  List<Object> get props => [userId, branchId];
}
