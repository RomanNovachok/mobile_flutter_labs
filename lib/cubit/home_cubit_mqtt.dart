part of 'home_cubit.dart';

extension HomeCubitMqttX on HomeCubit {
  Future<void> restoreLastMqttPayload() async {
    final savedPayload = await _localStorageService.getLastMqttPayload();

    if (savedPayload == null) {
      return;
    }

    await applyPayload(
      savedPayload,
      persistPayload: false,
      fallbackEvent: 'Loaded the last known MQTT state from device storage.',
    );
  }

  void listenToMqttConnection() {
    _mqttConnectionSubscription = _mqttRepository.connectionStream.listen((
      isConnected,
    ) {
      if (isConnected) {
        emitState(
          state.copyWith(
            lastEvent: 'Connection restored. Waiting for the next '
                'live update from the machine.',
          ),
        );
        return;
      }

      if (
        state.hasInternet &&
        (_isConnectingMqtt || _isWaitingForFreshPayload)
      ) {
        showPersistentMqttIndicator(HomeMqttIndicator.connecting);
        emitState(
          state.copyWith(
            lastEvent: 'The broker connection dropped, trying to reconnect '
                'in the background.',
          ),
        );
      }
    });
  }

  Future<void> reconnectMqtt() async {
    await _mqttSubscription?.cancel();
    _mqttRepository.disconnect();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await connectToMqtt(forceReconnect: true);
  }

  Future<void> connectToMqtt({bool forceReconnect = false}) async {
    if (!state.hasInternet || _isConnectingMqtt) {
      return;
    }

    if (!forceReconnect && _mqttRepository.isConnected) {
      return;
    }

    _isConnectingMqtt = true;
    _isWaitingForFreshPayload = true;
    showPersistentMqttIndicator(HomeMqttIndicator.connecting);

    if (forceReconnect) {
      await _mqttSubscription?.cancel();
      _mqttRepository.disconnect();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    final isConnected = await _mqttRepository.connect();
    _isConnectingMqtt = false;
    if (!isConnected) {
      emitState(state.copyWith(
        lastEvent: 'The app could not reach the MQTT broker yet. '
            'It will try again when the network changes.',
        mqttIndicator: HomeMqttIndicator.connecting,
      ));
      return;
    }

    await _mqttRepository.subscribe(HomeCubit.mqttTopic);
    await _mqttSubscription?.cancel();
    _mqttSubscription = _mqttRepository.messagesStream.listen(applyPayload);
  }

  Future<void> applyPayload(
    String payload, {
    bool persistPayload = true,
    String? fallbackEvent,
  }) async {
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final flood = decoded['flood']?.toString() ?? state.floodStatus;
      final speed = decoded['speed']?.toString() ?? state.latheSpeed;
      emitState(state.copyWith(
        floodStatus: flood,
        latheSpeed: speed,
        lastEvent: fallbackEvent ?? buildPayloadEvent(flood, speed),
      ));

      final shouldResetConnectingState = persistPayload &&
          (_isWaitingForFreshPayload ||
              state.mqttIndicator == HomeMqttIndicator.connecting);
      if (shouldResetConnectingState) {
        _isWaitingForFreshPayload = false;
        showTransientMqttIndicator(HomeMqttIndicator.connected);
      }
      if (persistPayload) {
        await _localStorageService.saveLastMqttPayload(payload);
      }
    } catch (_) {
      emitState(state.copyWith(
        lastEvent: 'A message arrived from MQTT, but its format was invalid '
            'and was ignored.',
        notificationMessage: 'Invalid MQTT payload format.',
      ));
    }
  }

  String buildPayloadEvent(String flood, String speed) =>
      'Fresh data received: flood sensor is $flood, lathe speed is $speed%.';

  void showPersistentMqttIndicator(HomeMqttIndicator indicator) {
    _mqttStatusTimer?.cancel();
    emitState(state.copyWith(mqttIndicator: indicator));
  }

  void showTransientMqttIndicator(HomeMqttIndicator indicator) {
    showPersistentMqttIndicator(indicator);
    _mqttStatusTimer = Timer(const Duration(seconds: 1), clearMqttIndicator);
  }

  void clearMqttIndicator() {
    _mqttStatusTimer?.cancel();
    _mqttStatusTimer = null;
    emitState(state.copyWith(mqttIndicator: HomeMqttIndicator.none));
  }
}
