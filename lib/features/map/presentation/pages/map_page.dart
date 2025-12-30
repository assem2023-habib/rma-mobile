import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';
import '../widgets/map_error_view.dart';
import '../widgets/map_parcel_details_card.dart';
import '../widgets/parcel_map_layers.dart';

class MapPage extends StatefulWidget {
  final String parcelId;

  const MapPage({super.key, required this.parcelId});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Dispatch event to get parcel location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<MapBloc>().add(GetParcelLocationEvent(widget.parcelId));
      }
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppHeader(title: 'تتبع الطرد #${widget.parcelId}'),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          // No need to call _mapController.move here for the initial load
          // as initialCenter in MapOptions handles it.
          // This avoids LateInitializationError.
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapError) {
            return MapErrorView(
              message: state.message,
              onRetry: () {
                context.read<MapBloc>().add(
                  GetParcelLocationEvent(widget.parcelId),
                );
              },
              onBack: () => Navigator.of(context).pop(),
            );
          } else if (state is MapLoaded) {
            return Stack(
              children: [
                ParcelMapLayers(
                  mapController: _mapController,
                  parcelLocation: state.parcelLocation,
                ),
                MapParcelDetailsCard(parcelLocation: state.parcelLocation),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
