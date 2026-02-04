import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/super_admin_bloc.dart';
import '../../../parcels/presentation/widgets/parcel_card.dart';

class SuperAdminParcelsPage extends StatefulWidget {
  const SuperAdminParcelsPage({super.key});

  @override
  State<SuperAdminParcelsPage> createState() => _SuperAdminParcelsPageState();
}

class _SuperAdminParcelsPageState extends State<SuperAdminParcelsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SuperAdminBloc>().add(const GetGlobalParcelsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'جميع الطرود'),
      body: ShinyBackground(
        child: BlocBuilder<SuperAdminBloc, SuperAdminState>(
          builder: (context, state) {
            if (state is SuperAdminLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GlobalParcelsLoaded) {
              if (state.parcels.isEmpty) {
                return const Center(child: Text('لا توجد طرود حالياً'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(AppDimensions.spacing4),
                itemCount: state.parcels.length,
                itemBuilder: (context, index) {
                  final parcel = state.parcels[index];
                  return ParcelCard(
                    parcel: parcel,
                    onTap: () =>
                        context.push('/parcels/${parcel.id}', extra: parcel),
                  );
                },
              );
            } else if (state is SuperAdminError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
