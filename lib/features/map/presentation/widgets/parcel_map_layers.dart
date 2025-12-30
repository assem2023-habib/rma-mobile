import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/parcel_location.dart';

class ParcelMapLayers extends StatelessWidget {
  final MapController mapController;
  final ParcelLocation parcelLocation;

  const ParcelMapLayers({
    super.key,
    required this.mapController,
    required this.parcelLocation,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: LatLng(
          parcelLocation.latitude,
          parcelLocation.longitude,
        ),
        initialZoom: 10.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.rma.customer',
        ),
        if (parcelLocation.sourceBranch != null &&
            parcelLocation.destinationBranch != null)
          PolylineLayer(
            polylines: [
              Polyline(
                points: [
                  LatLng(
                    parcelLocation.sourceBranch!.latitude,
                    parcelLocation.sourceBranch!.longitude,
                  ),
                  LatLng(
                    parcelLocation.latitude,
                    parcelLocation.longitude,
                  ),
                  LatLng(
                    parcelLocation.destinationBranch!.latitude,
                    parcelLocation.destinationBranch!.longitude,
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
            if (parcelLocation.sourceBranch != null)
              Marker(
                point: LatLng(
                  parcelLocation.sourceBranch!.latitude,
                  parcelLocation.sourceBranch!.longitude,
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
                        parcelLocation.sourceBranch!.branchName,
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
            if (parcelLocation.destinationBranch != null)
              Marker(
                point: LatLng(
                  parcelLocation.destinationBranch!.latitude,
                  parcelLocation.destinationBranch!.longitude,
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
                        parcelLocation.destinationBranch!.branchName,
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
                parcelLocation.latitude,
                parcelLocation.longitude,
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
    );
  }
}
