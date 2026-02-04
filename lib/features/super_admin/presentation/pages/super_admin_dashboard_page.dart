import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/cards/stats_card.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/super_admin_bloc.dart';
import '../../../parcels/presentation/widgets/parcel_card.dart';

class SuperAdminDashboardPage extends StatefulWidget {
  const SuperAdminDashboardPage({super.key});

  @override
  State<SuperAdminDashboardPage> createState() =>
      _SuperAdminDashboardPageState();
}

class _SuperAdminDashboardPageState extends State<SuperAdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<SuperAdminBloc>().add(GetSuperAdminStatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'لوحة التحكم العامة'),
      body: ShinyBackground(
        child: BlocBuilder<SuperAdminBloc, SuperAdminState>(
          builder: (context, state) {
            if (state is SuperAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SuperAdminStatsLoaded) {
              final stats = state.stats;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<SuperAdminBloc>().add(GetSuperAdminStatsEvent());
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: AppDimensions.spacing3,
                        mainAxisSpacing: AppDimensions.spacing3,
                        childAspectRatio: 1.5,
                        children: [
                          StatsCard(
                            title: 'إجمالي الطرود',
                            value: stats.totalParcels.toString(),
                            icon: Icons.inventory_2,
                            change: '+0%',
                            iconGradient: const [
                              AppColors.primary,
                              AppColors.primarySoft,
                            ],
                          ),
                          StatsCard(
                            title: 'إجمالي الفروع',
                            value: stats.totalBranches.toString(),
                            icon: Icons.storefront,
                            change: '+0%',
                            iconGradient: const [
                              AppColors.success,
                              AppColors.successBg,
                            ],
                          ),
                          StatsCard(
                            title: 'إجمالي الموظفين',
                            value: stats.totalEmployees.toString(),
                            icon: Icons.people,
                            change: '+0%',
                            iconGradient: const [
                              AppColors.info,
                              AppColors.infoBg,
                            ],
                          ),
                          StatsCard(
                            title: 'إجمالي المستخدمين',
                            value: stats.totalUsers.toString(),
                            icon: Icons.person,
                            change: '+0%',
                            iconGradient: const [
                              AppColors.warning,
                              AppColors.warningBg,
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacing6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'أحدث الطرود',
                            style: AppTypography.heading3,
                          ),
                          TextButton(
                            onPressed: () =>
                                context.push('/super-admin/parcels'),
                            child: const Text('عرض الكل'),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacing3),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: stats.recentParcels.length,
                        itemBuilder: (context, index) {
                          return ParcelCard(parcel: stats.recentParcels[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SuperAdminError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
