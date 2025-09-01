import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme_data.dart'; 
import 'core/services/auth_service.dart';  
import 'core/services/firestore_service.dart';  
import 'main_navigation.dart';  // Import the bottom navigation widget

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: MaterialApp(
        title: 'FSM Mobile App',
        theme: AppThemeData.lightTheme,
        routes: AppRoutes.getRoutes(),
        initialRoute: AppRoutes.initialRoute,
        home: MainNavigation(),  // Use the MainNavigation with bottom navigation bar
      ),
    );
  }
}
