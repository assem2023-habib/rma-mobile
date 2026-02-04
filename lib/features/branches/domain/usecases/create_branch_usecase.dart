import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/branch_entity.dart';
import '../repositories/branch_repository.dart';

class CreateBranchUseCase implements UseCase<BranchEntity, Map<String, dynamic>> {
  final BranchRepository repository;

  CreateBranchUseCase(this.repository);

  @override
  Future<Either<Failure, BranchEntity>> call(Map<String, dynamic> params) async {
    return await repository.createBranch(params);
  }
}
