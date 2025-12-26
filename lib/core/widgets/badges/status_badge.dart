import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_typography.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing2,
        vertical: AppDimensions.spacing1,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
