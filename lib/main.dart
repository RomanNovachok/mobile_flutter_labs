import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/screens/home_screen.dart';
import 'package:mobile_flutter_lab1/screens/login_screen.dart';
import 'package:mobile_flutter_lab1/screens/profile_screen.dart';
import 'package:mobile_flutter_lab1/screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Factory App',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}
