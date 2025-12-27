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

class VerifyOtpPage extends StatefulWidget {
  final String email;
  final bool isTelegram;

  const VerifyOtpPage({
    super.key,
    required this.email,
    this.isTelegram = false,
  });

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState!.validate()) {
      if (widget.isTelegram) {
        context.read<AuthBloc>().add(
          VerifyTelegramOtpRequested(
            chatId: int.tryParse(widget.email) ?? 0,
            otp: _otpController.text,
          ),
        );
      } else {
        // For email OTP verification, navigate to reset password
        context.push(
          '/reset-password',
          extra: {'email': widget.email, 'otp': _otpController.text},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحقق من الرمز')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is TelegramOtpVerified) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/dashboard');
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
                Text(
                  'أدخل الرمز المكون من 6 أرقام المرسل إلى ${widget.isTelegram ? 'تيليجرام' : 'بريدك الإلكتروني'}',
                  style: AppTypography.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.email,
                  style: AppTypography.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spacing8),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 8),
                  maxLength: 6,
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال الرمز';
                    }
                    if (value.length != 6) {
                      return 'الرمز يجب أن يكون 6 أرقام';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return GradientButton(
                      onPressed: _onVerify,
                      text: 'تحقق',
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
