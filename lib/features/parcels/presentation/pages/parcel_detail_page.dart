import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../domain/entities/parcel.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../widgets/parcel_header_card.dart';
import '../widgets/parcel_shipping_info_card.dart';
import '../widgets/parcel_receiver_info_card.dart';
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
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
                  onPressed: () => context.push('/map/${currentParcel!.trackingNumber}'),
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
                    onPressed: () => context.push('/map/${currentParcel!.trackingNumber}'),
                    icon: const Icon(Icons.map),
                    label: const Text('تتبع الشحنة الآن'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
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
              onPressed: () =>
                  context.read<ParcelsBloc>().add(GetParcelByIdEvent(widget.parcelId)),
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
          ParcelHeaderCard(parcel: parcel),
          const SizedBox(height: AppDimensions.spacing4),
          ParcelShippingInfoCard(parcel: parcel),
          const SizedBox(height: AppDimensions.spacing6),
          ParcelReceiverInfoCard(
            parcel: parcel,
            onPhoneTap: () => _makePhoneCall(parcel.receiverPhone),
          ),
          const SizedBox(height: AppDimensions.spacing6),
          ParcelAuthorizationCard(
            onCreateAuth: () {
              context.read<ParcelsBloc>().add(GetParcelsEvent());
              context.push('/request-authorization', extra: parcel.id);
            },
          ),
        ],
      ),
    );
  }
}
