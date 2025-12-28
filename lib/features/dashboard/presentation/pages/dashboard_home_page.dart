import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/cards/stats_card.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../parcels/presentation/bloc/parcels_bloc.dart';
import '../../../parcels/presentation/bloc/parcels_event.dart';
import '../../../parcels/presentation/bloc/parcels_state.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';
import '../widgets/quick_action_card.dart';

import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_state.dart';
import '../../../../core/widgets/guest_prompt_bottom_sheet.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(GetDashboardStatsEvent());
    context.read<ParcelsBloc>().add(const GetParcelsEvent());
  }

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
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                      onTap: () =>
                          GuestPromptBottomSheet.show(context, 'إرسال طرد'),
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
                      gradient: const [
                        AppColors.primarySoft,
                        AppColors.primary,
                      ],
                      onTap: () =>
                          GuestPromptBottomSheet.show(context, 'التخويلات'),
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
      body: ShinyBackground(
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // Custom AppBar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(AppDimensions.radius3xl),
                          bottomRight: Radius.circular(AppDimensions.radius3xl),
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
                                    const SizedBox(
                                      width: AppDimensions.spacing3,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'شحن سريع',
                                          style: AppTypography.heading3
                                              .copyWith(color: Colors.white),
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
                                    AppColors.primary,
                                    AppColors.primaryDark,
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
                                    AppColors.primaryLight,
                                    AppColors.info,
                                  ],
                                  onTap: () => context.push('/map/RMA-99001'),
                                ),
                                const SizedBox(width: AppDimensions.spacing3),
                                QuickActionCard(
                                  title: 'التخويلات',
                                  description: 'إدارة تخويلات الاستلام',
                                  icon: Icons.security_outlined,
                                  gradient: const [
                                    AppColors.primarySoft,
                                    AppColors.primary,
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
                                    AppColors.warning,
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
                        childAspectRatio:
                            MediaQuery.of(context).size.width > 600 ? 1.5 : 1.0,
                      ),
                      delegate: SliverChildListDelegate([
                        StatsCard(
                          title: 'إجمالي الطرود',
                          value: state.stats.totalParcels.toString(),
                          change:
                              '${state.stats.parcelsByStatus['Pending'] ?? 0} قيد الانتظار',
                          icon: Icons.inventory_2_outlined,
                          iconGradient: const [
                            AppColors.primary,
                            AppColors.primaryDark,
                          ],
                        ),
                        StatsCard(
                          title: 'تم التوصيل',
                          value: (state.stats.parcelsByStatus['Delivered'] ?? 0)
                              .toString(),
                          change: 'من إجمالي الشحنات',
                          icon: Icons.check_circle_outline,
                          iconGradient: const [
                            AppColors.success,
                            AppColors.info,
                          ],
                        ),
                        StatsCard(
                          title: 'الفروع',
                          value: state.stats.branchesCount.toString(),
                          change: 'فرعاً في خدمتكم',
                          icon: Icons.storefront_outlined,
                          iconGradient: const [
                            AppColors.warning,
                            AppColors.warning,
                          ],
                        ),
                        StatsCard(
                          title: 'تغطيتنا',
                          value: state.stats.citiesCount.toString(),
                          change: 'مدينة حول العالم',
                          icon: Icons.public_outlined,
                          iconGradient: const [
                            AppColors.primarySoft,
                            AppColors.primary,
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

                  // Recent Parcels List
                  BlocBuilder<ParcelsBloc, ParcelsState>(
                    builder: (context, parcelState) {
                      if (parcelState is ParcelsLoading) {
                        return const SliverToBoxAdapter(
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(AppDimensions.spacing4),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      }

                      if (parcelState is ParcelsError) {
                        return SliverToBoxAdapter(
                          child: Center(child: Text(parcelState.message)),
                        );
                      }

                      if (parcelState is ParcelsLoaded) {
                        final recentParcels = parcelState.parcels
                            .take(5)
                            .toList();

                        if (recentParcels.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: Center(child: Text('لا يوجد طرود حالياً')),
                          );
                        }

                        return SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final parcel = recentParcels[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing4,
                                vertical: AppDimensions.spacing2,
                              ),
                              child: GestureDetector(
                                onTap: () => context.push(
                                  '/parcels/${parcel.id}',
                                  extra: parcel,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(
                                    AppDimensions.spacing4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      AppDimensions.radiusXl,
                                    ),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.backgroundSecondary,
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusLg,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.inventory_2,
                                          color: parcel.status.color,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: AppDimensions.spacing4,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              parcel.trackingNumber,
                                              style: AppTypography.bodyLarge
                                                  .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            Text(
                                              '${parcel.fromCity} ← ${parcel.toCity}',
                                              style: AppTypography.caption
                                                  .copyWith(
                                                    color: AppColors.textMuted,
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
                                          color: parcel.status.color.withValues(
                                            alpha: 0.1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppDimensions.radiusFull,
                                          ),
                                        ),
                                        child: Text(
                                          parcel.status.label,
                                          style: AppTypography.caption.copyWith(
                                            color: parcel.status.color,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }, childCount: recentParcels.length),
                        );
                      }

                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    },
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDimensions.spacing8),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
