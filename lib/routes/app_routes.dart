import 'package:flutter/material.dart';
import 'package:fsm_app/features/dashboard/screens/analytics_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/service_request/screens/service_request_list_screen.dart';
import '../features/service_request/screens/new_service_request_screen.dart';
import '../features/settings/screens/settings_screen.dart';

class AppRoutes {
  static const String initialRoute = '/login';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/new_service_request': (context) => NewServiceRequestScreen(),
      '/login': (context) => const LoginScreen(),
      '/register': (context) => const RegisterScreen(),
      '/dashboard': (context) => const DashboardScreen(),
      '/service_request': (context) => ServiceRequestListScreen(),
      '/analytics': (context) => AnalyticsScreen(),
      '/settings': (context) => SettingsScreen(),
    };
  }
}
