import 'package:equatable/equatable.dart';

abstract class BranchesEvent extends Equatable {
  const BranchesEvent();

  @override
  List<Object> get props => [];
}

class GetAllBranchesEvent extends BranchesEvent {}

class CreateBranchEvent extends BranchesEvent {
  final Map<String, dynamic> branchData;

  const CreateBranchEvent({required this.branchData});

  @override
  List<Object> get props => [branchData];
}
