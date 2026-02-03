import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/enums/parcel_status.dart';

class ParcelTrackingSteps extends StatelessWidget {
  final ParcelStatus currentStatus;
  final DateTime updatedAt;
  final String currentLocation;

  const ParcelTrackingSteps({
    super.key,
    required this.currentStatus,
    required this.updatedAt,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    // Define the sequence of statuses for the tracking flow
    final steps = [
      ParcelStatus.pending,
      ParcelStatus.confirmed,
      ParcelStatus.inTransit,
      ParcelStatus.outForDelivery,
      ParcelStatus.delivered,
    ];

    // Find current step index
    int currentStepIndex = steps.indexOf(currentStatus);
    if (currentStepIndex == -1) {
        // If status is not in the linear flow (e.g. returned, canceled), map to appropriate step or show all
        if (currentStatus == ParcelStatus.readyForPickup) currentStepIndex = 3; // Treat as outForDelivery/Ready
        else currentStepIndex = 0;
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final stepStatus = steps[index];
        final isCompleted = index < currentStepIndex;
        final isCurrent = index == currentStepIndex;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  _buildStepIcon(stepStatus, isCompleted, isCurrent),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isCompleted
                            ? AppColors.success
                            : AppColors.slate200,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppDimensions.spacing4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spacing6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        stepStatus.displayName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isCompleted || isCurrent
                              ? AppColors.slate900
                              : AppColors.slate500,
                          fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(height: 2),
                        Text(
                          '${updatedAt.hour}:${updatedAt.minute.toString().padLeft(2, '0')}',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 12,
                              color: AppColors.slate500,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              currentLocation,
                              style: AppTypography.caption.copyWith(
                                color: AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStepIcon(ParcelStatus status, bool isCompleted, bool isCurrent) {
    if (isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.success, Color(0xFF00C853)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.success.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    } else if (isCurrent) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.1),
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(status.icon, color: Colors.white, size: 20),
            ),
          );
        },
        onEnd: () {}, 
      );
    } else {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.slate100,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        ),
        child: Icon(status.icon, color: AppColors.slate400, size: 20),
      );
    }
  }
}
