import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../parcels/presentation/bloc/parcels_bloc.dart';
import '../../../parcels/presentation/bloc/parcels_state.dart';

class ParcelSelectionField extends StatelessWidget {
  final int? selectedParcelId;
  final ValueChanged<int?> onChanged;

  const ParcelSelectionField({
    super.key,
    required this.selectedParcelId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParcelsBloc, ParcelsState>(
      builder: (context, state) {
        if (state is ParcelsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ParcelsLoaded) {
          final parcelExists = selectedParcelId != null &&
              state.parcels.any((p) => p.id == selectedParcelId);

          return DropdownButtonFormField<int>(
            initialValue: parcelExists ? selectedParcelId : null,
            decoration: InputDecoration(
              hintText: 'اختر الطرد المراد تخويله',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusMd,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: state.parcels.map((parcel) {
              return DropdownMenuItem<int>(
                value: parcel.id,
                child: Text(
                  '${parcel.trackingNumber} - ${parcel.receiverName}',
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'يرجى اختيار الطرد' : null,
          );
        }
        return const Text('لا توجد طرود متاحة للتخويل');
      },
    );
  }
}
