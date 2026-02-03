import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

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
        const SizedBox(height: AppDimensions.spacing4),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: firstNameController,
                hint: 'الاسم الأول',
                icon: Icons.person_outline,
                validator: (v) => (v == null || v.isEmpty) ? 'مطلوب' : null,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing3),
            Expanded(
              child: _buildTextField(
                controller: lastNameController,
                hint: 'الاسم الأخير',
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing3),
        _buildTextField(
          controller: phoneController,
          hint: 'رقم هاتف الشخص المخول',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (v) {
            if (v == null || v.isEmpty) return 'يرجى إدخال رقم الهاتف';
            if (!RegExp(r'^\+?\d+$').hasMatch(v)) return 'رقم هاتف غير صحيح';
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spacing3),
        _buildTextField(
          controller: nationalNumberController,
          hint: 'الرقم الوطني / رقم الهوية',
          icon: Icons.badge_outlined,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'يرجى إدخال الرقم الوطني' : null,
        ),
        const SizedBox(height: AppDimensions.spacing3),
        _buildTextField(
          controller: addressController,
          hint: 'العنوان بالتفصيل',
          icon: Icons.location_on_outlined,
          maxLines: 2,
          validator: (v) =>
              (v == null || v.isEmpty) ? 'يرجى إدخال العنوان' : null,
        ),
        const SizedBox(height: AppDimensions.spacing3),
        _buildTextField(
          controller: birthdayController,
          hint: 'تاريخ الميلاد (YYYY-MM-DD)',
          icon: Icons.cake_outlined,
          readOnly: true,
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(
                const Duration(days: 365 * 20),
              ),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (date != null) {
              birthdayController.text = date.toString().split(' ')[0];
            }
          },
        ),
        const SizedBox(height: AppDimensions.spacing3),
        Row(
          children: [
            Expanded(
              child: _buildDropdown<int>(
                hint: 'البلد',
                value: selectedCountryId,
                items: countries
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c['id'],
                        child: Text(c['name']),
                      ),
                    )
                    .toList(),
                onChanged: onCountryChanged,
                isLoading: isLoadingCountries,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing3),
            Expanded(
              child: _buildDropdown<int>(
                hint: 'المدينة',
                value: selectedCityId,
                items: cities
                    .map(
                      (c) => DropdownMenuItem<int>(
                        value: c['id'],
                        child: Text(c['name']),
                      ),
                    )
                    .toList(),
                onChanged: onCityChanged,
                isLoading: isLoadingCities,
                enabled: selectedCountryId != null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
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
      validator: validator,
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    bool isLoading = false,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        hintText: isLoading ? 'جاري التحميل...' : hint,
        prefixIcon: Icon(
          isLoading ? Icons.sync : Icons.map_outlined,
          color: enabled ? AppColors.primary : AppColors.slate300,
          size: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          borderSide: const BorderSide(color: AppColors.slate200),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : AppColors.slate50,
      ),
      validator: (v) => (v == null && enabled) ? 'مطلوب' : null,
    );
  }
}
