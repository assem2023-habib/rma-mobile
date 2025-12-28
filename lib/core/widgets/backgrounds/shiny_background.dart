import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ShinyBackground extends StatelessWidget {
  final Widget child;
  final bool showHeaderShiny;

  const ShinyBackground({
    super.key,
    required this.child,
    this.showHeaderShiny = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Background Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
        ),
        
        // Shiny Decorations (Circles)
        if (showHeaderShiny) ...[
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.3),
                    AppColors.primaryLight.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primarySoft.withValues(alpha: 0.2),
                    AppColors.primarySoft.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
        
        // Content
        child,
      ],
    );
  }
}
