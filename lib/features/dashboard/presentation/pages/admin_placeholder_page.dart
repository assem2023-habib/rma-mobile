import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/backgrounds/shiny_background.dart';

class AdminPlaceholderPage extends StatelessWidget {
  final String title;

  const AdminPlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: AppTypography.heading3.copyWith(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: ShinyBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.construction, size: 100, color: Colors.white),
              const SizedBox(height: 24),
              Text(
                'قيد التطوير',
                style: AppTypography.heading1.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'هذه الصفحة ($title) ستكون متاحة قريباً',
                style: AppTypography.bodyLarge.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
