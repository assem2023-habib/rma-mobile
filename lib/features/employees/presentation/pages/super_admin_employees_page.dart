import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../../../branches/domain/entities/branch_entity.dart';
import '../bloc/employees_bloc.dart';
import '../bloc/employees_event.dart';
import '../bloc/employees_state.dart';
import '../../domain/entities/employee_entity.dart';

class SuperAdminEmployeesPage extends StatefulWidget {
  const SuperAdminEmployeesPage({super.key});

  @override
  State<SuperAdminEmployeesPage> createState() =>
      _SuperAdminEmployeesPageState();
}

class _SuperAdminEmployeesPageState extends State<SuperAdminEmployeesPage> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeesBloc>().add(GetAllEmployeesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة الموظفين'),
      body: ShinyBackground(
        child: BlocListener<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeeActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              context.read<EmployeesBloc>().add(GetAllEmployeesEvent());
            } else if (state is EmployeesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: BlocBuilder<EmployeesBloc, EmployeesState>(
            builder: (context, state) {
              if (state is EmployeesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is EmployeesLoaded) {
                if (state.employees.isEmpty) {
                  return const Center(child: Text('لا يوجد موظفون حالياً'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) {
                    final employee = state.employees[index];
                    return _EmployeeCard(employee: employee);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAssignEmployeeDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAssignEmployeeDialog(BuildContext context) {
    final userIdController = TextEditingController();
    int? selectedBranchId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعيين موظف جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userIdController,
              decoration: const InputDecoration(
                labelText: 'رقم المستخدم (User ID)',
                hintText: 'أدخل رقم المستخدم المراد تعيينه',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppDimensions.spacing3),
            // ملاحظة: في تطبيق حقيقي، يفضل جلب الفروع من API واختيارها من القائمة
            TextField(
              onChanged: (value) => selectedBranchId = int.tryParse(value),
              decoration: const InputDecoration(
                labelText: 'رقم الفرع (Branch ID)',
                hintText: 'أدخل رقم الفرع',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final userId = int.tryParse(userIdController.text);
              if (userId != null && selectedBranchId != null) {
                context.read<EmployeesBloc>().add(
                  AssignEmployeeEvent(
                    userId: userId,
                    branchId: selectedBranchId!,
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('تعيين'),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: const Icon(Icons.person, color: AppColors.primary),
        ),
        title: Text(
          employee.userName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(employee.userEmail),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.store, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  employee.branchName,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing2,
            vertical: AppDimensions.spacing1,
          ),
          decoration: BoxDecoration(
            color: employee.status == 'active'
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            employee.status == 'active' ? 'نشط' : 'غير نشط',
            style: TextStyle(
              color: employee.status == 'active'
                  ? AppColors.success
                  : AppColors.error,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
