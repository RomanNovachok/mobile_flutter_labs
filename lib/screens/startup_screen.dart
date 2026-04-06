import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/data/repositories/remote_auth_repository.dart';
import 'package:mobile_flutter_lab1/data/services/auth_api_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  final _authRepository = RemoteAuthRepository(
    AuthApiService(),
    LocalStorageService(),
  );

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = await _authRepository.getCurrentUser();

    if (!mounted) {
      return;
    }

    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
