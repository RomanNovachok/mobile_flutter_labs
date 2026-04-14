import 'dart:async';

import 'package:mobile_flutter_lab1/data/services/mqtt_service_base.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService implements MqttServiceBase {
  MqttService() : this._(_buildClientId());
  MqttService._(this._clientId)
      : _client = MqttBrowserClient.withPort(
          'wss://broker.hivemq.com/mqtt',
          _clientId,
          8884,
        ) {
    _configureClient();
    _client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
  }

  static String _buildClientId() =>
      'flutter_web_${DateTime.now().millisecondsSinceEpoch}';
  final String _clientId;
  final MqttBrowserClient _client;
  final StreamController<String> _messagesController =
      StreamController<String>.broadcast();
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  final Set<String> _subscribedTopics = <String>{};

  StreamSubscription<List<MqttReceivedMessage<MqttMessage>>>?
      _updatesSubscription;
  bool _isDisposed = false;
  @override
  Stream<String> get messagesStream => _messagesController.stream;
  @override
  Stream<bool> get connectionStream => _connectionController.stream;
  @override
  bool get isConnected =>
      _client.connectionStatus?.state == MqttConnectionState.connected;

  void _configureClient() {
    _client.logging(on: false);
    _client.setProtocolV311();
    _client.keepAlivePeriod = 20;
    _client.connectTimeoutPeriod = 5000;
    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;
    _client.onConnected = _handleConnected;
    _client.onDisconnected = _handleDisconnected;
    _client.onAutoReconnect = _handleAutoReconnect;
    _client.onAutoReconnected = _handleAutoReconnected;
  }

  void _handleConnected() => _emitConnectionState(true);
  void _handleDisconnected() => _emitConnectionState(false);
  void _handleAutoReconnect() => _emitConnectionState(false);

  void _handleAutoReconnected() {
    _emitConnectionState(true);
    _resubscribeToTopics();
  }

  void _emitConnectionState(bool isConnected) {
    if (_isDisposed || _connectionController.isClosed) {
      return;
    }
    _connectionController.add(isConnected);
  }

  void _bindUpdatesListener() {
    _updatesSubscription?.cancel();
    _updatesSubscription = _client.updates?.listen((messages) {
      for (final receivedMessage in messages) {
        final message = receivedMessage.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );
        _messagesController.add(payload);
      }
    });
  }

  void _resubscribeToTopics() {
    for (final topic in _subscribedTopics) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }
    _bindUpdatesListener();
  }

  @override
  Future<bool> connect() async {
    if (isConnected) {
      return true;
    }
    final connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connectionMessage;
    try {
      await _client.connect();
    } catch (_) {
      _client.disconnect();
      _emitConnectionState(false);
      return false;
    }
    if (isConnected) {
      _bindUpdatesListener();
      _emitConnectionState(true);
    }
    return isConnected;
  }

  @override
  Future<void> subscribe(String topic) async {
    _subscribedTopics.add(topic);
    if (isConnected) {
      _client.subscribe(topic, MqttQos.atMostOnce);
      _bindUpdatesListener();
    }
  }

  @override
  void disconnect() {
    _updatesSubscription?.cancel();
    _emitConnectionState(false);
    _client.disconnect();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _updatesSubscription?.cancel();
    _client.disconnect();
    _messagesController.close();
    _connectionController.close();
  }
}
