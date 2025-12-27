import 'package:flutter/material.dart';
import '../../../../core/enums/parcel_status.dart';
import '../../../../core/enums/rating_type.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/badges/status_badge.dart';
import '../../../rates/presentation/widgets/rating_dialog.dart';
import '../../domain/entities/parcel.dart';

class ParcelCard extends StatelessWidget {
  final Parcel parcel;
  final VoidCallback onTap;

  const ParcelCard({super.key, required this.parcel, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        parcel.trackingNumber,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'بتاريخ: ${_formatDate(parcel.createdAt)}',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (parcel.status == ParcelStatus.delivered)
                    IconButton(
                      icon: const Icon(Icons.star_outline, color: Colors.amber),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => RatingDialog(
                            rateableId: parcel.id,
                            rateableType: RatingForType.parcel,
                          ),
                        );
                      },
                      tooltip: 'تقييم الطرد',
                    ),
                  StatusBadge(
                    label: parcel.status.displayName,
                    color: parcel.status.color,
                    backgroundColor: parcel.status.backgroundColor,
                    icon: parcel.status.icon,
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppDimensions.spacing3),
                child: Divider(color: AppColors.slate100),
              ),
              Row(
                children: [
                  _buildLocationInfo(
                    label: 'من',
                    city: parcel.fromCity,
                    icon: Icons.location_on_outlined,
                    iconColor: AppColors.primaryBlue,
                  ),
                  const Expanded(
                    child: Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: AppColors.slate300,
                    ),
                  ),
                  _buildLocationInfo(
                    label: 'إلى',
                    city: parcel.toCity,
                    icon: Icons.location_on,
                    iconColor: AppColors.error,
                    crossAxisAlignment: CrossAxisAlignment.end,
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacing4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoItem(
                    icon: Icons.person_outline,
                    text: parcel.receiverName,
                  ),
                  Text(
                    '${parcel.cost.toStringAsFixed(0)} ل.س',
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.slate900,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo({
    required String label,
    required String city,
    required IconData icon,
    required Color iconColor,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            label,
            style: AppTypography.caption.copyWith(color: AppColors.slate400),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (crossAxisAlignment == CrossAxisAlignment.start)
                Icon(icon, size: 16, color: iconColor),
              if (crossAxisAlignment == CrossAxisAlignment.start)
                const SizedBox(width: 4),
              Text(
                city,
                style: AppTypography.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (crossAxisAlignment == CrossAxisAlignment.end)
                const SizedBox(width: 4),
              if (crossAxisAlignment == CrossAxisAlignment.end)
                Icon(icon, size: 16, color: iconColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.slate400),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTypography.bodySmall.copyWith(color: AppColors.slate600),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
