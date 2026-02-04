import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/branch_entity.dart';
import '../repositories/branch_repository.dart';

class GetAllBranchesUseCase implements UseCase<List<BranchEntity>, NoParams> {
  final BranchRepository repository;

  GetAllBranchesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BranchEntity>>> call(NoParams params) async {
    return await repository.getAllBranches();
  }
}
