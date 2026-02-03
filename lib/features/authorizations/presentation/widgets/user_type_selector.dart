import 'package:flutter/material.dart';
import 'package:rma_customer/core/theme/app_colors.dart';
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
        Row(
          children: [
            _buildTypeCard(
              context,
              'user',
              'مستخدم مسجل',
              Icons.person_outline,
              Icons.person,
            ),
            const SizedBox(width: AppDimensions.spacing3),
            _buildTypeCard(
              context,
              'guest',
              'ضيف',
              Icons.person_add_outlined,
              Icons.person_add,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    BuildContext context,
    String type,
    String label,
    IconData icon,
    IconData selectedIcon,
  ) {
    final isSelected = selectedUserType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacing4),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : AppColors.slate50,
            borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.slate200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                isSelected ? selectedIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.slate500,
                size: 28,
              ),
              const SizedBox(height: AppDimensions.spacing2),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.slate700,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
