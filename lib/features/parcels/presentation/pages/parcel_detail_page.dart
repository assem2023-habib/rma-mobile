import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/parcel.dart';
import 'package:go_router/go_router.dart';
import '../widgets/parcel_header_card.dart';
import '../widgets/parcel_shipping_info_card.dart';
import '../widgets/parcel_receiver_info_card.dart';
import '../widgets/parcel_authorization_card.dart';

class ParcelDetailPage extends StatelessWidget {
  final Parcel parcel;

  const ParcelDetailPage({super.key, required this.parcel});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطرد', style: AppTypography.heading2),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push('/map/${parcel.trackingNumber}'),
            tooltip: 'تتبع على الخريطة',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                // Ensure Parcels are loaded in the bloc before navigating
                // so that the dropdown can find the parcelId
                context.read<ParcelsBloc>().add(GetParcelsEvent());
                context.push('/request-authorization', extra: parcel.id);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: ElevatedButton.icon(
          onPressed: () => context.push('/map/${parcel.trackingNumber}'),
          icon: const Icon(Icons.map),
          label: const Text('تتبع الشحنة الآن'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ),
    );
  }
}
