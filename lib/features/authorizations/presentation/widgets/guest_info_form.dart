import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class GuestInfoForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final TextEditingController nationalNumberController;
  final TextEditingController addressController;
  final TextEditingController birthdayController;
  final int? selectedCountryId;
  final int? selectedCityId;
  final List<dynamic> countries;
  final List<dynamic> cities;
  final ValueChanged<int?> onCountryChanged;
  final ValueChanged<int?> onCityChanged;
  final bool isLoadingCountries;
  final bool isLoadingCities;

  const GuestInfoForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.nationalNumberController,
    required this.addressController,
    required this.birthdayController,
    required this.selectedCountryId,
    required this.selectedCityId,
    required this.countries,
    required this.cities,
    required this.onCountryChanged,
    required this.onCityChanged,
    this.isLoadingCountries = false,
    this.isLoadingCities = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.spacing6),
        const Text('بيانات الضيف المخول', style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacing2),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(
                  hintText: 'الاسم الأول',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'يرجى إدخال الاسم الأول' : null,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing2),
            Expanded(
              child: TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(
                  hintText: 'الاسم الأخير',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing3),
        TextFormField(
          controller: phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'رقم هاتف الشخص المخول',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'يرجى إدخال رقم الهاتف';
            }
            if (!RegExp(r'^\+?\d+$').hasMatch(v)) {
              return 'رقم هاتف غير صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spacing3),
        TextFormField(
          controller: nationalNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'الرقم الوطني للشخص المخول',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (v) {
            if (v == null || v.isEmpty) {
              return 'يرجى إدخال الرقم الوطني';
            }
            if (v.length != 11 || !RegExp(r'^\d{11}$').hasMatch(v)) {
              return 'الرقم الوطني يجب أن يكون 11 رقم';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spacing3),
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: 'عنوان الشخص المخول (اختياري)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing3),
        DropdownButtonFormField<int>(
          initialValue: selectedCountryId,
          decoration: InputDecoration(
            hintText: 'الدولة',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: isLoadingCountries
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          items: countries.map((country) {
            return DropdownMenuItem<int>(
              value: country['id'],
              child: Text(country['name']),
            );
          }).toList(),
          onChanged: onCountryChanged,
          validator: (v) => v == null ? 'يرجى اختيار الدولة' : null,
        ),
        const SizedBox(height: AppDimensions.spacing3),
        DropdownButtonFormField<int>(
          initialValue: selectedCityId,
          decoration: InputDecoration(
            hintText: 'المدينة',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: isLoadingCities
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          items: cities.map((city) {
            return DropdownMenuItem<int>(
              value: city['id'],
              child: Text(city['name']),
            );
          }).toList(),
          onChanged: onCityChanged,
          validator: (v) => v == null ? 'يرجى اختيار المدينة' : null,
        ),
        const SizedBox(height: AppDimensions.spacing3),
        TextFormField(
          controller: birthdayController,
          readOnly: true,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(
                const Duration(days: 365 * 18),
              ),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              birthdayController.text = picked.toString().split(' ').first;
            }
          },
          decoration: InputDecoration(
            hintText: 'تاريخ الميلاد (اختياري)',
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
