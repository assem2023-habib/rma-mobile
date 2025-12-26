import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/route_entity.dart';

class RouteCard extends StatelessWidget {
  final RouteEntity route;
  final VoidCallback? onTap;

  const RouteCard({
    super.key,
    required this.route,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = route.status == 'نشط';

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(
          color: isActive ? AppColors.primaryBlue.withValues(alpha: 0.3) : AppColors.slate100,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate200.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      route.name,
                      style: AppTypography.heading3.copyWith(
                        color: isActive ? AppColors.primaryBlue : AppColors.slate900,
                      ),
                    ),
                  ),
                  _buildStatusBadge(isActive),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing3),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppColors.slate500),
                  const SizedBox(width: AppDimensions.spacing2),
                  Text(
                    '${route.from} ➔ ${route.to}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.slate600),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing2),
              Row(
                children: [
                  const Icon(Icons.person_outline, size: 16, color: AppColors.slate500),
                  const SizedBox(width: AppDimensions.spacing2),
                  Text(
                    'السائق: ${route.driverName}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.slate600),
                  ),
                  const Spacer(),
                  const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.slate400),
                  const SizedBox(width: AppDimensions.spacing1),
                  Text(
                    '${route.date.day}/${route.date.month}/${route.date.year}',
                    style: AppTypography.caption.copyWith(color: AppColors.slate400),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing3,
        vertical: AppDimensions.spacing1,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryLight : AppColors.slate100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        isActive ? 'نشط' : 'مكتمل',
        style: AppTypography.caption.copyWith(
          color: isActive ? AppColors.primaryDark : AppColors.slate600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
