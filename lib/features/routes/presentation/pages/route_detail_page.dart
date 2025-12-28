import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/route_entity.dart';

class RouteDetailPage extends StatelessWidget {
  final RouteEntity route;

  const RouteDetailPage({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المسار', style: AppTypography.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Header Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          route.fromBranch != null && route.toBranch != null
                              ? '${route.fromBranch!.branchName} - ${route.toBranch!.branchName}'
                              : 'مسار ${route.fromBranchId} - ${route.toBranchId}',
                          style: AppTypography.heading1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildStatusBadge(route.isActive ? 'Active' : 'Inactive'),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing6),
                  Row(
                    children: [
                      _buildLocationPoint(
                        route.fromBranch?.branchName ??
                            'الفرع ${route.fromBranchId}',
                        'نقطة الانطلاق',
                      ),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing2,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      _buildLocationPoint(
                        route.toBranch?.branchName ??
                            'الفرع ${route.toBranchId}',
                        'وجهة الوصول',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing6),

            // Branch Details Section
            if (route.fromBranch != null || route.toBranch != null) ...[
              const Text('تفاصيل الأفرع', style: AppTypography.heading3),
              const SizedBox(height: AppDimensions.spacing3),
              if (route.fromBranch != null)
                _buildBranchCard('فرع الانطلاق', route.fromBranch!),
              if (route.toBranch != null)
                _buildBranchCard('فرع الوصول', route.toBranch!),
              const SizedBox(height: AppDimensions.spacing6),
            ],

            // Route Days Section
            const Text('أيام العمل والمواعيد', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            ...route.days.map(
              (day) => Card(
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  child: Column(
                    children: [
                      _buildInfoRow(
                        Icons.calendar_today,
                        'اليوم',
                        day.dayOfWeek,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.access_time,
                        'وقت المغادرة',
                        day.estimatedDepartureTime,
                      ),
                      const Divider(),
                      _buildInfoRow(
                        Icons.timer_outlined,
                        'وقت الوصول المتوقع',
                        day.estimatedArrivalTime,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing3),

            // General Info Section
            const Text('معلومات عامة', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.straighten,
                      'التكلفة لكل كيلو',
                      '${route.distancePerKilo} ل.س',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isActive = status == 'نشط';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing3,
        vertical: AppDimensions.spacing1,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        status,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationPoint(String city, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Text(
          city,
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBranchCard(String title, BranchEntity branch) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing2),
            Text(branch.branchName, style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing1),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.slate500,
                ),
                const SizedBox(width: AppDimensions.spacing2),
                Expanded(
                  child: Text(
                    branch.address,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.slate600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing2),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryBlue),
          const SizedBox(width: AppDimensions.spacing3),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.slate500),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
