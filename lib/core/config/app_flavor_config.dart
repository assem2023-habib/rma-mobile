enum AppFlavor { customer, dashboard }

class AppConfig {
  final String appTitle;
  final String baseUrl;
  final AppFlavor flavor;

  AppConfig({
    required this.appTitle,
    required this.baseUrl,
    required this.flavor,
  });

  static AppConfig? _instance;

  static void init({
    required String appTitle,
    required String baseUrl,
    required AppFlavor flavor,
  }) {
    _instance = AppConfig(
      appTitle: appTitle,
      baseUrl: baseUrl,
      flavor: flavor,
    );
  }

  static AppConfig get instance {
    if (_instance == null) {
      throw Exception('AppConfig must be initialized with AppConfig.init()');
    }
    return _instance!;
  }

  bool get isCustomer => flavor == AppFlavor.customer;
  bool get isDashboard => flavor == AppFlavor.dashboard;
}
