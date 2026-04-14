import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/di/app_dependencies.dart';
import 'package:mobile_flutter_lab1/cubit/home_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/login_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/machine_events_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/profile_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/register_cubit.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/mqtt_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/screens/home_screen.dart';
import 'package:mobile_flutter_lab1/screens/login_screen.dart';
import 'package:mobile_flutter_lab1/screens/profile_screen.dart';
import 'package:mobile_flutter_lab1/screens/register_screen.dart';
import 'package:mobile_flutter_lab1/screens/startup_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.instance;

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalStorageService>.value(
          value: dependencies.localStorageService,
        ),
        RepositoryProvider<ConnectivityService>.value(
          value: dependencies.connectivityService,
        ),
        RepositoryProvider<AuthRepository>.value(
          value: dependencies.authRepository,
        ),
        RepositoryProvider<WorkshopRepository>.value(
          value: dependencies.workshopRepository,
        ),
        RepositoryProvider<MqttRepository>.value(
          value: dependencies.mqttRepository,
        ),
      ],
      child: MaterialApp(
        title: 'LatheGuard IoT',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.startup,
        routes: {
          AppRoutes.startup: (context) => const StartupScreen(),
          AppRoutes.login: (context) => BlocProvider(
            create: (context) => LoginCubit(
              context.read<AuthRepository>(),
              context.read<ConnectivityService>(),
            ),
            child: const LoginScreen(),
          ),
          AppRoutes.register: (context) => BlocProvider(
            create: (context) => RegisterCubit(
              context.read<AuthRepository>(),
              context.read<ConnectivityService>(),
            ),
            child: const RegisterScreen(),
          ),
          AppRoutes.home: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeCubit(
                  context.read<AuthRepository>(),
                  context.read<WorkshopRepository>(),
                  context.read<ConnectivityService>(),
                  context.read<LocalStorageService>(),
                  context.read<MqttRepository>(),
                )..initialize(),
              ),
              BlocProvider(
                create: (context) => MachineEventsCubit(
                  context.read<WorkshopRepository>(),
                )..loadEvents(hasInternet: true),
              ),
            ],
            child: const HomeScreen(),
          ),
          AppRoutes.profile: (context) => BlocProvider(
            create: (context) => ProfileCubit(
              context.read<AuthRepository>(),
              context.read<WorkshopRepository>(),
              context.read<ConnectivityService>(),
            )..loadProfile(),
            child: const ProfileScreen(),
          ),
        },
      ),
    );
  }
}
