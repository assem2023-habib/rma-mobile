import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rma_customer/features/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:rma_customer/features/notifications/presentation/bloc/notifications_bloc.dart';
import 'package:rma_customer/features/notifications/presentation/bloc/notifications_event.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../parcels/presentation/bloc/parcels_bloc.dart';
import '../../../parcels/presentation/bloc/parcels_event.dart';
import '../../../parcels/presentation/bloc/parcels_state.dart';
import '../../../parcels/presentation/widgets/parcel_card.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_state.dart';

import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_state.dart';

import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_quick_actions.dart';
import '../widgets/dashboard_stats_grid.dart';
import '../widgets/guest_dashboard_placeholder.dart';

class DashboardHomePage extends StatefulWidget {
  const DashboardHomePage({super.key});

  @override
  State<DashboardHomePage> createState() => _DashboardHomePageState();
}

class _DashboardHomePageState extends State<DashboardHomePage> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final authState = context.read<AuthBloc>().state;
    String? userType;
    if (authState is Authenticated) {
      userType = authState.user.userType;
    }
    
    context.read<DashboardBloc>().add(GetDashboardStatsEvent(userType: userType));
    context.read<ParcelsBloc>().add(GetParcelsEvent());
    context.read<NotificationsBloc>().add(GetNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShinyBackground(
        child: RefreshIndicator(
          onRefresh: () async => _loadData(),
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  const DashboardAppBar(),
                  if (state is DashboardLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (state is DashboardError)
                    _buildErrorState(state)
                  else if (state is DashboardLoaded) ...[
                    const DashboardQuickActions(),
                    DashboardStatsGrid(state: state),
                    _buildRecentParcelsHeader(),
                    _buildRecentParcelsList(),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(DashboardError state) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is GuestAuthenticated) {
          return const SliverToBoxAdapter(child: GuestDashboardPlaceholder());
        }
        return SliverFillRemaining(child: Center(child: Text(state.message)));
      },
    );
  }

  Widget _buildRecentParcelsHeader() {
    return SliverToBoxAdapter(
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
            const Text('الطرود الأخيرة', style: AppTypography.heading3),
            TextButton(
              onPressed: () => context.push('/parcels'),
              child: const Text('عرض الكل'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentParcelsList() {
    return BlocBuilder<ParcelsBloc, ParcelsState>(
      builder: (context, state) {
        if (state is ParcelsLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is ParcelsLoaded) {
          final parcels = state.parcels.take(5).toList();
          if (parcels.isEmpty) {
            return const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.spacing8),
                child: Center(child: Text('لا توجد طرود حالياً')),
              ),
            );
          }
          return SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing4,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final parcel = parcels[index];
                return ParcelCard(
                  parcel: parcel,
                  onTap: () =>
                      context.push('/parcels/${parcel.id}', extra: parcel),
                );
              }, childCount: parcels.length),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
