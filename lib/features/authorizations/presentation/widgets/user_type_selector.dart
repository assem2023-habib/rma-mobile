import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';

class UserTypeSelector extends StatelessWidget {
  final String selectedUserType;
  final ValueChanged<String?> onChanged;

  const UserTypeSelector({
    super.key,
    required this.selectedUserType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('نوع الشخص المخول', style: AppTypography.heading3),
        const SizedBox(height: AppDimensions.spacing2),
        DropdownButtonFormField<String>(
          initialValue: selectedUserType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMd,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          items: const [
            DropdownMenuItem(value: 'user', child: Text('مستخدم مسجل')),
            DropdownMenuItem(value: 'guest', child: Text('ضيف')),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
