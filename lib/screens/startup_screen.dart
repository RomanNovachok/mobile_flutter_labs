import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<String> _resolveRoute(BuildContext context) async {
    final user = await context.read<AuthRepository>().getCurrentUser();
    return user != null ? AppRoutes.home : AppRoutes.login;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _resolveRoute(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final targetRoute = snapshot.data ?? AppRoutes.login;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, targetRoute);
        });

        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
