import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum ParcelStatus {
  pending('Pending', 'قيد الانتظار'),
  confirmed('Confirmed', 'مؤكد'),
  inTransit('In_transit', 'قيد النقل'),
  outForDelivery('Out_For_Delivery', 'خارج للتوصيل'),
  readyForPickup('Ready_For_Pickup', 'جاهز للاستلام'),
  delivered('Delivered', 'تم التسليم'),
  failed('Failed', 'فشل'),
  returned('Returned', 'مُعاد'),
  canceled('Canceled', 'ملغى');

  final String value;
  final String label;
  const ParcelStatus(this.value, this.label);

  static ParcelStatus fromString(String value) {
    return ParcelStatus.values.firstWhere(
      (e) => e.value.toLowerCase() == value.toLowerCase(),
      orElse: () => ParcelStatus.pending,
    );
  }

  String get displayName => label;

  Color get color {
    switch (this) {
      case ParcelStatus.pending:
        return AppColors.warningDark;
      case ParcelStatus.confirmed:
        return AppColors.primaryBlue;
      case ParcelStatus.inTransit:
        return AppColors.primaryBlue;
      case ParcelStatus.outForDelivery:
        return Colors.orange;
      case ParcelStatus.readyForPickup:
        return Colors.teal;
      case ParcelStatus.delivered:
        return AppColors.successDark;
      case ParcelStatus.failed:
        return AppColors.error;
      case ParcelStatus.returned:
        return AppColors.slate600;
      case ParcelStatus.canceled:
        return AppColors.error;
    }
  }

  Color get backgroundColor {
    switch (this) {
      case ParcelStatus.pending:
        return AppColors.warningLight;
      case ParcelStatus.confirmed:
        return AppColors.primaryLight;
      case ParcelStatus.inTransit:
        return AppColors.primaryLight;
      case ParcelStatus.outForDelivery:
        return Colors.orange.withValues(alpha: 0.1);
      case ParcelStatus.readyForPickup:
        return Colors.teal.withValues(alpha: 0.1);
      case ParcelStatus.delivered:
        return AppColors.successLight;
      case ParcelStatus.failed:
        return AppColors.error.withValues(alpha: 0.1);
      case ParcelStatus.returned:
        return AppColors.slate100;
      case ParcelStatus.canceled:
        return AppColors.error.withValues(alpha: 0.1);
    }
  }

  IconData get icon {
    switch (this) {
      case ParcelStatus.pending:
        return Icons.pending_actions;
      case ParcelStatus.confirmed:
        return Icons.check_circle_outline;
      case ParcelStatus.inTransit:
        return Icons.local_shipping_outlined;
      case ParcelStatus.outForDelivery:
        return Icons.delivery_dining_outlined;
      case ParcelStatus.readyForPickup:
        return Icons.storefront_outlined;
      case ParcelStatus.delivered:
        return Icons.check_circle;
      case ParcelStatus.failed:
        return Icons.error_outline;
      case ParcelStatus.returned:
        return Icons.keyboard_return;
      case ParcelStatus.canceled:
        return Icons.cancel_outlined;
    }
  }
}
