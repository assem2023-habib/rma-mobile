import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/guest_prompt_bottom_sheet.dart';
import './quick_action_card.dart';

class GuestDashboardPlaceholder extends StatelessWidget {
  const GuestDashboardPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick Actions for Guest
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
                child: Text('إجراءات سريعة', style: AppTypography.heading3),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
                child: Row(
                  children: [
                    QuickActionCard(
                      title: 'طرد جديد',
                      description: 'إرسال طرد جديد الآن',
                      icon: Icons.add_box_outlined,
                      gradient: const [AppColors.primary, AppColors.primaryDark],
                      onTap: () => GuestPromptBottomSheet.show(context, 'إرسال طرد'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'تتبع الشحنات',
                      description: 'عرض موقع شحناتك',
                      icon: Icons.map_outlined,
                      gradient: const [AppColors.primaryLight, AppColors.info],
                      onTap: () => context.push('/map/RMA-99001'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'التخويلات',
                      description: 'إدارة تخويلات الاستلام',
                      icon: Icons.security_outlined,
                      gradient: const [AppColors.primarySoft, AppColors.primary],
                      onTap: () => GuestPromptBottomSheet.show(context, 'التخويلات'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'المسارات',
                      description: 'عرض المسارات المتاحة',
                      icon: Icons.route_outlined,
                      gradient: const [AppColors.warning, AppColors.warning],
                      onTap: () => context.push('/routes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Guest Banner
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.textPrimary],
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 48,
                  color: Colors.white,
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  'سجل حسابك الآن',
                  style: AppTypography.heading3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimensions.spacing2),
                Text(
                  'أنشئ حساباً لتتمكن من إرسال الطرود وإدارة تخويلات الاستلام وتتبع شحناتك بالتفصيل.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing6),
                ElevatedButton(
                  onPressed: () => context.push('/register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                    ),
                  ),
                  child: const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
