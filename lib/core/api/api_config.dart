import '../config/app_flavor_config.dart';

class ApiConfig {
  static String get baseUrl => AppConfig.instance.baseUrl;

  // Reverb/Pusher Configuration
  static const String pusherAppKey = 'z8gmvgvmclvhoezjsfil';
  static const String pusherHost = '10.43.226.236';
  static const int pusherPort = 6001;
  static const String pusherCluster = 'mt1';
  static const String pusherAuthUrl =
      'http://10.43.226.236:8000/api/broadcasting/auth';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Passport Client credentials
  static const String passportClientId = '01980742-84ea-7291-aed5-d9297263b3be';
  static const String passportClientSecret =
      'GPGlGNKDO9QS3enM10DC99hPTiftmJyhhmJQNgQ1';

  // Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String updateProfile = '/update-profile';
  static const String currentUser = '/me';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String verifyEmail = '/verify-email';
  static const String confirmEmailOtp = '/confirm-email-otp';
  static const String sendTelegramOtp = '/telegram/otp/send';
  static const String verifyTelegramOtp = '/telegram/otp/verify';
  static const String changePassword = '/change-password';

  static const String dashboardStats = '/statistics';

  // Admin Endpoints
  static const String adminBranch = '/admin/my-branch';
  static const String adminParcels = '/admin/parcels';
  static const String adminAppointments = '/admin/appointments';
  static const String adminShipments = '/admin/shipments';
  static const String adminTrucks = '/admin/trucks';

  // Super Admin Endpoints
  static const String superAdminStats = '/super-admin/stats';
  static const String superAdminBranches = '/super-admin/branches';
  static const String superAdminEmployees = '/super-admin/employees';
  static const String superAdminAllParcels = '/super-admin/all-parcels';

  static const String parcels = '/parcel';
  static const String returnedParcels = '/parcel/returned';
  static const String users = '/users';
  static const String searchUsers = '/users/search';
  static const String authorizations = '/authorization';
  static const String rates = '/rates';
  static const String routes = '/routes';
  static const String pricingPolicy = '/pricing-policy';
  static const String parcelLocation = '/parcel'; // /{id}/location
  static const String countries = '/countries';
  static const String cities = '/cities'; // /countries/{id}/cities
  static const String branches = '/branches';
  static const String appointments = '/get-getCalender'; // /{tracking_number}
  static const String bookAppointment = '/book-appointment';

  // Notifications
  static const String notifications = '/notifications';

  // General
  static const String general = '/general';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String aboutUs = '/about-us';
  static const String faq = '/faq';
  static const String contactUs = '/contact-us';
}
