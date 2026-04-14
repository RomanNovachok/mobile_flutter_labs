import 'package:mobile_flutter_lab1/data/repositories/mqtt_repository_impl.dart';
import 'package:mobile_flutter_lab1/data/repositories/remote_auth_repository.dart';
import 'package:mobile_flutter_lab1/data/repositories/workshop_repository_impl.dart';
import 'package:mobile_flutter_lab1/data/services/auth_api_service.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/data/services/mqtt_service.dart';
import 'package:mobile_flutter_lab1/data/services/workshop_api_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/mqtt_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

class AppDependencies {
  AppDependencies._();

  static final AppDependencies instance = AppDependencies._();

  final localStorageService = LocalStorageService();
  final connectivityService = ConnectivityService();
  final authApiService = AuthApiService();
  final workshopApiService = WorkshopApiService();
  final mqttService = MqttService();

  late final AuthRepository authRepository = RemoteAuthRepository(
    authApiService,
    localStorageService,
  );
  late final WorkshopRepository workshopRepository = WorkshopRepositoryImpl(
    workshopApiService,
    localStorageService,
  );
  late final MqttRepository mqttRepository = MqttRepositoryImpl(mqttService);
}
