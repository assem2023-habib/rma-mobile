import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/route_entity.dart';

class RouteDetailPage extends StatelessWidget {
  final RouteEntity route;

  const RouteDetailPage({super.key, required this.route});

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
        title: const Text('تفاصيل المسار', style: AppTypography.heading2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Route Header Card
            Container(
              padding: const EdgeInsets.all(AppDimensions.spacing6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryBlue, AppColors.primaryIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radius2xl),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          route.name,
                          style: AppTypography.heading1.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      _buildStatusBadge(route.status),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacing6),
                  Row(
                    children: [
                      _buildLocationPoint(route.fromCity, 'نقطة الانطلاق'),
                      const Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimensions.spacing2,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      _buildLocationPoint(route.toCity, 'وجهة الوصول'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing6),

            // Driver Info Section
            const Text('معلومات السائق', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryBlue,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: Text(route.driverName, style: AppTypography.bodyLarge),
                subtitle: const Text('سائق محترف معتمد'),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.primaryBlue,
                  ),
                  onPressed: () =>
                      _makePhoneCall('+963912345678'), // رقم تجريبي
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing6),

            // Schedule Section
            const Text('الجدول الزمني', style: AppTypography.heading3),
            const SizedBox(height: AppDimensions.spacing3),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.calendar_today_outlined,
                      'التاريخ',
                      '${route.date.day}/${route.date.month}/${route.date.year}',
                    ),
                    const Divider(height: AppDimensions.spacing6),
                    _buildInfoRow(
                      Icons.access_time,
                      'وقت الانطلاق المتوقع',
                      '08:00 صباحاً',
                    ),
                    const Divider(height: AppDimensions.spacing6),
                    _buildInfoRow(
                      Icons.timer_outlined,
                      'وقت الوصول المتوقع',
                      '02:00 مساءً',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isActive = status == 'نشط';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing3,
        vertical: AppDimensions.spacing1,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.black.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        status,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLocationPoint(String city, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
        Text(
          city,
          style: AppTypography.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
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
          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
