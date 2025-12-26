import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../../domain/entities/new_parcel.dart';
import '../bloc/new_parcel_bloc.dart';
import '../bloc/new_parcel_event.dart';
import '../bloc/new_parcel_state.dart';

class NewParcelPage extends StatefulWidget {
  const NewParcelPage({super.key});

  @override
  State<NewParcelPage> createState() => _NewParcelPageState();
}

class _NewParcelPageState extends State<NewParcelPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _receiverAddressController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  String _selectedParcelType = 'عادي';
  final List<String> _parcelTypes = [
    'عادي',
    'قابل للكسر',
    'وثائق',
    'سوائل',
    'إلكترونيات',
  ];

  @override
  void dispose() {
    _senderNameController.dispose();
    _senderPhoneController.dispose();
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _receiverAddressController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final parcel = NewParcel(
        senderName: _senderNameController.text,
        senderPhone: _senderPhoneController.text,
        receiverName: _receiverNameController.text,
        receiverPhone: _receiverPhoneController.text,
        receiverAddress: _receiverAddressController.text,
        parcelType: _selectedParcelType,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        note: _noteController.text,
      );

      context.read<NewParcelBloc>().add(CreateParcelEvent(parcel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طرد جديد', style: AppTypography.heading2),
      ),
      body: BlocListener<NewParcelBloc, NewParcelState>(
        listener: (context, state) {
          if (state is NewParcelSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إضافة الطرد بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is NewParcelError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.spacing4),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('بيانات المرسل'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _senderNameController,
                  label: 'اسم المرسل',
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم المرسل' : null,
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _senderPhoneController,
                  label: 'رقم هاتف المرسل',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                ),

                const SizedBox(height: AppDimensions.spacing6),
                _buildSectionTitle('بيانات المستلم'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverNameController,
                  label: 'اسم المستلم',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v!.isEmpty ? 'يرجى إدخال اسم المستلم' : null,
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverPhoneController,
                  label: 'رقم هاتف المستلم',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) => v!.isEmpty ? 'يرجى إدخال رقم الهاتف' : null,
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverAddressController,
                  label: 'عنوان المستلم',
                  icon: Icons.location_on_outlined,
                  validator: (v) => v!.isEmpty ? 'يرجى إدخال العنوان' : null,
                ),

                const SizedBox(height: AppDimensions.spacing6),
                _buildSectionTitle('تفاصيل الطرد'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildDropdownField(),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _weightController,
                  label: 'الوزن (كجم)',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'يرجى إدخال الوزن' : null,
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _noteController,
                  label: 'ملاحظات إضافية',
                  icon: Icons.note_outlined,
                  maxLines: 3,
                ),

                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<NewParcelBloc, NewParcelState>(
                  builder: (context, state) {
                    return GradientButton(
                      text: 'إرسال الطرد',
                      onPressed: _submitForm,
                      isLoading: state is NewParcelLoading,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.spacing8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTypography.heading3.copyWith(color: AppColors.primaryBlue),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedParcelType,
      decoration: InputDecoration(
        labelText: 'نوع الطرد',
        prefixIcon: const Icon(Icons.category_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        ),
      ),
      items: _parcelTypes.map((type) {
        return DropdownMenuItem(value: type, child: Text(type));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedParcelType = value!;
        });
      },
    );
  }
}
