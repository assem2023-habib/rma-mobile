import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../users/presentation/bloc/users_bloc.dart';

class RegisteredUserSearch extends StatelessWidget {
  final TextEditingController searchController;
  final TextEditingController userIdController;
  final Function(String, BuildContext) onSearchChanged;
  final VoidCallback onUserSelected;

  const RegisteredUserSearch({
    super.key,
    required this.searchController,
    required this.userIdController,
    required this.onSearchChanged,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.spacing4),
        TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'ابحث عن مستخدم بالاسم...',
            prefixIcon: const Icon(Icons.person_search, color: AppColors.primary),
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
          onChanged: (v) => onSearchChanged(v, context),
          validator: (v) {
            if (userIdController.text.isEmpty) {
              return 'يرجى اختيار مستخدم من نتائج البحث';
            }
            return null;
          },
        ),
        const SizedBox(height: AppDimensions.spacing2),
        BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
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
            } else if (state is UsersLoaded) {
              final users = state.usersPagination.data;
              if (users.isEmpty && searchController.text.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(AppDimensions.spacing4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.error, size: 20),
                      const SizedBox(width: AppDimensions.spacing2),
                      Text(
                        'لم يتم العثور على مستخدم بهذا الاسم',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
                      ),
                    ],
                  ),
                );
              }
              
              if (users.isEmpty) return const SizedBox.shrink();

              return Container(
                margin: const EdgeInsets.only(top: AppDimensions.spacing2),
                constraints: const BoxConstraints(maxHeight: 250),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: AppColors.slate100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: users.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: AppColors.slate100,
                      indent: AppDimensions.spacing4,
                      endIndent: AppDimensions.spacing4,
                    ),
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            user.userName[0].toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          user.userName,
                          style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'ID: ${user.id}',
                          style: AppTypography.caption.copyWith(color: AppColors.slate500),
                        ),
                        onTap: () {
                          userIdController.text = user.id.toString();
                          searchController.text = user.userName;
                          onUserSelected();
                          context.read<UsersBloc>().add(const SearchUsersEvent(''));
                        },
                      );
                    },
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
