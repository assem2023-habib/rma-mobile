import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/badges/status_badge.dart';
import '../../domain/entities/parcel.dart';

class ParcelHeaderCard extends StatelessWidget {
  final Parcel parcel;

  const ParcelHeaderCard({super.key, required this.parcel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'رقم التتبع',
                      style: AppTypography.caption,
                    ),
                    Text(
                      parcel.trackingNumber,
                      style: AppTypography.heading2.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                StatusBadge(
                  label: parcel.status.displayName,
                  color: parcel.status.color,
                  backgroundColor: parcel.status.backgroundColor,
                  icon: parcel.status.icon,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
