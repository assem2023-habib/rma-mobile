import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/enums/parcel_status.dart';
import '../../domain/entities/parcel.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../widgets/parcel_header_card.dart';
import '../widgets/parcel_progress_bar.dart';
import '../widgets/parcel_tracking_steps.dart';
import '../widgets/parcel_arrival_card.dart';
import '../widgets/parcel_authorization_card.dart';

class ParcelDetailPage extends StatefulWidget {
  final int parcelId;
  final Parcel? parcel;

  const ParcelDetailPage({super.key, required this.parcelId, this.parcel});

  @override
  State<ParcelDetailPage> createState() => _ParcelDetailPageState();
}

class _ParcelDetailPageState extends State<ParcelDetailPage> {
  @override
  void initState() {
    super.initState();
    if (widget.parcel == null) {
      context.read<ParcelsBloc>().add(GetParcelByIdEvent(widget.parcelId));
    }
  }

  double _calculateProgress(ParcelStatus status) {
    switch (status) {
      case ParcelStatus.pending:
        return 0.1;
      case ParcelStatus.confirmed:
        return 0.3;
      case ParcelStatus.inTransit:
        return 0.6;
      case ParcelStatus.outForDelivery:
      case ParcelStatus.readyForPickup:
        return 0.85;
      case ParcelStatus.delivered:
        return 1.0;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParcelsBloc, ParcelsState>(
      builder: (context, state) {
        Parcel? currentParcel = widget.parcel;

        if (state is ParcelDetailLoaded && state.parcel.id == widget.parcelId) {
          currentParcel = state.parcel;
        }

        return Scaffold(
          appBar: CustomAppHeader(
            title: 'تفاصيل الطرد',
            actions: [
              if (currentParcel != null)
                IconButton(
                  icon: const Icon(Icons.map_outlined, color: Colors.white),
                  onPressed: () =>
                      context.push('/map/${currentParcel!.trackingNumber}'),
                  tooltip: 'تتبع على الخريطة',
                ),
            ],
          ),
          body: ShinyBackground(
            child: _buildBody(context, state, currentParcel),
          ),
          bottomNavigationBar: currentParcel != null
              ? Padding(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        context.push('/map/${currentParcel!.trackingNumber}'),
                    icon: const Icon(Icons.map),
                    label: const Text('تتبع الشحنة الآن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                      ),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ParcelsState state, Parcel? parcel) {
    if (parcel == null && state is ParcelsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ParcelsError && parcel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.read<ParcelsBloc>().add(
                GetParcelByIdEvent(widget.parcelId),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    if (parcel == null) {
      return const Center(child: Text('لم يتم العثور على الطرد'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacing4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Parcel Info Card
          ParcelHeaderCard(parcel: parcel),
          const SizedBox(height: AppDimensions.spacing6),

          // 2. Progress Bar Section
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
              border: Border.all(color: AppColors.slate100),
            ),
            child: ParcelProgressBar(
              progress: _calculateProgress(parcel.status),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing6),

          // 3. Tracking Steps
          const Text('حالة الشحنة', style: AppTypography.bodyLarge),
          const SizedBox(height: AppDimensions.spacing4),
          ParcelTrackingSteps(
            currentStatus: parcel.status,
            updatedAt: parcel.updatedAt,
            currentLocation: parcel.status == ParcelStatus.delivered
                ? parcel.toCity
                : parcel.status == ParcelStatus.pending
                ? parcel.fromCity
                : 'في الطريق إلى ${parcel.toCity}',
          ),
          const SizedBox(height: AppDimensions.spacing6),

          // 4. Estimated Arrival Card
          ParcelArrivalCard(
            estimatedDate: parcel.updatedAt.add(const Duration(days: 2)),
          ),
          const SizedBox(height: AppDimensions.spacing6),

          // 5. Authorization Card
          ParcelAuthorizationCard(
            onCreateAuth: () {
              context.read<ParcelsBloc>().add(GetParcelsEvent());
              context.push('/request-authorization', extra: parcel.id);
            },
          ),
          const SizedBox(height: AppDimensions.spacing8),
        ],
      ),
    );
  }
}
