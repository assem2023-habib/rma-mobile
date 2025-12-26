import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ParcelStatus {
  pending,
  inTransit,
  delivered,
  cancelled,
  returned;

  String get displayName {
    switch (this) {
      case ParcelStatus.pending:
        return 'قيد الانتظار';
      case ParcelStatus.inTransit:
        return 'في الطريق';
      case ParcelStatus.delivered:
        return 'تم التوصيل';
      case ParcelStatus.cancelled:
        return 'ملغي';
      case ParcelStatus.returned:
        return 'مرتجع';
    }
  }

  Color get color {
    switch (this) {
      case ParcelStatus.pending:
        return AppColors.warningDark;
      case ParcelStatus.inTransit:
        return AppColors.primaryBlue;
      case ParcelStatus.delivered:
        return AppColors.successDark;
      case ParcelStatus.cancelled:
        return AppColors.error;
      case ParcelStatus.returned:
        return AppColors.slate600;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ParcelStatus.pending:
        return AppColors.warningLight;
      case ParcelStatus.inTransit:
        return AppColors.primaryLight;
      case ParcelStatus.delivered:
        return AppColors.successLight;
      case ParcelStatus.cancelled:
        return AppColors.error.withValues(alpha: 0.1);
      case ParcelStatus.returned:
        return AppColors.slate100;
    }
  }

  IconData get icon {
    switch (this) {
      case ParcelStatus.pending:
        return Icons.pending_actions;
      case ParcelStatus.inTransit:
        return Icons.local_shipping_outlined;
      case ParcelStatus.delivered:
        return Icons.check_circle_outline;
      case ParcelStatus.cancelled:
        return Icons.cancel_outlined;
      case ParcelStatus.returned:
        return Icons.keyboard_return;
    }
  }
}
