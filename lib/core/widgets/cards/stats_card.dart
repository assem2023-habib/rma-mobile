import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_typography.dart';
import 'info_card.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final List<Color> iconGradient;
  final Color? textColor;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.iconGradient,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = !change.startsWith('-');
    
    return InfoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: AppDimensions.iconMd,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing2,
                  vertical: AppDimensions.spacing1,
                ),
                decoration: BoxDecoration(
                  color: isPositive ? AppColors.successLight : AppColors.errorLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: isPositive ? AppColors.successDark : AppColors.errorDark,
                    fontSize: AppTypography.fontSizeXs,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing4),
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.slate500,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing1),
          Text(
            value,
            style: AppTypography.heading2.copyWith(
              color: textColor ?? AppColors.slate900,
            ),
          ),
        ],
      ),
    );
  }
}
