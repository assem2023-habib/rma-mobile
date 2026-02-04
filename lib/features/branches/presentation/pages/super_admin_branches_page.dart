import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/branches_bloc.dart';
import '../bloc/branches_event.dart';
import '../bloc/branches_state.dart';
import '../../domain/entities/branch_entity.dart';

class SuperAdminBranchesPage extends StatefulWidget {
  const SuperAdminBranchesPage({super.key});

  @override
  State<SuperAdminBranchesPage> createState() => _SuperAdminBranchesPageState();
}

class _SuperAdminBranchesPageState extends State<SuperAdminBranchesPage> {
  @override
  void initState() {
    super.initState();
    context.read<BranchesBloc>().add(GetAllBranchesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة الفروع'),
      body: ShinyBackground(
        child: BlocListener<BranchesBloc, BranchesState>(
          listener: (context, state) {
            if (state is BranchActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<BranchesBloc>().add(GetAllBranchesEvent());
            } else if (state is BranchesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
              );
            }
          },
          child: BlocBuilder<BranchesBloc, BranchesState>(
            builder: (context, state) {
              if (state is BranchesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BranchesLoaded) {
                if (state.branches.isEmpty) {
                  return const Center(child: Text('لا يوجد فروع حالياً'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  itemCount: state.branches.length,
                  itemBuilder: (context, index) {
                    final branch = state.branches[index];
                    return _BranchCard(branch: branch);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBranchDialog(context),
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }

  void _showCreateBranchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final phoneController = TextEditingController();
    int? selectedCityId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة فرع جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'اسم الفرع',
                  hintText: 'أدخل اسم الفرع',
                ),
              ),
              const SizedBox(height: AppDimensions.spacing3),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'العنوان',
                  hintText: 'أدخل عنوان الفرع',
                ),
              ),
              const SizedBox(height: AppDimensions.spacing3),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'رقم الهاتف',
                  hintText: 'أدخل رقم هاتف الفرع',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppDimensions.spacing3),
              TextField(
                onChanged: (value) => selectedCityId = int.tryParse(value),
                decoration: const InputDecoration(
                  labelText: 'رقم المدينة (City ID)',
                  hintText: 'أدخل رقم المدينة',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && selectedCityId != null) {
                context.read<BranchesBloc>().add(
                      CreateBranchEvent(
                        branchData: {
                          'branch_name': nameController.text,
                          'city_id': selectedCityId,
                          'address': addressController.text,
                          'phone': phoneController.text,
                        },
                      ),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}

class _BranchCard extends StatelessWidget {
  final BranchEntity branch;

  const _BranchCard({required this.branch});

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
          child: const Icon(Icons.location_on, color: AppColors.primary),
        ),
        title: Text(
          branch.branchName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (branch.cityName != null)
              Text('${branch.cityName} - ${branch.countryName ?? ""}'),
            if (branch.address != null) Text(branch.address!),
            if (branch.phone != null) Text(branch.phone!),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
