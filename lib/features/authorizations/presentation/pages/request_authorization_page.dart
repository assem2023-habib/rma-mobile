import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../bloc/authorizations_bloc.dart';
import '../bloc/authorizations_event.dart';
import '../bloc/authorizations_state.dart';

import 'package:rma_customer/features/parcels/presentation/bloc/parcels_bloc.dart';
import 'package:rma_customer/features/parcels/presentation/bloc/parcels_state.dart';

class RequestAuthorizationPage extends StatefulWidget {
  const RequestAuthorizationPage({super.key});

  @override
  State<RequestAuthorizationPage> createState() =>
      _RequestAuthorizationPageState();
}

class _RequestAuthorizationPageState extends State<RequestAuthorizationPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedParcelId;
  String _selectedUserType = 'user'; // default to user
  final _authorizedUserIdController = TextEditingController();
  final _authorizedFirstNameController = TextEditingController();
  final _authorizedLastNameController = TextEditingController();
  final _authorizedPhoneController = TextEditingController();
  final _authorizedNationalNumberController = TextEditingController();
  final _authorizedAddressController = TextEditingController();
  final _authorizedBirthdayController = TextEditingController();
  int? _selectedCityIdForGuest;

  // Mock cities for now
  final List<Map<String, dynamic>> _cities = [
    {'id': 1, 'name': 'دمشق'},
    {'id': 2, 'name': 'حلب'},
    {'id': 3, 'name': 'حمص'},
    {'id': 4, 'name': 'اللاذقية'},
    {'id': 5, 'name': 'حماة'},
  ];

  @override
  void dispose() {
    _authorizedUserIdController.dispose();
    _authorizedFirstNameController.dispose();
    _authorizedLastNameController.dispose();
    _authorizedPhoneController.dispose();
    _authorizedNationalNumberController.dispose();
    _authorizedAddressController.dispose();
    _authorizedBirthdayController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedParcelId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار الطرد'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      context.read<AuthorizationsBloc>().add(
        CreateAuthorizationEvent(
          parcelId: _selectedParcelId!,
          authorizedUserType: _selectedUserType,
          authorizedUserId: _selectedUserType == 'user'
              ? int.tryParse(_authorizedUserIdController.text)
              : null,
          authorizedFirstName: _selectedUserType == 'guest'
              ? _authorizedFirstNameController.text
              : null,
          authorizedLastName: _selectedUserType == 'guest'
              ? _authorizedLastNameController.text
              : null,
          authorizedPhone: _selectedUserType == 'guest'
              ? _authorizedPhoneController.text
              : null,
          authorizedNationalNumber: _selectedUserType == 'guest'
              ? _authorizedNationalNumberController.text
              : null,
          authorizedAddress: _selectedUserType == 'guest'
              ? _authorizedAddressController.text
              : null,
          authorizedCityId: _selectedUserType == 'guest'
              ? _selectedCityIdForGuest
              : null,
          authorizedBirthday: _selectedUserType == 'guest'
              ? _authorizedBirthdayController.text
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('طلب تخويل جديد', style: AppTypography.heading3),
        centerTitle: true,
      ),
      body: BlocListener<AuthorizationsBloc, AuthorizationsState>(
        listener: (context, state) {
          if (state is AuthorizationActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.read<AuthorizationsBloc>().add(GetAuthorizationsEvent());
            Navigator.pop(context);
          } else if (state is AuthorizationsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('اختر الطرد', style: AppTypography.heading3),
                const SizedBox(height: AppDimensions.spacing2),
                BlocBuilder<ParcelsBloc, ParcelsState>(
                  builder: (context, state) {
                    if (state is ParcelsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ParcelsLoaded) {
                      return DropdownButtonFormField<int>(
                        initialValue: _selectedParcelId,
                        decoration: InputDecoration(
                          hintText: 'اختر الطرد المراد تخويله',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusMd,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: state.parcels.map((parcel) {
                          return DropdownMenuItem<int>(
                            value: parcel.id,
                            child: Text(
                              '${parcel.trackingNumber} - ${parcel.receiverName}',
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedParcelId = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'يرجى اختيار الطرد' : null,
                      );
                    }
                    return const Text('لا توجد طرود متاحة للتخويل');
                  },
                ),
                const SizedBox(height: AppDimensions.spacing6),
                const Text('نوع الشخص المخول', style: AppTypography.heading3),
                const SizedBox(height: AppDimensions.spacing2),
                DropdownButtonFormField<String>(
                  initialValue: _selectedUserType,
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
                  onChanged: (value) {
                    setState(() {
                      _selectedUserType = value!;
                    });
                  },
                ),
                if (_selectedUserType == 'user') ...[
                  const SizedBox(height: AppDimensions.spacing6),
                  const Text(
                    'معرف المستخدم المخول (ID)',
                    style: AppTypography.heading3,
                  ),
                  const SizedBox(height: AppDimensions.spacing2),
                  TextFormField(
                    controller: _authorizedUserIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'أدخل رقم معرف المستخدم',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) =>
                        (_selectedUserType == 'user' &&
                            (v == null || v.isEmpty))
                        ? 'يرجى إدخال معرف المستخدم'
                        : null,
                  ),
                ] else ...[
                  const SizedBox(height: AppDimensions.spacing6),
                  const Text(
                    'بيانات الضيف المخول',
                    style: AppTypography.heading3,
                  ),
                  const SizedBox(height: AppDimensions.spacing2),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _authorizedFirstNameController,
                          decoration: InputDecoration(
                            hintText: 'الاسم الأول',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (v) =>
                              (_selectedUserType == 'guest' &&
                                  (v == null || v.isEmpty))
                              ? 'يرجى إدخال الاسم الأول'
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spacing2),
                      Expanded(
                        child: TextFormField(
                          controller: _authorizedLastNameController,
                          decoration: InputDecoration(
                            hintText: 'الاسم الأخير',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusMd,
                              ),
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
                    controller: _authorizedPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'رقم هاتف الشخص المخول',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) {
                      if (_selectedUserType == 'guest') {
                        if (v == null || v.isEmpty)
                          return 'يرجى إدخال رقم الهاتف';
                        if (!RegExp(r'^\+?\d+$').hasMatch(v))
                          return 'رقم هاتف غير صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing3),
                  TextFormField(
                    controller: _authorizedNationalNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'الرقم الوطني للشخص المخول',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (v) {
                      if (_selectedUserType == 'guest') {
                        if (v == null || v.isEmpty)
                          return 'يرجى إدخال الرقم الوطني';
                        if (v.length != 11 ||
                            !RegExp(r'^\d{11}$').hasMatch(v)) {
                          return 'الرقم الوطني يجب أن يكون 11 رقم';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing3),
                  TextFormField(
                    controller: _authorizedAddressController,
                    decoration: InputDecoration(
                      hintText: 'عنوان الشخص المخول (اختياري)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing3),
                  DropdownButtonFormField<int>(
                    initialValue: _selectedCityIdForGuest,
                    decoration: InputDecoration(
                      hintText: 'المدينة (اختياري)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: _cities.map((city) {
                      return DropdownMenuItem<int>(
                        value: city['id'],
                        child: Text(city['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCityIdForGuest = value;
                      });
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing3),
                  TextFormField(
                    controller: _authorizedBirthdayController,
                    readOnly: true,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().subtract(
                          const Duration(days: 365 * 18),
                        ),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() {
                          _authorizedBirthdayController.text = picked
                              .toString()
                              .split(' ')
                              .first;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'تاريخ الميلاد (اختياري)',
                      suffixIcon: const Icon(Icons.calendar_today),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<AuthorizationsBloc, AuthorizationsState>(
                  builder: (context, state) {
                    return GradientButton(
                      text: 'إرسال الطلب',
                      onPressed: state is AuthorizationsLoading
                          ? () {}
                          : _submitForm,
                      isLoading: state is AuthorizationsLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
