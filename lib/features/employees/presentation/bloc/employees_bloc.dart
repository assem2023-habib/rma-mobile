import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_employees_usecase.dart';
import '../../domain/usecases/assign_employee_usecase.dart';
import 'employees_event.dart';
import 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final GetAllEmployeesUseCase getAllEmployeesUseCase;
  final AssignEmployeeUseCase assignEmployeeUseCase;

  EmployeesBloc({
    required this.getAllEmployeesUseCase,
    required this.assignEmployeeUseCase,
  }) : super(EmployeesInitial()) {
    on<GetAllEmployeesEvent>(_onGetAllEmployees);
    on<AssignEmployeeEvent>(_onAssignEmployee);
  }

  Future<void> _onGetAllEmployees(
    GetAllEmployeesEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    final result = await getAllEmployeesUseCase(NoParams());
    result.fold(
      (failure) => emit(const EmployeesError('فشل في جلب الموظفين')),
      (employees) => emit(EmployeesLoaded(employees)),
    );
  }

  Future<void> _onAssignEmployee(
    AssignEmployeeEvent event,
    Emitter<EmployeesState> emit,
  ) async {
    emit(EmployeesLoading());
    final result = await assignEmployeeUseCase(
      AssignEmployeeParams(userId: event.userId, branchId: event.branchId),
    );
    result.fold(
      (failure) => emit(const EmployeesError('فشل في تعيين الموظف')),
      (employee) => emit(EmployeeActionSuccess('تم تعيين الموظف بنجاح', employee: employee)),
    );
  }
}
