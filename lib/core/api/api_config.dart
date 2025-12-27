class ApiConfig {
  static const String baseUrl = 'https://api.rma-express.com/v1'; // Base URL placeholder
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String currentUser = '/user';
  static const String forgotPassword = '/forgot-password';
  static const String newPassword = '/new-password';
  static const String verifyEmail = '/verify-email';
  static const String confirmEmailOtp = '/confirm-email-otp';
  static const String sendTelegramOtp = '/telegram/otp/send';
  static const String verifyTelegramOtp = '/telegram/otp/verify';
  
  static const String dashboardStats = '/dashboard/stats';
  static const String parcels = '/parcels';
  static const String authorizations = '/authorizations';
}
