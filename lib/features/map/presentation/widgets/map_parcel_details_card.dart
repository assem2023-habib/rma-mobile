import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/parcel_location.dart';

class MapParcelDetailsCard extends StatelessWidget {
  final ParcelLocation parcelLocation;

  const MapParcelDetailsCard({
    super.key,
    required this.parcelLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: AppDimensions.spacing6,
      left: AppDimensions.spacing4,
      right: AppDimensions.spacing4,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusLg,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(
                    AppDimensions.spacing2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
                  ),
                  child: const Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'حالة الطرد: ${parcelLocation.status}',
                        style: AppTypography.heading3.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'آخر تحديث: ${parcelLocation.lastUpdated}',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
