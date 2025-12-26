import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../bloc/authorizations_bloc.dart';
import '../bloc/authorizations_event.dart';
import '../bloc/authorizations_state.dart';
import '../../domain/entities/authorization_entity.dart';

class RequestAuthorizationPage extends StatefulWidget {
  const RequestAuthorizationPage({super.key});

  @override
  State<RequestAuthorizationPage> createState() =>
      _RequestAuthorizationPageState();
}

class _RequestAuthorizationPageState extends State<RequestAuthorizationPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final auth = AuthorizationEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        status: 'قيد الانتظار',
        date: DateTime.now(),
      );
      context.read<AuthorizationsBloc>().add(RequestAuthorizationEvent(auth));
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
          if (state is AuthorizationRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إرسال طلب التخويل بنجاح'),
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
                const Text('نوع التخويل', style: AppTypography.heading3),
                const SizedBox(height: AppDimensions.spacing2),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'مثلاً: تخويل استلام طرد',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال عنوان التخويل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing6),
                const Text('تفاصيل التخويل', style: AppTypography.heading3),
                const SizedBox(height: AppDimensions.spacing2),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'اكتب هنا تفاصيل التخويل والأشخاص المعنيين...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال تفاصيل التخويل';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<AuthorizationsBloc, AuthorizationsState>(
                  builder: (context, state) {
                    return GradientButton(
                      text: 'إرسال الطلب',
                      onPressed: state is AuthorizationRequesting
                          ? () {}
                          : _submitForm,
                      isLoading: state is AuthorizationRequesting,
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
