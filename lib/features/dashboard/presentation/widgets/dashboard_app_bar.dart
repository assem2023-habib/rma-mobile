import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/guest_prompt_bottom_sheet.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../notifications/presentation/bloc/notifications_bloc.dart';
import '../../../notifications/presentation/bloc/notifications_state.dart';

class DashboardAppBar extends StatelessWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildUserGreeting(),
                    _buildActions(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserGreeting() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          ),
          child: const Icon(Icons.local_shipping, color: Colors.white),
        ),
        const SizedBox(width: AppDimensions.spacing3),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'شحن سريع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String name = 'أحمد';
                if (state is Authenticated) {
                  name = state.user.firstName;
                } else if (state is GuestAuthenticated) {
                  name = 'ضيف';
                }
                return Text(
                  'مرحباً بك، $name',
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppDimensions.spacing2),
        BlocBuilder<NotificationsBloc, NotificationsState>(
          builder: (context, state) {
            int unreadCount = 0;
            if (state is NotificationsLoaded) {
              unreadCount = state.unreadCount;
            }
            return GestureDetector(
              onTap: () {
                final authState = context.read<AuthBloc>().state;
                if (authState is GuestAuthenticated) {
                  GuestPromptBottomSheet.show(context, 'الإشعارات');
                } else {
                  context.push('/notifications');
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: const Icon(Icons.notifications_outlined, color: Colors.white),
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        const SizedBox(width: AppDimensions.spacing3),
        GestureDetector(
          onTap: () {
            final authState = context.read<AuthBloc>().state;
            if (authState is GuestAuthenticated) {
              GuestPromptBottomSheet.show(context, 'الملف الشخصي');
            } else {
              context.push('/profile');
            }
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person_outline, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
