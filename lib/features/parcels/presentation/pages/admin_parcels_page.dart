import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/enums/parcel_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import '../widgets/parcel_card.dart';

class AdminParcelsPage extends StatefulWidget {
  const AdminParcelsPage({super.key});

  @override
  State<AdminParcelsPage> createState() => _AdminParcelsPageState();
}

class _AdminParcelsPageState extends State<AdminParcelsPage> {
  @override
  void initState() {
    super.initState();
    context.read<ParcelsBloc>().add(GetAdminParcelsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إدارة الطرود'),
      body: ShinyBackground(
        child: BlocListener<ParcelsBloc, ParcelsState>(
          listener: (context, state) {
            if (state is ParcelActionSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
              context.read<ParcelsBloc>().add(GetAdminParcelsEvent());
            }
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                child: TextField(
                  onChanged: (value) {
                    context.read<ParcelsBloc>().add(SearchParcelsEvent(value));
                  },
                  decoration: const InputDecoration(
                    hintText: 'البحث عن طرد برقم التتبع أو الاسم...',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing4,
                      vertical: AppDimensions.spacing3,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<ParcelsBloc, ParcelsState>(
                  builder: (context, state) {
                    if (state is ParcelsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ParcelsError) {
                      return Center(child: Text(state.message));
                    } else if (state is ParcelsLoaded) {
                      if (state.parcels.isEmpty) {
                        return const Center(child: Text('لا توجد طرود حالياً'));
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing4,
                        ),
                        itemCount: state.parcels.length,
                        itemBuilder: (context, index) {
                          final parcel = state.parcels[index];
                          return ParcelCard(
                            parcel: parcel,
                            onTap: () {
                              _showStatusUpdateDialog(
                                context,
                                parcel.id,
                                parcel.status,
                              );
                            },
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

  void _showStatusUpdateDialog(
    BuildContext context,
    int parcelId,
    ParcelStatus currentStatus,
  ) {
    const List<ParcelStatus> statuses = ParcelStatus.values;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة الطرد'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              final status = statuses[index];
              return ListTile(
                leading: Icon(status.icon, color: status.color),
                title: Text(status.label),
                trailing: currentStatus == status
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  context.read<ParcelsBloc>().add(
                    UpdateParcelStatusEvent(id: parcelId, status: status.value),
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
