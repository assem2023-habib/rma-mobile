import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rma_customer/core/theme/app_colors.dart';
import 'package:rma_customer/core/widgets/backgrounds/shiny_background.dart';
import 'package:rma_customer/core/widgets/headers/custom_app_header.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:rma_customer/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:rma_customer/features/profile/presentation/bloc/profile_state.dart';
import '../widgets/profile_image_header.dart';
import '../widgets/profile_info_form.dart';
import '../widgets/profile_password_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _userNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _nationalNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  int? _selectedCityId;
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // Mock cities for now (same as register page)
  final List<Map<String, dynamic>> _cities = [
    {'id': 1, 'name': 'دمشق'},
    {'id': 2, 'name': 'حلب'},
    {'id': 3, 'name': 'حمص'},
    {'id': 4, 'name': 'اللاذقية'},
    {'id': 5, 'name': 'حماة'},
  ];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _firstNameController.text = authState.user.firstName;
      _lastNameController.text = authState.user.lastName;
      _emailController.text = authState.user.email;
      _userNameController.text = authState.user.userName ?? '';
      _phoneController.text = authState.user.phone;
      _birthdayController.text = authState.user.birthday ?? '';
      _nationalNumberController.text = authState.user.nationalNumber ?? '';
      _addressController.text = authState.user.address ?? '';
      _selectedCityId = authState.user.cityId;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _nationalNumberController.dispose();
    _addressController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppHeader(
        title: 'الملف الشخصي',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/login');
            },
          ),
        ],
      ),
      body: ShinyBackground(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تحديث الملف الشخصي بنجاح'),
                  backgroundColor: AppColors.success,
                ),
              );
              context.read<AuthBloc>().add(AuthCheckRequested());
            } else if (state is PasswordChanged) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم تغيير كلمة المرور بنجاح'),
                  backgroundColor: AppColors.success,
                ),
              );
              _oldPasswordController.clear();
              _newPasswordController.clear();
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileImageHeader(
                  profileImage: _profileImage,
                  onPickImage: _pickImage,
                ),
                const SizedBox(height: 32),
                ProfileInfoForm(
                  formKey: _formKey,
                  firstNameController: _firstNameController,
                  lastNameController: _lastNameController,
                  emailController: _emailController,
                  userNameController: _userNameController,
                  phoneController: _phoneController,
                  birthdayController: _birthdayController,
                  nationalNumberController: _nationalNumberController,
                  addressController: _addressController,
                  selectedCityId: _selectedCityId,
                  cities: _cities,
                  profileImage: _profileImage,
                  onCityChanged: (value) {
                    setState(() {
                      _selectedCityId = value;
                    });
                  },
                ),
                const SizedBox(height: 48),
                ProfilePasswordForm(
                  formKey: _passwordFormKey,
                  oldPasswordController: _oldPasswordController,
                  newPasswordController: _newPasswordController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
