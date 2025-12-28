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
          // No need to call _mapController.move here for the initial load
          // as initialCenter in MapOptions handles it.
          // This avoids LateInitializationError.
        },
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_off_outlined,
                      size: 80,
                      color: AppColors.slate300,
                    ),
                    const SizedBox(height: AppDimensions.spacing4),
                    Text(
                      'تتبع غير متاح',
                      style: AppTypography.heading3.copyWith(
                        color: AppColors.slate900,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing2),
                    Text(
                      state.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.slate500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppDimensions.spacing8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<MapBloc>().add(
                            GetParcelLocationEvent(widget.parcelId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing3),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('العودة لتفاصيل الطرد'),
                    ),
                  ],
                ),
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
                    initialZoom: 10.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.rma.customer',
                    ),
                    if (state.parcelLocation.sourceBranch != null &&
                        state.parcelLocation.destinationBranch != null)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              LatLng(
                                state.parcelLocation.sourceBranch!.latitude,
                                state.parcelLocation.sourceBranch!.longitude,
                              ),
                              LatLng(
                                state.parcelLocation.latitude,
                                state.parcelLocation.longitude,
                              ),
                              LatLng(
                                state
                                    .parcelLocation
                                    .destinationBranch!
                                    .latitude,
                                state
                                    .parcelLocation
                                    .destinationBranch!
                                    .longitude,
                              ),
                            ],
                            color: AppColors.primaryBlue,
                            strokeWidth: 4.0,
                            isDotted: true,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        // Source Branch Marker
                        if (state.parcelLocation.sourceBranch != null)
                          Marker(
                            point: LatLng(
                              state.parcelLocation.sourceBranch!.latitude,
                              state.parcelLocation.sourceBranch!.longitude,
                            ),
                            width: 80,
                            height: 80,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    state
                                        .parcelLocation
                                        .sourceBranch!
                                        .branchName,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        // Destination Branch Marker
                        if (state.parcelLocation.destinationBranch != null)
                          Marker(
                            point: LatLng(
                              state.parcelLocation.destinationBranch!.latitude,
                              state.parcelLocation.destinationBranch!.longitude,
                            ),
                            width: 80,
                            height: 80,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    state
                                        .parcelLocation
                                        .destinationBranch!
                                        .branchName,
                                    style: AppTypography.bodySmall.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.location_on,
                                  color: AppColors.error,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                        // Current Location Marker
                        Marker(
                          point: LatLng(
                            state.parcelLocation.latitude,
                            state.parcelLocation.longitude,
                          ),
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.local_shipping,
                            color: AppColors.primaryBlue,
                            size: 45,
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
