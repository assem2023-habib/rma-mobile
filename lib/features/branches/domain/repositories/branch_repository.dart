import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/branch_entity.dart';

abstract class BranchRepository {
  Future<Either<Failure, List<BranchEntity>>> getAllBranches();
  Future<Either<Failure, BranchEntity>> createBranch(Map<String, dynamic> branchData);
}
