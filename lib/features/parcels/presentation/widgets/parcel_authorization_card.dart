import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class ParcelAuthorizationCard extends StatelessWidget {
  final VoidCallback onCreateAuth;

  const ParcelAuthorizationCard({super.key, required this.onCreateAuth});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('التخويلات', style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacing3),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing4),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.security_outlined,
                      color: AppColors.primaryBlue,
                      size: 30,
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'تخويل شخص آخر بالاستلام',
                            style: AppTypography.bodyLarge,
                          ),
                          Text(
                            'يمكنك تخويل شخص آخر لاستلام هذا الطرد بدلاً عنك',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing4),
                OutlinedButton.icon(
                  onPressed: onCreateAuth,
                  icon: const Icon(Icons.add_moderator_outlined),
                  label: const Text('إنشاء تخويل جديد'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    foregroundColor: AppColors.primaryBlue,
                    side: const BorderSide(color: AppColors.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
