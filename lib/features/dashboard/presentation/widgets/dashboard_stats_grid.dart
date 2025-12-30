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
            change: '${state.stats.parcelsByStatus['Pending'] ?? 0} قيد الانتظار',
            icon: Icons.inventory_2_outlined,
            iconGradient: const [AppColors.primary, AppColors.primaryDark],
          ),
          StatsCard(
            title: 'تم التوصيل',
            value: (state.stats.parcelsByStatus['Delivered'] ?? 0).toString(),
            change: 'من إجمالي الشحنات',
            icon: Icons.check_circle_outline,
            iconGradient: const [AppColors.success, AppColors.info],
          ),
          StatsCard(
            title: 'الفروع والمدن',
            value: '${state.stats.branchesCount}',
            change: '${state.stats.citiesCount} مدينة في ${state.stats.countriesCount} دول',
            icon: Icons.storefront_outlined,
            iconGradient: const [AppColors.warning, AppColors.warning],
          ),
          StatsCard(
            title: 'الشحنات والرحلات',
            value: '${state.stats.shipmentsCount}',
            change: '${state.stats.trucksCount} شاحنة نشطة',
            icon: Icons.local_shipping_outlined,
            iconGradient: const [AppColors.primarySoft, AppColors.primary],
          ),
        ]),
      ),
    );
  }
}
