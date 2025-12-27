import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rma_customer/core/theme/app_colors.dart';
import 'package:rma_customer/core/theme/app_dimensions.dart';
import 'package:rma_customer/core/theme/app_typography.dart';
import 'package:rma_customer/core/widgets/buttons/gradient_button.dart';

class GuestPromptBottomSheet extends StatelessWidget {
  final String featureName;

  const GuestPromptBottomSheet({super.key, required this.featureName});

  static void show(BuildContext context, String featureName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => GuestPromptBottomSheet(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radius2xl),
        ),
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.slate200,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing6),
          const Icon(
            Icons.lock_outline,
            size: 64,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(height: AppDimensions.spacing4),
          const Text(
            'سجّل دخولك للمتابعة',
            style: AppTypography.heading2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing2),
          Text(
            'يجب تسجيل الدخول للوصول إلى ميزة $featureName',
            style: AppTypography.bodyLarge.copyWith(color: AppColors.slate600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          GradientButton(
            onPressed: () {
              context.pop(); // Close bottom sheet
              context.go('/login');
            },
            text: 'تسجيل الدخول',
          ),
          const SizedBox(height: AppDimensions.spacing3),
          OutlinedButton(
            onPressed: () {
              context.pop(); // Close bottom sheet
              context.go('/register');
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
              side: const BorderSide(color: AppColors.primaryBlue),
            ),
            child: const Text(
              'إنشاء حساب جديد',
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing4),
        ],
      ),
    );
  }
}
