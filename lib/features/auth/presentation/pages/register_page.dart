import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rma_customer/core/theme/app_colors.dart';
import 'package:rma_customer/core/widgets/backgrounds/shiny_background.dart';
import 'package:rma_customer/core/widgets/headers/custom_app_header.dart';
import 'package:rma_customer/core/widgets/buttons/gradient_button.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_event.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_state.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_bloc.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_event.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_state.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rma_customer/injection_container.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<CommonBloc>()..add(GetCountriesRequested()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _nationalNumberController = TextEditingController();
  final _birthdayController = TextEditingController();
  int? _selectedCountryId;
  int? _selectedCityId;
  final _formKey = GlobalKey<FormState>();

  List<dynamic> _countries = [];
  List<dynamic> _cities = [];

  @override
  void initState() {
    super.initState();
    // Initial data is already triggered in BlocProvider
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _nationalNumberController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text = picked.toIso8601String().split('T')[0];
      });
    }
  }

  void _showOtpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('التحقق من رقم الهاتف', textAlign: TextAlign.center),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'أدخل الرمز المرسل إلى ${_phoneController.text}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: AppColors.slate600),
            ),
            const SizedBox(height: 24),
            PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 50,
                fieldWidth: 40,
                activeFillColor: Colors.white,
                inactiveFillColor: AppColors.slate50,
                selectedFillColor: Colors.white,
                activeColor: AppColors.primaryBlue,
                inactiveColor: AppColors.slate300,
                selectedColor: AppColors.primaryBlue,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                // Here we would call the verification logic
                Navigator.pop(context);
                _performRegistration();
              },
              onChanged: (value) {},
            ),
            TextButton(
              onPressed: () {
                // Resend OTP logic
              },
              child: const Text('إعادة إرسال الرمز'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _performRegistration() {
    context.read<AuthBloc>().add(
      RegisterRequested(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text,
        birthday: _birthdayController.text,
        cityId: _selectedCityId!,
        nationalNumber: _nationalNumberController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppHeader(title: 'إنشاء حساب جديد'),
      body: ShinyBackground(
        child: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Authenticated || state is GuestAuthenticated) {
                  context.go('/');
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
            BlocListener<CommonBloc, CommonState>(
              listener: (context, state) {
                if (state is CountriesLoaded) {
                  setState(() {
                    _countries = state.countries;
                  });
                } else if (state is CitiesLoaded) {
                  setState(() {
                    _cities = state.cities;
                    _selectedCityId = null; // Reset city when country changes
                  });
                } else if (state is CommonError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<CommonBloc, CommonState>(
            builder: (context, commonState) {
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'إنشاء حساب جديد',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'انضم إلينا وابدأ بتتبع شحناتك بسهولة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.slate600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  labelText: 'الاسم الأول',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم الأول مطلوب';
                                  }
                                  if (value.length > 255) {
                                    return 'الاسم طويل جداً';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  labelText: 'الاسم الأخير',
                                  prefixIcon: const Icon(Icons.person_outline),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الاسم الأخير مطلوب';
                                  }
                                  if (value.length > 255) {
                                    return 'الاسم طويل جداً';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'البريد الإلكتروني',
                            prefixIcon: const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'البريد الإلكتروني مطلوب';
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            ).hasMatch(value)) {
                              return 'بريد إلكتروني غير صحيح';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        IntlPhoneField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'رقم الهاتف',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: '',
                          ),
                          initialCountryCode: 'SY',
                          languageCode: 'ar',
                          textAlign: TextAlign.left,
                          onChanged: (phone) {
                            // You can access phone.completeNumber
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _nationalNumberController,
                          decoration: InputDecoration(
                            labelText: 'الرقم الوطني',
                            prefixIcon: const Icon(Icons.badge_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرقم الوطني مطلوب';
                            }
                            if (value.length != 11 ||
                                !RegExp(r'^\d{11}$').hasMatch(value)) {
                              return 'الرقم الوطني يجب أن يكون 11 رقم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _birthdayController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'تاريخ الميلاد',
                            prefixIcon: const Icon(
                              Icons.calendar_today_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'تاريخ الميلاد مطلوب';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedCountryId,
                          decoration: InputDecoration(
                            labelText: 'الدولة',
                            prefixIcon: const Icon(Icons.public_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon:
                                commonState is CommonLoading &&
                                    _countries.isEmpty
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          items: _countries.map((country) {
                            return DropdownMenuItem<int>(
                              value: country['id'],
                              child: Text(country['ar_name'] ?? country['en_name'] ?? 'بدون اسم'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCountryId = value;
                            });
                            if (value != null) {
                              context.read<CommonBloc>().add(
                                GetCitiesRequested(value),
                              );
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'يرجى اختيار الدولة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<int>(
                          initialValue: _selectedCityId,
                          decoration: InputDecoration(
                            labelText: 'المدينة',
                            prefixIcon: const Icon(
                              Icons.location_city_outlined,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon:
                                commonState is CommonLoading &&
                                    _selectedCountryId != null
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          items: _cities.map((city) {
                            return DropdownMenuItem<int>(
                              value: city['id'],
                              child: Text(city['ar_name'] ?? city['en_name'] ?? 'بدون اسم'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCityId = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'يرجى اختيار المدينة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'كلمة المرور مطلوبة';
                            }
                            if (value.length < 8) {
                              return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordConfirmationController,
                          decoration: InputDecoration(
                            labelText: 'تأكيد كلمة المرور',
                            prefixIcon: const Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى تأكيد كلمة المرور';
                            }
                            if (value != _passwordController.text) {
                              return 'كلمة المرور غير متطابقة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return GradientButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (_selectedCityId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('يرجى اختيار المدينة')),
                                    );
                                    return;
                                  }
                                  // _showOtpDialog(); // Disabled for now
                                  _performRegistration();
                                }
                              },
                              text: 'إنشاء الحساب',
                              isLoading: state is AuthLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('لديك حساب بالفعل؟'),
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
