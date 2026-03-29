import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'core/routes.dart';
import 'core/theme_provider.dart';

import 'ui/splash/splash_screen.dart';
import 'ui/dashboard/dashboard_screen.dart';

class DeepCloakApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const DeepCloakApp({
    super.key,
    required this.themeProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'DeepCloak', // Rebranded

          themeMode: provider.themeMode,
          theme: CyberTheme.lightTheme,
          darkTheme: CyberTheme.darkTheme,

          initialRoute: AppRoutes.splash,

          routes: {
            AppRoutes.splash: (_) => const SplashScreen(),
            AppRoutes.dashboard: (_) => const DashboardScreen(),
          },
        );
      },
    );
  }
}