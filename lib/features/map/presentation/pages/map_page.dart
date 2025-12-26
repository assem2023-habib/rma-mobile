import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

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
      appBar: AppBar(
        title: Text(
          'تتبع الطرد #${widget.parcelId}',
          style: AppTypography.heading3.copyWith(color: AppColors.slate900),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.slate900,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            _mapController.move(
              LatLng(
                state.parcelLocation.latitude,
                state.parcelLocation.longitude,
              ),
              15.0,
            );
          }
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: AppTypography.bodyLarge),
                  const SizedBox(height: AppDimensions.spacing4),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MapBloc>().add(
                        GetParcelLocationEvent(widget.parcelId),
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          } else if (state is MapLoaded) {
            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: LatLng(
                      state.parcelLocation.latitude,
                      state.parcelLocation.longitude,
                    ),
                    initialZoom: 15.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rma.customer',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            state.parcelLocation.latitude,
                            state.parcelLocation.longitude,
                          ),
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_on,
                            color: AppColors.error,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  bottom: AppDimensions.spacing6,
                  left: AppDimensions.spacing4,
                  right: AppDimensions.spacing4,
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimensions.spacing2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                              ),
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spacing3),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'حالة الطرد: ${state.parcelLocation.status}',
                                    style: AppTypography.heading3.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'آخر تحديث: ${state.parcelLocation.lastUpdated}',
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.slate500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
