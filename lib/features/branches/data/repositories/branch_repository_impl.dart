import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/branch_entity.dart';
import '../../domain/repositories/branch_repository.dart';
import '../datasources/branch_remote_datasource.dart';

class BranchRepositoryImpl implements BranchRepository {
  final BranchRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BranchRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BranchEntity>>> getAllBranches() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBranches = await remoteDataSource.getAllBranches();
        return Right(remoteBranches);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, BranchEntity>> createBranch(Map<String, dynamic> branchData) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteBranch = await remoteDataSource.createBranch(branchData);
        return Right(remoteBranch);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(NetworkFailure());
    }
  }
}
