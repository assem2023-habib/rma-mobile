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

  @override
  void dispose() {
    _authorizedUserIdController.dispose();
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
          authorizedUserId: int.tryParse(_authorizedUserIdController.text),
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
                      hintText: 'أدخل رقم معرف المستخدم (اختياري)',
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
