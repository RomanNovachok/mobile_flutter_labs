import 'package:mobile_flutter_lab1/data/services/mqtt_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/mqtt_repository.dart';

class MqttRepositoryImpl implements MqttRepository {
  MqttRepositoryImpl(this._mqttService);

  final MqttService _mqttService;

  @override
  Future<bool> connect() async {
    return _mqttService.connect();
  }

  @override
  void disconnect() {
    _mqttService.disconnect();
  }

  @override
  Future<void> subscribe(String topic) async {
    await _mqttService.subscribe(topic);
  }

  @override
  Stream<String> get messagesStream => _mqttService.messagesStream;

  @override
  Stream<bool> get connectionStream => _mqttService.connectionStream;

  @override
  bool get isConnected => _mqttService.isConnected;
}
