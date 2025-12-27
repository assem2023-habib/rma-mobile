import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/badges/status_badge.dart';
import '../../domain/entities/parcel.dart';
import 'package:go_router/go_router.dart';

class ParcelDetailPage extends StatelessWidget {
  final Parcel parcel;

  const ParcelDetailPage({super.key, required this.parcel});

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
            // Tracking Number & Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('رقم التتبع', style: AppTypography.caption),
                            Text(
                              parcel.trackingNumber,
                              style: AppTypography.heading2.copyWith(color: AppColors.primaryBlue),
                            ),
                          ],
                        ),
                        StatusBadge(
                          label: parcel.status.displayName,
                          color: parcel.status.color,
                          backgroundColor: parcel.status.backgroundColor,
                          icon: parcel.status.icon,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing4),

            // Route Info
            const Text('معلومات الشحن', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: Column(
                  children: [
                    _buildRouteInfo(
                      from: parcel.fromCity,
                      to: parcel.toCity,
                    ),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(Icons.calendar_today_outlined, 'تاريخ الإنشاء', 
                      '${parcel.createdAt.day}/${parcel.createdAt.month}/${parcel.createdAt.year}'),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(Icons.fitness_center_outlined, 'الوزن', '${parcel.weight} كغ'),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(Icons.payments_outlined, 'التكلفة', '${parcel.cost} ل.س'),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(
                      parcel.isPaid ? Icons.check_circle_outline : Icons.pending_outlined,
                      'حالة الدفع',
                      parcel.isPaid ? 'تم الدفع' : 'قيد الانتظار',
                      valueColor: parcel.isPaid ? AppColors.success : AppColors.error,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing6),

            // Receiver Info
            const Text('معلومات المستلم', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.person_outline, 'الاسم', parcel.receiverName),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(Icons.phone_outlined, 'الهاتف', parcel.receiverPhone),
                    const Divider(height: AppDimensions.spacing6),
                    _buildDetailRow(Icons.location_on_outlined, 'العنوان', parcel.receiverAddress),
                  ],
                ),
              ),
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

  Widget _buildRouteInfo({required String from, required String to}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('من', style: AppTypography.caption),
              Text(from, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward, color: AppColors.slate300),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('إلى', style: AppTypography.caption),
              Text(to, style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.slate500),
        const SizedBox(width: AppDimensions.spacing3),
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.slate500)),
        const Spacer(),
        Text(
          value,
          style: AppTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
