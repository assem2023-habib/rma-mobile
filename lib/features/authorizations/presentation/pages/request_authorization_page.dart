import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';
import '../../../../core/widgets/headers/custom_app_header.dart';
import '../../../../core/widgets/buttons/gradient_button.dart';
import '../bloc/authorizations_bloc.dart';
import '../bloc/authorizations_event.dart';
import '../bloc/authorizations_state.dart';
import 'package:rma_customer/features/users/presentation/bloc/users_bloc.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_bloc.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_event.dart';
import 'package:rma_customer/features/common/presentation/bloc/common_state.dart';
import 'package:rma_customer/injection_container.dart';

import '../widgets/parcel_selection_field.dart';
import '../widgets/user_type_selector.dart';
import '../widgets/registered_user_search.dart';
import '../widgets/guest_info_form.dart';

class RequestAuthorizationPage extends StatefulWidget {
  final int? parcelId;

  const RequestAuthorizationPage({super.key, this.parcelId});

  @override
  State<RequestAuthorizationPage> createState() =>
      _RequestAuthorizationPageState();
}

class _RequestAuthorizationPageState extends State<RequestAuthorizationPage> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedParcelId;
  String _selectedUserType = 'user';
  final _userSearchController = TextEditingController();
  final _authorizedUserIdController = TextEditingController();
  final _authorizedFirstNameController = TextEditingController();
  final _authorizedLastNameController = TextEditingController();
  final _authorizedPhoneController = TextEditingController();
  final _authorizedNationalNumberController = TextEditingController();
  final _authorizedAddressController = TextEditingController();
  final _authorizedBirthdayController = TextEditingController();
  int? _selectedCountryIdForGuest;
  int? _selectedCityIdForGuest;
  Timer? _debounce;

  List<dynamic> _countries = [];
  List<dynamic> _cities = [];

  @override
  void initState() {
    super.initState();
    _selectedParcelId = widget.parcelId;
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _authorizedUserIdController.dispose();
    _authorizedFirstNameController.dispose();
    _authorizedLastNameController.dispose();
    _authorizedPhoneController.dispose();
    _authorizedNationalNumberController.dispose();
    _authorizedAddressController.dispose();
    _authorizedBirthdayController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        context.read<UsersBloc>().add(SearchUsersEvent(query));
      }
    });
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
      appBar: const CustomAppHeader(title: 'طلب تخويل جديد'),
      body: ShinyBackground(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<UsersBloc>()),
            BlocProvider(
              create: (context) =>
                  sl<CommonBloc>()..add(GetCountriesRequested()),
            ),
          ],
          child: BlocListener<AuthorizationsBloc, AuthorizationsState>(
            listener: (context, state) {
              if (state is AuthorizationActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.read<AuthorizationsBloc>().add(
                  GetAuthorizationsEvent(),
                );
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
            child: BlocListener<CommonBloc, CommonState>(
              listener: (context, state) {
                if (state is CountriesLoaded) {
                  setState(() {
                    _countries = state.countries;
                  });
                } else if (state is CitiesLoaded) {
                  setState(() {
                    _cities = state.cities;
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
              child: BlocBuilder<CommonBloc, CommonState>(
                builder: (context, commonState) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(AppDimensions.spacing6),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'اختر الطرد',
                            style: AppTypography.heading3,
                          ),
                          const SizedBox(height: AppDimensions.spacing2),
                          ParcelSelectionField(
                            selectedParcelId: _selectedParcelId,
                            onChanged: (value) {
                              setState(() {
                                _selectedParcelId = value;
                              });
                            },
                          ),
                          const SizedBox(height: AppDimensions.spacing6),
                          UserTypeSelector(
                            selectedUserType: _selectedUserType,
                            onChanged: (value) {
                              setState(() {
                                _selectedUserType = value!;
                              });
                            },
                          ),
                          if (_selectedUserType == 'user')
                            RegisteredUserSearch(
                              searchController: _userSearchController,
                              userIdController: _authorizedUserIdController,
                              onSearchChanged: _onSearchChanged,
                              onUserSelected: () => setState(() {}),
                            )
                          else
                            GuestInfoForm(
                              firstNameController:
                                  _authorizedFirstNameController,
                              lastNameController: _authorizedLastNameController,
                              phoneController: _authorizedPhoneController,
                              nationalNumberController:
                                  _authorizedNationalNumberController,
                              addressController: _authorizedAddressController,
                              birthdayController: _authorizedBirthdayController,
                              selectedCountryId: _selectedCountryIdForGuest,
                              selectedCityId: _selectedCityIdForGuest,
                              countries: _countries,
                              cities: _cities,
                              isLoadingCountries:
                                  commonState is CommonLoading &&
                                  _countries.isEmpty,
                              isLoadingCities:
                                  commonState is CommonLoading &&
                                  _selectedCountryIdForGuest != null,
                              onCountryChanged: (value) {
                                setState(() {
                                  _selectedCountryIdForGuest = value;
                                  _selectedCityIdForGuest = null;
                                  _cities = [];
                                });
                                if (value != null) {
                                  context.read<CommonBloc>().add(
                                    GetCitiesRequested(value),
                                  );
                                }
                              },
                              onCityChanged: (value) {
                                setState(() {
                                  _selectedCityIdForGuest = value;
                                });
                              },
                            ),
                          const SizedBox(height: AppDimensions.spacing8),
                          BlocBuilder<AuthorizationsBloc, AuthorizationsState>(
                            builder: (context, state) {
                              return GradientButton(
                                text: 'إرسال الطلب',
                                onPressed: _submitForm,
                                isLoading: state is AuthorizationsLoading,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
