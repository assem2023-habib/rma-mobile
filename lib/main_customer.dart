import 'package:flutter/material.dart';
import 'package:rma_customer/core/config/app_flavor_config.dart';
import 'package:rma_customer/injection_container.dart' as di;
import 'package:rma_customer/main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  AppConfig.init(
    appTitle: 'شحن سريع - زبائن',
    baseUrl: 'http://10.43.226.236:8000/api/v1',
    flavor: AppFlavor.customer,
  );

  await di.init();

  runApp(const MyApp());
}
