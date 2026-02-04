import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/create_branch_usecase.dart';
import '../../domain/usecases/get_all_branches_usecase.dart';
import 'branches_event.dart';
import 'branches_state.dart';

class BranchesBloc extends Bloc<BranchesEvent, BranchesState> {
  final GetAllBranchesUseCase getAllBranchesUseCase;
  final CreateBranchUseCase createBranchUseCase;

  BranchesBloc({
    required this.getAllBranchesUseCase,
    required this.createBranchUseCase,
  }) : super(BranchesInitial()) {
    on<GetAllBranchesEvent>((event, emit) async {
      emit(BranchesLoading());
      final result = await getAllBranchesUseCase(NoParams());
      result.fold(
        (failure) => emit(const BranchesError(message: 'فشل في تحميل الفروع')),
        (branches) => emit(BranchesLoaded(branches: branches)),
      );
    });

    on<CreateBranchEvent>((event, emit) async {
      emit(BranchesLoading());
      final result = await createBranchUseCase(event.branchData);
      result.fold(
        (failure) => emit(const BranchesError(message: 'فشل في إنشاء الفرع')),
        (branch) => emit(BranchActionSuccess(
          message: 'تم إنشاء الفرع بنجاح',
          branch: branch,
        )),
      );
    });
  }
}
