import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/enums/authorization_status.dart';
import '../bloc/authorizations_bloc.dart';
import '../bloc/authorizations_event.dart';
import '../bloc/authorizations_state.dart';
import '../../domain/entities/authorization_entity.dart';

class AuthorizationsPage extends StatefulWidget {
  const AuthorizationsPage({super.key});

  @override
  State<AuthorizationsPage> createState() => _AuthorizationsPageState();
}

class _AuthorizationsPageState extends State<AuthorizationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthorizationsBloc>().add(GetAuthorizationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('التخويلات', style: AppTypography.heading3),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.read<AuthorizationsBloc>().add(
              GetAuthorizationsEvent(),
            ),
            icon: const Icon(Icons.refresh, color: AppColors.primaryBlue),
          ),
        ],
      ),
      body: BlocBuilder<AuthorizationsBloc, AuthorizationsState>(
        builder: (context, state) {
          if (state is AuthorizationsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AuthorizationsLoaded) {
            if (state.authorizations.isEmpty) {
              return _buildEmptyState();
            }
            return ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.spacing4),
              itemCount: state.authorizations.length,
              itemBuilder: (context, index) {
                final auth = state.authorizations[index];
                return _buildAuthorizationCard(auth);
              },
            );
          } else if (state is AuthorizationsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.spacing4),
                  Text(state.message, style: AppTypography.bodyLarge),
                  TextButton(
                    onPressed: () => context.read<AuthorizationsBloc>().add(
                      GetAuthorizationsEvent(),
                    ),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/request-authorization'),
        label: const Text(
          'طلب تخويل جديد',
          style: TextStyle(color: Colors.white),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_ind_outlined,
            size: 100,
            color: AppColors.slate500.withValues(alpha: 0.3),
          ),
          const SizedBox(height: AppDimensions.spacing6),
          Text(
            'لا يوجد تخويلات حالياً',
            style: AppTypography.heading3.copyWith(color: AppColors.slate500),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthorizationCard(AuthorizationEntity auth) {
    final statusColor = _getStatusColor(auth.status);
    final title = auth.parcel?.trackingNumber ?? 'تخويل طرد #${auth.parcelId}';
    final description = auth.parcel?.receiverName != null
        ? 'تخويل لاستلام طرد: ${auth.parcel!.receiverName}'
        : 'كود التخويل: ${auth.authorizedCode}';

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTypography.heading3),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Text(
                    auth.status.label,
                    style: AppTypography.caption.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing2),
            Text(
              description,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.slate500,
              ),
            ),
            const Divider(height: AppDimensions.spacing6),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppColors.slate500,
                ),
                const SizedBox(width: 8),
                Text(
                  '${auth.generatedAt.year}-${auth.generatedAt.month}-${auth.generatedAt.day}',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.slate500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(AuthorizationStatus status) {
    switch (status) {
      case AuthorizationStatus.active:
        return AppColors.success;
      case AuthorizationStatus.pending:
        return AppColors.warning;
      case AuthorizationStatus.cancelled:
      case AuthorizationStatus.expired:
        return AppColors.error;
      case AuthorizationStatus.used:
        return AppColors.slate500;
    }
  }
}
