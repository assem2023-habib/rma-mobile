import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class MapErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onBack;

  const MapErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 80,
              color: AppColors.slate300,
            ),
            const SizedBox(height: AppDimensions.spacing4),
            Text(
              'تتبع غير متاح',
              style: AppTypography.heading3.copyWith(
                color: AppColors.slate900,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing2),
            Text(
              message,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.slate500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacing8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('إعادة المحاولة'),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing3),
            TextButton(
              onPressed: onBack,
              child: const Text('العودة لتفاصيل الطرد'),
            ),
          ],
        ),
      ),
    );
  }
}
