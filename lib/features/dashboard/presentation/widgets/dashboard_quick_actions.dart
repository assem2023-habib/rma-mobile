import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/guest_prompt_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import './quick_action_card.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
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
                    onTap: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is GuestAuthenticated) {
                        GuestPromptBottomSheet.show(context, 'إرسال طرد');
                      } else {
                        context.push('/new-parcel');
                      }
                    },
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
                    onTap: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is GuestAuthenticated) {
                        GuestPromptBottomSheet.show(context, 'التخويلات');
                      } else {
                        context.push('/authorizations');
                      }
                    },
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
    );
  }
}
