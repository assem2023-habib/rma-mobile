import 'package:dartz/dartz.dart';
import 'package:rma_customer/features/employees/domain/entities/employee_entity.dart';
import 'package:rma_customer/features/employees/domain/repositories/employee_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/employee_remote_datasource.dart';


class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmployeeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getAllEmployees() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEmployees = await remoteDataSource.getAllEmployees();
        return Right(remoteEmployees);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> assignEmployee(int userId, int branchId) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteEmployee = await remoteDataSource.assignEmployee(userId, branchId);
        return Right(remoteEmployee);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
