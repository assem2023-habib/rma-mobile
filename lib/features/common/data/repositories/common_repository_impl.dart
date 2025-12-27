import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/common_remote_datasource.dart';
import '../../domain/repositories/common_repository.dart';

class CommonRepositoryImpl implements CommonRepository {
  final CommonRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CommonRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<dynamic>>> getCountries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCountries();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getCities(int countryId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getCities(countryId);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getBranches({int? cityId}) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getBranches(cityId: cityId);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getBranchDetail(int branchId) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getBranchDetail(branchId);
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getPricingPolicy() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPricingPolicy();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getGeneralInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getGeneralInfo();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getPrivacyPolicy() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPrivacyPolicy();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getTermsConditions() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTermsConditions();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> getAboutUs() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getAboutUs();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getFaqs() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getFaqs();
        return Right(result);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, void>> contactUs({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.contactUs(
          name: name,
          email: email,
          phone: phone,
          subject: subject,
          message: message,
        );
        return const Right(null);
      } on ServerException {
        return const Left(ServerFailure('Server Error'));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
