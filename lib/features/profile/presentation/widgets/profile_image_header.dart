import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfileImageHeader extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onPickImage;

  const ProfileImageHeader({
    super.key,
    this.profileImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String? imageUrl;
              if (state is Authenticated) {
                imageUrl = state.user.imageProfile;
              }

              return CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: profileImage != null
                    ? FileImage(profileImage!)
                    : (imageUrl != null
                        ? CachedNetworkImageProvider(imageUrl) as ImageProvider
                        : null),
                child: profileImage == null && imageUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primaryBlue,
                      )
                    : null,
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryBlue,
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
                onPressed: onPickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
