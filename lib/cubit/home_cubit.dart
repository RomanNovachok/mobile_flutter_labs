import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/cubit/home_state.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/mqtt_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

part 'home_cubit_session.dart';
part 'home_cubit_mqtt.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._authRepository,
    this._workshopRepository,
    this._connectivityService,
    this._localStorageService,
    this._mqttRepository,
  ) : super(const HomeState());

  static const mqttTopic = 'latheguard/status';

  final AuthRepository _authRepository;
  final WorkshopRepository _workshopRepository;
  final ConnectivityService _connectivityService;
  final LocalStorageService _localStorageService;
  final MqttRepository _mqttRepository;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<String>? _mqttSubscription;
  StreamSubscription<bool>? _mqttConnectionSubscription;
  Timer? _mqttStatusTimer;
  bool _isConnectingMqtt = false;
  bool _isWaitingForFreshPayload = false;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }

    _isInitialized = true;
    await restoreLastMqttPayload();
    await loadUser();
    listenToInternet();
    listenToMqttConnection();
    await checkInternet();
    await connectToMqtt();
  }

  void emitState(HomeState value) => emit(value);

  void clearNotification() {
    emit(state.copyWith(clearNotification: true));
  }

  @override
  Future<void> close() async {
    await _connectivitySubscription?.cancel();
    await _mqttSubscription?.cancel();
    await _mqttConnectionSubscription?.cancel();
    _mqttStatusTimer?.cancel();
    _mqttRepository.disconnect();
    return super.close();
  }
}
