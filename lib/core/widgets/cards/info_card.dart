import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class InfoCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? borderColor;
  final Color? backgroundColor;

  const InfoCard({
    super.key,
    required this.child,
    this.padding,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacing4),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
        border: Border.all(color: borderColor ?? AppColors.slate100),
        boxShadow: [
          BoxShadow(
            color: AppColors.slate200.withValues(alpha: 0.5),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
