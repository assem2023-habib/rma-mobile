import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/cards/stats_card.dart';
import '../bloc/dashboard_state.dart';

class DashboardStatsGrid extends StatelessWidget {
  final DashboardLoaded state;

  const DashboardStatsGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
          mainAxisSpacing: AppDimensions.spacing3,
          crossAxisSpacing: AppDimensions.spacing3,
          childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.5 : 1.0,
        ),
        delegate: SliverChildListDelegate([
          StatsCard(
            title: 'إجمالي الطرود',
            value: state.stats.totalParcels.toString(),
            change:
                '${state.stats.parcelsByStatus['Pending'] ?? state.stats.parcelsByStatus['pending'] ?? 0} قيد الانتظار',
            icon: Icons.inventory_2_outlined,
            iconGradient: const [AppColors.primary, AppColors.primaryDark],
          ),
          StatsCard(
            title: state.stats.employeesCount > 0 ? 'الموظفين' : 'تم التوصيل',
            value: state.stats.employeesCount > 0
                ? state.stats.employeesCount.toString()
                : (state.stats.parcelsByStatus['Delivered'] ??
                          state.stats.parcelsByStatus['delivered'] ??
                          0)
                      .toString(),
            change: state.stats.employeesCount > 0
                ? 'إجمالي الموظفين'
                : 'من إجمالي الشحنات',
            icon: state.stats.employeesCount > 0
                ? Icons.people_outline
                : Icons.check_circle_outline,
            iconGradient: state.stats.employeesCount > 0
                ? const [AppColors.info, AppColors.primaryBlue]
                : const [AppColors.success, AppColors.info],
          ),
          StatsCard(
            title: state.stats.employeesCount > 0
                ? 'المستخدمين'
                : 'الفروع والمدن',
            value: state.stats.employeesCount > 0
                ? state.stats.usersCount.toString()
                : '${state.stats.branchesCount}',
            change: state.stats.employeesCount > 0
                ? 'إجمالي المستخدمين'
                : '${state.stats.citiesCount} مدينة في ${state.stats.countriesCount} دول',
            icon: state.stats.employeesCount > 0
                ? Icons.person_outline
                : Icons.storefront_outlined,
            iconGradient: const [AppColors.warning, AppColors.warning],
          ),
          StatsCard(
            title: state.stats.employeesCount > 0
                ? 'الفروع'
                : 'الشحنات والرحلات',
            value: state.stats.employeesCount > 0
                ? state.stats.branchesCount.toString()
                : '${state.stats.shipmentsCount}',
            change: state.stats.employeesCount > 0
                ? 'إجمالي الفروع'
                : '${state.stats.trucksCount} شاحنة نشطة',
            icon: state.stats.employeesCount > 0
                ? Icons.business_outlined
                : Icons.local_shipping_outlined,
            iconGradient: const [AppColors.primarySoft, AppColors.primary],
          ),
        ]),
      ),
    );
  }
}
