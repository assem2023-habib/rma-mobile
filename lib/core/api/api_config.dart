class ApiConfig {
  static const String baseUrl =
      'https://api.rma-express.com/v1'; // Base URL placeholder
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String currentUser = '/me';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String verifyEmail = '/verify-email';
  static const String confirmEmailOtp = '/confirm-email-otp';
  static const String sendTelegramOtp = '/telegram/otp/send';
  static const String verifyTelegramOtp = '/telegram/otp/verify';
  static const String changePassword = '/change-password';

  static const String dashboardStats = '/dashboard/stats';
  static const String parcels = '/parcel';
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

  // General
  static const String general = '/general';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsConditions = '/terms-conditions';
  static const String aboutUs = '/about-us';
  static const String faq = '/faq';
  static const String contactUs = '/contact-us';
}
