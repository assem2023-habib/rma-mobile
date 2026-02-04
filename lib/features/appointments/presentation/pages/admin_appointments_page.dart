import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/appointment_bloc.dart';
import '../bloc/appointment_event.dart';
import '../bloc/appointment_state.dart';
import '../../domain/entities/appointment_entity.dart';

class AdminAppointmentsPage extends StatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppointmentBloc>().add(GetAdminAppointmentsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة المواعيد'),
      body: ShinyBackground(
        child: BlocListener<AppointmentBloc, AppointmentState>(
          listener: (context, state) {
            if (state is AppointmentStatusUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث حالة الموعد بنجاح')),
              );
              context.read<AppointmentBloc>().add(GetAdminAppointmentsEvent());
            }
          },
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AppointmentBloc, AppointmentState>(
                  builder: (context, state) {
                    if (state is AppointmentLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is AppointmentError) {
                      return Center(child: Text(state.message));
                    } else if (state is AdminAppointmentsLoaded) {
                      if (state.appointments.isEmpty) {
                        return const Center(
                          child: Text('لا توجد مواعيد حالياً'),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(AppDimensions.spacing4),
                        itemCount: state.appointments.length,
                        itemBuilder: (context, index) {
                          final appointment = state.appointments[index];
                          return _AppointmentAdminCard(
                            appointment: appointment,
                          );
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AppointmentAdminCard extends StatelessWidget {
  final AppointmentEntity appointment;

  const _AppointmentAdminCard({required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      child: ListTile(
        title: Text('${appointment.date} - ${appointment.time}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رقم الفرع: ${appointment.branchId}'),
            if (appointment.status != null)
              Text('الحالة: ${_getStatusLabel(appointment.status!)}'),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing2,
            vertical: AppDimensions.spacing1,
          ),
          decoration: BoxDecoration(
            color: _getStatusColor(appointment.status ?? (appointment.booked ? 'booked' : 'available'))
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            _getStatusLabel(appointment.status ?? (appointment.booked ? 'booked' : 'available')),
            style: TextStyle(
              color: _getStatusColor(appointment.status ?? (appointment.booked ? 'booked' : 'available')),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () {
          _showStatusUpdateDialog(context);
        },
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'completed':
        return 'مكتمل';
      case 'cancelled':
        return 'ملغى';
      case 'booked':
        return 'محجوز';
      case 'available':
        return 'متاح';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'completed':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'booked':
        return AppColors.error;
      case 'available':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  void _showStatusUpdateDialog(BuildContext context) {
    final statuses = ['pending', 'completed', 'cancelled'];
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تحديث حالة الموعد'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              return ListTile(
                title: Text(_getStatusLabel(status)),
                onTap: () {
                  context.read<AppointmentBloc>().add(
                    UpdateAppointmentStatusEvent(
                      id: appointment.id,
                      status: status,
                    ),
                  );
                  Navigator.pop(dialogContext);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}
