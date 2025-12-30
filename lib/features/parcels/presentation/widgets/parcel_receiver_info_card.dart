import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/parcel.dart';

class ParcelReceiverInfoCard extends StatelessWidget {
  final Parcel parcel;
  final VoidCallback onPhoneTap;

  const ParcelReceiverInfoCard({
    super.key,
    required this.parcel,
    required this.onPhoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('معلومات المستلم', style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacing3),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing4),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.person_outline,
                  'الاسم',
                  parcel.receiverName,
                ),
                const Divider(height: AppDimensions.spacing6),
                _buildDetailRow(
                  Icons.phone_outlined,
                  'الهاتف',
                  parcel.receiverPhone,
                  onTap: onPhoneTap,
                ),
                const Divider(height: AppDimensions.spacing6),
                _buildDetailRow(
                  Icons.location_on_outlined,
                  'العنوان',
                  parcel.receiverAddress,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.slate500),
          const SizedBox(width: AppDimensions.spacing3),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: AppColors.slate500),
          ),
          const Spacer(),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              fontWeight: FontWeight.w500,
              color: onTap != null ? AppColors.primaryBlue : null,
            ),
          ),
        ],
      ),
    );
  }
}
