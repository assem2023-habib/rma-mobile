import 'package:dartz/dartz.dart';
import 'package:rma_customer/core/error/failures.dart';
import 'package:rma_customer/core/error/exceptions.dart';
import 'package:rma_customer/core/network/network_info.dart';
import 'package:rma_customer/features/auth/domain/entities/user_entity.dart';
import 'package:rma_customer/features/profile/domain/repositories/profile_repository.dart';
import 'package:rma_customer/features/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String firstName,
    required String lastName,
    required String phone,
    required int cityId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.updateProfile(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          cityId: cityId,
        );
        return Right(remoteUser);
      } on ServerException {
        return const Left(ServerFailure('حدث خطأ أثناء تحديث الملف الشخصي'));
      }
    } else {
      return const Left(NetworkFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure('Server Error changing password'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
