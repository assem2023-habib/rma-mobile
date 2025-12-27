import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _chatIdController = TextEditingController();
  bool _isTelegram = false;

  @override
  void dispose() {
    _emailController.dispose();
    _chatIdController.dispose();
    super.dispose();
  }

  void _onForgotPassword() {
    if (_formKey.currentState!.validate()) {
      if (_isTelegram) {
        context.read<AuthBloc>().add(
          SendTelegramOtpRequested(chatId: int.parse(_chatIdController.text)),
        );
      } else {
        context.read<AuthBloc>().add(
          ForgotPasswordRequested(email: _emailController.text),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نسيت كلمة المرور')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.push(
              '/verify-otp',
              extra: {'email': _emailController.text, 'isTelegram': false},
            );
          } else if (state is TelegramOtpSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.push(
              '/verify-otp',
              extra: {'email': _chatIdController.text, 'isTelegram': true},
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppDimensions.spacing8),
                const Text(
                  'اختر طريقة استعادة كلمة المرور',
                  style: AppTypography.heading3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('البريد الإلكتروني'),
                        selected: !_isTelegram,
                        onSelected: (selected) {
                          if (selected) setState(() => _isTelegram = false);
                        },
                      ),
                    ),
                    const SizedBox(width: AppDimensions.spacing4),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('تيليجرام'),
                        selected: _isTelegram,
                        onSelected: (selected) {
                          if (selected) setState(() => _isTelegram = true);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.spacing8),
                if (!_isTelegram)
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (!_isTelegram) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                      }
                      return null;
                    },
                  )
                else
                  TextFormField(
                    controller: _chatIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'معرف الدردشة في تيليجرام (Chat ID)',
                      prefixIcon: const Icon(Icons.send),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMd,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_isTelegram) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال معرف الدردشة';
                        }
                        if (int.tryParse(value) == null) {
                          return 'يجب أن يكون المعرف رقماً';
                        }
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GradientButton(
                      onPressed: _onForgotPassword,
                      text: 'إرسال الرمز',
                      isLoading: state is AuthLoading,
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
