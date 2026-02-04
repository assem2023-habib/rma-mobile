import 'package:rma_customer/core/config/app_flavor_config.dart';
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
    final isDashboard = AppConfig.instance.isDashboard;
    final authState = context.read<AuthBloc>().state;
    String? userType;
    if (authState is Authenticated) {
      userType = authState.user.userType;
    }

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
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
              ),
              child: Row(
                children: isDashboard
                    ? _buildDashboardActions(context, userType)
                    : _buildCustomerActions(context, authState),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCustomerActions(
    BuildContext context,
    AuthState authState,
  ) {
    return [
      QuickActionCard(
        title: 'طرد جديد',
        description: 'إرسال طرد جديد الآن',
        icon: Icons.add_box_outlined,
        gradient: const [AppColors.primary, AppColors.primaryDark],
        onTap: () {
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
      const SizedBox(width: AppDimensions.spacing3),
      QuickActionCard(
        title: 'الدعم المباشر',
        description: 'تحدث مع الدعم الفني',
        icon: Icons.support_agent_outlined,
        gradient: const [AppColors.info, AppColors.primary],
        onTap: () {
          if (authState is GuestAuthenticated) {
            GuestPromptBottomSheet.show(context, 'المحادثات');
          } else {
            context.push('/chat');
          }
        },
      ),
    ];
  }

  List<Widget> _buildDashboardActions(BuildContext context, String? userType) {
    final List<Widget> actions = [
      QuickActionCard(
        title: 'إدارة الطرود',
        description: 'عرض وتحديث حالة الطرود',
        icon: Icons.inventory_2_outlined,
        gradient: const [AppColors.primary, AppColors.primaryDark],
        onTap: () => context.push('/admin/parcels'),
      ),
      const SizedBox(width: AppDimensions.spacing3),
      QuickActionCard(
        title: 'المواعيد',
        description: 'إدارة مواعيد الفرع',
        icon: Icons.calendar_today_outlined,
        gradient: const [AppColors.success, AppColors.info],
        onTap: () => context.push('/admin/appointments'),
      ),
      const SizedBox(width: AppDimensions.spacing3),
      QuickActionCard(
        title: 'الشحنات',
        description: 'إدارة الرحلات والتحركات',
        icon: Icons.local_shipping_outlined,
        gradient: const [AppColors.warning, AppColors.warning],
        onTap: () => context.push('/admin/shipments'),
      ),
      const SizedBox(width: AppDimensions.spacing3),
      QuickActionCard(
        title: 'الشاحنات',
        description: 'إدارة شاحنات الفرع',
        icon: Icons.local_shipping,
        gradient: const [AppColors.primarySoft, AppColors.info],
        onTap: () => context.push('/admin/trucks'),
      ),
    ];

    if (userType == 'super_admin') {
      actions.insert(
        0,
        QuickActionCard(
          title: 'الإحصائيات العامة',
          description: 'نظرة شاملة على أداء النظام',
          icon: Icons.analytics_outlined,
          gradient: const [AppColors.info, AppColors.primary],
          onTap: () => context.push('/super-admin/stats'),
        ),
      );
      actions.insert(1, const SizedBox(width: AppDimensions.spacing3));
      actions.insert(
        2,
        QuickActionCard(
          title: 'جميع الطرود',
          description: 'مراقبة كافة طرود النظام',
          icon: Icons.inventory_2_outlined,
          gradient: const [AppColors.success, AppColors.primarySoft],
          onTap: () => context.push('/super-admin/parcels'),
        ),
      );
      actions.insert(3, const SizedBox(width: AppDimensions.spacing3));

      actions.addAll([
        const SizedBox(width: AppDimensions.spacing3),
        QuickActionCard(
          title: 'الفروع',
          description: 'إدارة فروع النظام',
          icon: Icons.storefront_outlined,
          gradient: const [AppColors.info, AppColors.primaryBlue],
          onTap: () => context.push('/super-admin/branches'),
        ),
        const SizedBox(width: AppDimensions.spacing3),
        QuickActionCard(
          title: 'الموظفين',
          description: 'إدارة موظفي النظام',
          icon: Icons.people_outline,
          gradient: const [AppColors.primarySoft, AppColors.primary],
          onTap: () => context.push('/super-admin/employees'),
        ),
      ]);
    }

    return actions;
  }
}
