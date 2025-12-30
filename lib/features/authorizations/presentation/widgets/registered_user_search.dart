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
        const SizedBox(height: AppDimensions.spacing6),
        const Text(
          'البحث عن مستخدم',
          style: AppTypography.heading3,
        ),
        const SizedBox(height: AppDimensions.spacing2),
        TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'ابحث بالاسم...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMd,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (v) => onSearchChanged(v, context),
        ),
        const SizedBox(height: AppDimensions.spacing2),
        BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            if (state is UsersLoading) {
              return const Center(
                child: LinearProgressIndicator(),
              );
            } else if (state is UsersLoaded) {
              final users = state.usersPagination.data;
              if (users.isEmpty) {
                return const Text('لم يتم العثور على نتائج');
              }
              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.slate200),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMd,
                  ),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: users.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.userName),
                      subtitle: Text('ID: ${user.id}'),
                      onTap: () {
                        userIdController.text = user.id.toString();
                        searchController.text = user.userName;
                        onUserSelected();
                        // Clear search results
                        context.read<UsersBloc>().add(
                          const SearchUsersEvent(''),
                        );
                      },
                    );
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: AppDimensions.spacing4),
        TextFormField(
          controller: userIdController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: 'المعرف المختار (ID)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusMd,
              ),
            ),
            filled: true,
            fillColor: AppColors.slate50,
          ),
          validator: (v) => (v == null || v.isEmpty)
              ? 'يرجى اختيار مستخدم من البحث'
              : null,
        ),
      ],
    );
  }
}
