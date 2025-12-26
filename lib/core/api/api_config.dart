class ApiConfig {
  static const String baseUrl = 'https://api.rma-express.com/v1'; // Base URL placeholder
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String parcels = '/parcels';
  static const String authorizations = '/authorizations';
}
