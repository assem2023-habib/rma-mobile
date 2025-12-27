import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/cards/stats_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/quick_action_card.dart';

import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/widgets/guest_prompt_bottom_sheet.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  Widget _buildGuestDashboardPlaceholder(BuildContext context) {
    return Column(
      children: [
        // Quick Actions for Guest
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing4,
                ),
                child: Text('إجراءات سريعة', style: AppTypography.heading3),
              ),
              const SizedBox(height: AppDimensions.spacing4),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing4,
                ),
                child: Row(
                  children: [
                    QuickActionCard(
                      title: 'طرد جديد',
                      description: 'إرسال طرد جديد الآن',
                      icon: Icons.add_box_outlined,
                      gradient: const [
                        AppColors.primaryBlue,
                        AppColors.primaryIndigo,
                      ],
                      onTap: () =>
                          GuestPromptBottomSheet.show(context, 'إرسال طرد'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'تتبع الشحنات',
                      description: 'عرض موقع شحناتك',
                      icon: Icons.map_outlined,
                      gradient: const [AppColors.emerald500, AppColors.teal600],
                      onTap: () => context.push('/map/RMA-99001'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'التخويلات',
                      description: 'إدارة تخويلات الاستلام',
                      icon: Icons.security_outlined,
                      gradient: const [AppColors.purple500, AppColors.pink600],
                      onTap: () =>
                          GuestPromptBottomSheet.show(context, 'التخويلات'),
                    ),
                    const SizedBox(width: AppDimensions.spacing3),
                    QuickActionCard(
                      title: 'المسارات',
                      description: 'عرض المسارات المتاحة',
                      icon: Icons.route_outlined,
                      gradient: const [
                        AppColors.warning,
                        AppColors.warningDark,
                      ],
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
                colors: [AppColors.slate800, AppColors.slate900],
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
                    foregroundColor: AppColors.slate900,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Custom AppBar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryBlue,
                          AppColors.primaryIndigo,
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing4,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusXl,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.local_shipping,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: AppDimensions.spacing3),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'شحن سريع',
                                        style: AppTypography.heading3.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                      BlocBuilder<AuthBloc, AuthState>(
                                        builder: (context, state) {
                                          String name = 'أحمد';
                                          if (state is Authenticated) {
                                            name = state.user.firstName;
                                          } else if (state
                                              is GuestAuthenticated) {
                                            name = 'ضيف';
                                          }
                                          return Text(
                                            'مرحباً بك، $name',
                                            style: AppTypography.caption
                                                .copyWith(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.8),
                                                ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  final authState = context
                                      .read<AuthBloc>()
                                      .state;
                                  if (authState is GuestAuthenticated) {
                                    GuestPromptBottomSheet.show(
                                      context,
                                      'الملف الشخصي',
                                    );
                                  } else {
                                    context.push('/profile');
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: const Icon(
                                    Icons.person_outline,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (state is DashboardLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is DashboardError)
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    if (authState is GuestAuthenticated) {
                      return SliverToBoxAdapter(
                        child: _buildGuestDashboardPlaceholder(context),
                      );
                    }
                    return SliverFillRemaining(
                      child: Center(child: Text(state.message)),
                    );
                  },
                )
              else if (state is DashboardLoaded) ...[
                // Quick Actions
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spacing6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing4,
                          ),
                          child: Text(
                            'إجراءات سريعة',
                            style: AppTypography.heading3,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing4),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing4,
                          ),
                          child: Row(
                            children: [
                              QuickActionCard(
                                title: 'طرد جديد',
                                description: 'إرسال طرد جديد الآن',
                                icon: Icons.add_box_outlined,
                                gradient: const [
                                  AppColors.primaryBlue,
                                  AppColors.primaryIndigo,
                                ],
                                onTap: () {
                                  final authState = context
                                      .read<AuthBloc>()
                                      .state;
                                  if (authState is GuestAuthenticated) {
                                    GuestPromptBottomSheet.show(
                                      context,
                                      'إرسال طرد',
                                    );
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
                                gradient: const [
                                  AppColors.emerald500,
                                  AppColors.teal600,
                                ],
                                onTap: () => context.push('/map/RMA-99001'),
                              ),
                              const SizedBox(width: AppDimensions.spacing3),
                              QuickActionCard(
                                title: 'التخويلات',
                                description: 'إدارة تخويلات الاستلام',
                                icon: Icons.security_outlined,
                                gradient: const [
                                  AppColors.purple500,
                                  AppColors.pink600,
                                ],
                                onTap: () {
                                  final authState = context
                                      .read<AuthBloc>()
                                      .state;
                                  if (authState is GuestAuthenticated) {
                                    GuestPromptBottomSheet.show(
                                      context,
                                      'التخويلات',
                                    );
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
                                gradient: const [
                                  AppColors.warning,
                                  AppColors.warningDark,
                                ],
                                onTap: () => context.push('/routes'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Stats Grid
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacing4,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600
                          ? 4
                          : 2,
                      mainAxisSpacing: AppDimensions.spacing3,
                      crossAxisSpacing: AppDimensions.spacing3,
                      childAspectRatio: MediaQuery.of(context).size.width > 600
                          ? 1.6
                          : 1.4,
                    ),
                    delegate: SliverChildListDelegate([
                      StatsCard(
                        title: 'الطرود النشطة',
                        value: state.stats.activeParcels.toString(),
                        change: state.stats.activeParcelsChange,
                        icon: Icons.inventory_2_outlined,
                        iconGradient: const [
                          AppColors.primaryBlue,
                          AppColors.primaryIndigo,
                        ],
                      ),
                      StatsCard(
                        title: 'تم التوصيل',
                        value: state.stats.deliveredParcels.toString(),
                        change: state.stats.deliveredParcelsChange,
                        icon: Icons.check_circle_outline,
                        iconGradient: const [
                          AppColors.success,
                          AppColors.successDark,
                        ],
                      ),
                      StatsCard(
                        title: 'قيد الانتظار',
                        value: state.stats.pendingParcels.toString(),
                        change: state.stats.pendingParcelsChange,
                        icon: Icons.pending_actions,
                        iconGradient: const [
                          AppColors.warning,
                          AppColors.warningDark,
                        ],
                      ),
                      StatsCard(
                        title: 'التقييم العام',
                        value: state.stats.rating.toString(),
                        change: state.stats.ratingChange,
                        icon: Icons.star_outline,
                        iconGradient: const [
                          AppColors.purple500,
                          AppColors.purple600,
                        ],
                      ),
                    ]),
                  ),
                ),

                // Recent Parcels Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.spacing4,
                      AppDimensions.spacing8,
                      AppDimensions.spacing4,
                      AppDimensions.spacing4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الطرود الأخيرة',
                          style: AppTypography.heading3,
                        ),
                        TextButton(
                          onPressed: () => context.push('/parcels'),
                          child: const Text('عرض الكل'),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Parcels List (Placeholder)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacing4,
                        vertical: AppDimensions.spacing2,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusXl,
                          ),
                          border: Border.all(color: AppColors.slate100),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.slate50,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusLg,
                                ),
                              ),
                              child: const Icon(
                                Icons.inventory_2,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PKG-2024-00152$index',
                                    style: AppTypography.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'دمشق ← حلب',
                                    style: AppTypography.caption.copyWith(
                                      color: AppColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successLight,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull,
                                ),
                              ),
                              child: Text(
                                'في الطريق',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.successDark,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: 3),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: AppDimensions.spacing8),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
