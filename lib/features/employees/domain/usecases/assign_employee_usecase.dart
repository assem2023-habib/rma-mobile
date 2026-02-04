import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class AssignEmployeeUseCase implements UseCase<EmployeeEntity, AssignEmployeeParams> {
  final EmployeeRepository repository;

  AssignEmployeeUseCase(this.repository);

  @override
  Future<Either<Failure, EmployeeEntity>> call(AssignEmployeeParams params) async {
    return await repository.assignEmployee(params.userId, params.branchId);
  }
}

class AssignEmployeeParams extends Equatable {
  final int userId;
  final int branchId;

  const AssignEmployeeParams({required this.userId, required this.branchId});

  @override
  List<Object?> get props => [userId, branchId];
}
