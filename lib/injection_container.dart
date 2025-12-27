import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rma_customer/core/api/dio_client.dart';
import 'package:rma_customer/core/network/network_info.dart';
import 'package:rma_customer/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:rma_customer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rma_customer/features/auth/domain/repositories/auth_repository.dart';
import 'package:rma_customer/features/auth/domain/usecases/confirm_email_otp_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/login_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/new_password_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/register_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/logout_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/send_telegram_otp_usecase.dart';
import 'package:rma_customer/features/auth/domain/usecases/verify_telegram_otp_usecase.dart';
import 'package:rma_customer/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rma_customer/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:rma_customer/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rma_customer/features/profile/domain/repositories/profile_repository.dart';
import 'package:rma_customer/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:rma_customer/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:rma_customer/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:rma_customer/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:rma_customer/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:rma_customer/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:rma_customer/features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'package:rma_customer/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:rma_customer/features/parcels/data/datasources/parcel_remote_datasource.dart';
import 'package:rma_customer/features/parcels/data/repositories/parcel_repository_impl.dart';
import 'package:rma_customer/features/parcels/domain/repositories/parcel_repository.dart';
import 'package:rma_customer/features/parcels/domain/usecases/get_parcels_usecase.dart';
import 'package:rma_customer/features/parcels/domain/usecases/get_parcel_by_id_usecase.dart';
import 'package:rma_customer/features/parcels/domain/usecases/create_parcel_usecase.dart'
    as parcel_create;
import 'package:rma_customer/features/parcels/domain/usecases/update_parcel_usecase.dart';
import 'package:rma_customer/features/parcels/domain/usecases/delete_parcel_usecase.dart';
import 'package:rma_customer/features/parcels/presentation/bloc/parcels_bloc.dart';
import 'package:rma_customer/features/routes/data/datasources/routes_remote_datasource.dart';
import 'package:rma_customer/features/routes/data/repositories/routes_repository_impl.dart';
import 'package:rma_customer/features/routes/domain/repositories/routes_repository.dart';
import 'package:rma_customer/features/routes/domain/usecases/get_routes_usecase.dart';
import 'package:rma_customer/features/routes/presentation/bloc/routes_bloc.dart';
import 'package:rma_customer/features/authorizations/data/datasources/authorizations_remote_datasource.dart';
import 'package:rma_customer/features/authorizations/data/repositories/authorizations_repository_impl.dart';
import 'package:rma_customer/features/authorizations/domain/repositories/authorizations_repository.dart';
import 'package:rma_customer/features/authorizations/domain/usecases/get_authorizations_usecase.dart';
import 'package:rma_customer/features/authorizations/domain/usecases/get_authorization_by_id_usecase.dart';
import 'package:rma_customer/features/authorizations/domain/usecases/create_authorization_usecase.dart';
import 'package:rma_customer/features/authorizations/domain/usecases/cancel_authorization_usecase.dart';
import 'package:rma_customer/features/authorizations/presentation/bloc/authorizations_bloc.dart';
import 'package:rma_customer/features/map/data/datasources/map_remote_datasource.dart';
import 'package:rma_customer/features/map/data/repositories/map_repository_impl.dart';
import 'package:rma_customer/features/map/domain/repositories/map_repository.dart';
import 'package:rma_customer/features/map/domain/usecases/get_parcel_location_usecase.dart';
import 'package:rma_customer/features/map/presentation/bloc/map_bloc.dart';
import 'package:rma_customer/features/rates/data/datasources/rating_remote_datasource.dart';
import 'package:rma_customer/features/rates/data/repositories/rating_repository_impl.dart';
import 'package:rma_customer/features/rates/domain/repositories/rating_repository.dart';
import 'package:rma_customer/features/rates/domain/usecases/create_rating_usecase.dart';
import 'package:rma_customer/features/rates/presentation/bloc/rating_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Dashboard
  // Bloc
  sl.registerFactory(() => DashboardBloc(getDashboardStatsUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));
  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );

  //! Features - Parcels
  // Bloc
  sl.registerFactory(
    () => ParcelsBloc(
      getParcelsUseCase: sl(),
      getParcelByIdUseCase: sl(),
      createParcelUseCase: sl(),
      updateParcelUseCase: sl(),
      deleteParcelUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetParcelsUseCase(sl()));
  sl.registerLazySingleton(() => GetParcelByIdUseCase(sl()));
  sl.registerLazySingleton(() => parcel_create.CreateParcelUseCase(sl()));
  sl.registerLazySingleton(() => UpdateParcelUseCase(sl()));
  sl.registerLazySingleton(() => DeleteParcelUseCase(sl()));
  // Repository
  sl.registerLazySingleton<ParcelRepository>(
    () => ParcelRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<ParcelRemoteDataSource>(
    () => ParcelRemoteDataSourceImpl(),
  );

  //! Features - Routes
  // Bloc
  sl.registerFactory(() => RoutesBloc(getRoutesUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetRoutesUseCase(sl()));
  // Repository
  sl.registerLazySingleton<RoutesRepository>(
    () => RoutesRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<RoutesRemoteDataSource>(
    () => RoutesRemoteDataSourceImpl(),
  );

  //! Features - Authorizations
  // Bloc
  sl.registerFactory(
    () => AuthorizationsBloc(
      getAuthorizationsUseCase: sl(),
      getAuthorizationByIdUseCase: sl(),
      createAuthorizationUseCase: sl(),
      cancelAuthorizationUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => GetAuthorizationsUseCase(sl()));
  sl.registerLazySingleton(() => GetAuthorizationByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateAuthorizationUseCase(sl()));
  sl.registerLazySingleton(() => CancelAuthorizationUseCase(sl()));
  // Repository
  sl.registerLazySingleton<AuthorizationsRepository>(
    () => AuthorizationsRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<AuthorizationsRemoteDataSource>(
    () => AuthorizationsRemoteDataSourceImpl(),
  );

  //! Features - Map
  // Bloc
  sl.registerFactory(() => MapBloc(getParcelLocationUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetParcelLocationUseCase(sl()));
  // Repository
  sl.registerLazySingleton<MapRepository>(
    () => MapRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<MapRemoteDataSource>(
    () => MapRemoteDataSourceImpl(),
  );

  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      forgotPasswordUseCase: sl(),
      newPasswordUseCase: sl(),
      verifyEmailUseCase: sl(),
      confirmEmailOtpUseCase: sl(),
      sendTelegramOtpUseCase: sl(),
      verifyTelegramOtpUseCase: sl(),
    ),
  );
  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => NewPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmEmailOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendTelegramOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyTelegramOtpUseCase(sl()));
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dioClient: sl()),
  );

  //! Features - Profile
  // Bloc
  sl.registerFactory(
    () => ProfileBloc(updateProfileUseCase: sl(), changePasswordUseCase: sl()),
  );
  // Use cases
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => ChangePasswordUseCase(sl()));
  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  //! Features - Rates
  // Bloc
  sl.registerFactory(() => RatingBloc(createRatingUseCase: sl()));
  // Use cases
  sl.registerLazySingleton(() => CreateRatingUseCase(sl()));
  // Repository
  sl.registerLazySingleton<RatingRepository>(
    () => RatingRepositoryImpl(remoteDataSource: sl()),
  );
  // Data sources
  sl.registerLazySingleton<RatingRemoteDataSource>(
    () => RatingRemoteDataSourceImpl(),
  );

  //! Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => DioClient(sl()));

  //! External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
