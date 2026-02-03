import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rma_customer/core/theme/app_colors.dart';
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
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing2),
            child: Center(
              child: SizedBox(
                height: 2,
                child: LinearProgressIndicator(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
          );
        } else if (state is ParcelsLoaded) {
          final parcelExists = selectedParcelId != null &&
              state.parcels.any((p) => p.id == selectedParcelId);

          return DropdownButtonFormField<int>(
            initialValue: parcelExists ? selectedParcelId : null,
            decoration: InputDecoration(
              hintText: 'اختر الطرد المراد تخويله',
              prefixIcon: const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                borderSide: const BorderSide(color: AppColors.slate200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing4,
                vertical: AppDimensions.spacing4,
              ),
            ),
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            items: state.parcels.map((parcel) {
              return DropdownMenuItem<int>(
                value: parcel.id,
                child: Text(
                  '${parcel.trackingNumber} - ${parcel.receiverName}',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'يرجى اختيار الطرد' : null,
          );
        }
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              SizedBox(width: AppDimensions.spacing2),
              Text('لا توجد طرود متاحة للتخويل'),
            ],
          ),
        );
      },
    );
  }
}
