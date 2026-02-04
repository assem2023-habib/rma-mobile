import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/trucks_bloc.dart';
import '../bloc/trucks_event.dart';
import '../bloc/trucks_state.dart';
import '../../domain/entities/truck_entity.dart';

class AdminTrucksPage extends StatefulWidget {
  const AdminTrucksPage({super.key});

  @override
  State<AdminTrucksPage> createState() => _AdminTrucksPageState();
}

class _AdminTrucksPageState extends State<AdminTrucksPage> {
  @override
  void initState() {
    super.initState();
    context.read<TrucksBloc>().add(GetAllTrucksEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة الشاحنات'),
      body: ShinyBackground(
        child: BlocListener<TrucksBloc, TrucksState>(
          listener: (context, state) {
            if (state is TruckStatusToggled) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تحديث حالة الشاحنة بنجاح')),
              );
              context.read<TrucksBloc>().add(GetAllTrucksEvent());
            } else if (state is TrucksError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<TrucksBloc, TrucksState>(
            builder: (context, state) {
              if (state is TrucksLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TrucksLoaded) {
                if (state.trucks.isEmpty) {
                  return const Center(child: Text('لا توجد شاحنات حالياً'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  itemCount: state.trucks.length,
                  itemBuilder: (context, index) {
                    final truck = state.trucks[index];
                    return _TruckCard(truck: truck);
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

class _TruckCard extends StatelessWidget {
  final TruckEntity truck;

  const _TruckCard({required this.truck});

  @override
  Widget build(BuildContext context) {
    final isAvailable = truck.status == 'available';

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacing3),
      child: ListTile(
        leading: Icon(
          Icons.local_shipping,
          color: isAvailable ? AppColors.success : AppColors.error,
          size: 32,
        ),
        title: Text('رقم اللوحة: ${truck.plateNumber}'),
        subtitle: Text('الموديل: ${truck.model}'),
        trailing: Switch(
          value: isAvailable,
          onChanged: (value) {
            context.read<TrucksBloc>().add(ToggleTruckStatusEvent(truck.id));
          },
          activeThumbColor: AppColors.success,
        ),
      ),
    );
  }
}
