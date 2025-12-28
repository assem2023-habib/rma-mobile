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
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: iconGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: AppDimensions.iconSm,
                ),
              ),
              const SizedBox(width: AppDimensions.spacing2),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing2,
                    vertical: AppDimensions.spacing1 / 2,
                  ),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? AppColors.successLight
                        : AppColors.errorLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    change,
                    style: TextStyle(
                      color: isPositive
                          ? AppColors.successDark
                          : AppColors.errorDark,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacing1),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: AppTypography.heading2.copyWith(
                color: textColor ?? AppColors.slate900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
