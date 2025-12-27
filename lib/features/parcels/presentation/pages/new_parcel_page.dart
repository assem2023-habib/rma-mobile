import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../bloc/parcels_bloc.dart';
import '../bloc/parcels_event.dart';
import '../bloc/parcels_state.dart';
import '../../../routes/presentation/bloc/routes_bloc.dart';
import '../../../routes/presentation/bloc/routes_state.dart';

class NewParcelPage extends StatefulWidget {
  const NewParcelPage({super.key});

  @override
  State<NewParcelPage> createState() => _NewParcelPageState();
}

class _NewParcelPageState extends State<NewParcelPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _receiverAddressController = TextEditingController();
  final _weightController = TextEditingController();
  final _noteController = TextEditingController();

  int? _selectedRouteId;

  @override
  void dispose() {
    _receiverNameController.dispose();
    _receiverPhoneController.dispose();
    _receiverAddressController.dispose();
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRouteId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('يرجى اختيار المسار'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      context.read<ParcelsBloc>().add(
        CreateParcelEvent(
          routeId: _selectedRouteId!,
          receiverName: _receiverNameController.text,
          receiverAddress: _receiverAddressController.text,
          receiverPhone: _receiverPhoneController.text,
          weight: double.tryParse(_weightController.text) ?? 0.0,
          isPaid: _isPaid,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة طرد جديد', style: AppTypography.heading2),
      ),
      body: BlocListener<ParcelsBloc, ParcelsState>(
        listener: (context, state) {
          if (state is ParcelActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is ParcelsError) {
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
                _buildSectionTitle('بيانات المسار'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildRoutesDropdown(),

                const SizedBox(height: AppDimensions.spacing6),
                _buildSectionTitle('بيانات المستلم'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverNameController,
                  label: 'اسم المستلم',
                  icon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'اسم المستلم مطلوب';
                    if (v.length < 2)
                      return 'الاسم قصير جداً (حرفين على الأقل)';
                    if (v.length > 250) return 'الاسم طويل جداً';
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverPhoneController,
                  label: 'رقم هاتف المستلم',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'رقم الهاتف مطلوب';
                    if (v.length < 6) return 'رقم الهاتف قصير جداً';
                    if (v.length > 20) return 'رقم الهاتف طويل جداً';
                    if (!RegExp(r'^\+?\d+$').hasMatch(v))
                      return 'رقم هاتف غير صحيح';
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _receiverAddressController,
                  label: 'عنوان المستلم',
                  icon: Icons.location_on_outlined,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'العنوان مطلوب';
                    if (v.length > 500) return 'العنوان طويل جداً';
                    return null;
                  },
                ),

                const SizedBox(height: AppDimensions.spacing6),
                _buildSectionTitle('تفاصيل الطرد'),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _weightController,
                  label: 'الوزن (كجم)',
                  icon: Icons.monitor_weight_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'الوزن مطلوب';
                    final weight = double.tryParse(v);
                    if (weight == null) return 'الوزن يجب أن يكون رقماً';
                    if (weight < 0.1)
                      return 'الوزن يجب أن يكون 0.1 كجم على الأقل';
                    return null;
                  },
                ),
                const SizedBox(height: AppDimensions.spacing3),
                SwitchListTile(
                  title: const Text('هل تم الدفع مسبقاً؟'),
                  value: _isPaid,
                  onChanged: (value) {
                    setState(() {
                      _isPaid = value;
                    });
                  },
                  secondary: const Icon(Icons.payment_outlined),
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: AppDimensions.spacing3),
                _buildTextField(
                  controller: _noteController,
                  label: 'ملاحظات إضافية',
                  icon: Icons.note_outlined,
                  maxLines: 3,
                ),

                const SizedBox(height: AppDimensions.spacing8),
                BlocBuilder<ParcelsBloc, ParcelsState>(
                  builder: (context, state) {
                    return GradientButton(
                      text: 'إرسال الطرد',
                      onPressed: _submitForm,
                      isLoading: state is ParcelsLoading,
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

  Widget _buildRoutesDropdown() {
    return BlocBuilder<RoutesBloc, RoutesState>(
      builder: (context, state) {
        if (state is RoutesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RoutesLoaded) {
          return DropdownButtonFormField<int>(
            initialValue: _selectedRouteId,
            decoration: InputDecoration(
              labelText: 'اختر المسار',
              prefixIcon: const Icon(Icons.route_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              ),
            ),
            items: state.routes.map((route) {
              return DropdownMenuItem<int>(
                value: route.id,
                child: Text('${route.fromCity} -> ${route.toCity}'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRouteId = value;
              });
            },
            validator: (value) => value == null ? 'يرجى اختيار المسار' : null,
          );
        } else if (state is RoutesError) {
          return Text('خطأ في تحميل المسارات: ${state.message}');
        }
        return const Text('لا توجد مسارات متاحة');
      },
    );
  }
}
