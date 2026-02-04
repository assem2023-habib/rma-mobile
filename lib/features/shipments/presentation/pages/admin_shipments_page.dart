import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/shipments_bloc.dart';
import '../bloc/shipments_event.dart';
import '../bloc/shipments_state.dart';
import '../../domain/entities/shipment_entity.dart';

class AdminShipmentsPage extends StatefulWidget {
  const AdminShipmentsPage({super.key});

  @override
  State<AdminShipmentsPage> createState() => _AdminShipmentsPageState();
}

class _AdminShipmentsPageState extends State<AdminShipmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ShipmentsBloc>().add(GetAdminShipmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة الشحنات'),
      body: ShinyBackground(
        child: BlocListener<ShipmentsBloc, ShipmentsState>(
          listener: (context, state) {
            if (state is ShipmentActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
              context.read<ShipmentsBloc>().add(GetAdminShipmentsEvent());
            } else if (state is ShipmentsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
              );
            }
          },
          child: BlocBuilder<ShipmentsBloc, ShipmentsState>(
            builder: (context, state) {
              if (state is ShipmentsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ShipmentsLoaded) {
                if (state.shipments.isEmpty) {
                  return const Center(child: Text('لا توجد شحنات حالياً'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  itemCount: state.shipments.length,
                  itemBuilder: (context, index) {
                    final shipment = state.shipments[index];
                    return _ShipmentCard(shipment: shipment);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final ShipmentEntity shipment;

  const _ShipmentCard({required this.shipment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'شحنة #${shipment.id}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing2),
            Text('من: ${shipment.fromCity}'),
            Text('إلى: ${shipment.toCity}'),
            const SizedBox(height: AppDimensions.spacing3),
            Row(
              children: [
                if (shipment.status == 'pending')
                  ElevatedButton(
                    onPressed: () => _departShipment(context),
                    child: const Text('تسجيل انطلاق'),
                  ),
                if (shipment.status == 'in_transit')
                  ElevatedButton(
                    onPressed: () => _arriveShipment(context),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                    child: const Text('تسجيل وصول'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String label;
    switch (shipment.status) {
      case 'pending':
        color = AppColors.warning;
        label = 'قيد الانتظار';
        break;
      case 'in_transit':
        color = AppColors.primary;
        label = 'قيد النقل';
        break;
      case 'arrived':
        color = AppColors.success;
        label = 'وصلت';
        break;
      default:
        color = AppColors.slate500;
        label = shipment.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  void _departShipment(BuildContext context) {
    context.read<ShipmentsBloc>().add(DepartShipmentEvent(shipment.id));
  }

  void _arriveShipment(BuildContext context) {
    context.read<ShipmentsBloc>().add(ArriveShipmentEvent(shipment.id));
  }
}
