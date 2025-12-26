import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_typography.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool isRequired;
  final String? Function(String?)? validator;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.prefixIcon,
    this.controller,
    this.keyboardType,
    this.isRequired = false,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.slate700,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: AppColors.error),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing2),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.bodySmall.copyWith(color: AppColors.slate400),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: AppColors.slate400, size: 20)
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing4,
              vertical: AppDimensions.spacing3,
            ),
          ),
        ),
      ],
    );
  }
}
