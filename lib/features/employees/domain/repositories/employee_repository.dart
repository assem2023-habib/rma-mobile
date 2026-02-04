import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees();
  Future<Either<Failure, EmployeeEntity>> assignEmployee(int userId, int branchId);
}
