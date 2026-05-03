import 'package:flutter/material.dart';
import 'package:rma_customer/core/config/app_flavor_config.dart';
import 'package:rma_customer/injection_container.dart' as di;
import 'package:rma_customer/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.init(
    appTitle: 'لوحة تحكم RMA',
    baseUrl: 'http://10.246.59.236:8000/api/v1',
    flavor: AppFlavor.dashboard,
    useMockData: false,
  );

  await di.init();

  runApp(const MyApp());
}
