import 'package:equatable/equatable.dart';
import '../../domain/entities/branch_entity.dart';

abstract class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object?> get props => [];
}

class BranchesInitial extends BranchesState {}

class BranchesLoading extends BranchesState {}

class BranchesLoaded extends BranchesState {
  final List<BranchEntity> branches;

  const BranchesLoaded({required this.branches});

  @override
  List<Object?> get props => [branches];
}

class BranchActionSuccess extends BranchesState {
  final String message;
  final BranchEntity? branch;

  const BranchActionSuccess({required this.message, this.branch});

  @override
  List<Object?> get props => [message, branch];
}

class BranchesError extends BranchesState {
  final String message;

  const BranchesError({required this.message});

  @override
  List<Object?> get props => [message];
}
