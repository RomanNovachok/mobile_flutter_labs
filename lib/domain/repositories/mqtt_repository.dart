abstract class MqttRepository {
  Future<bool> connect();

  void disconnect();

  Future<void> subscribe(String topic);

  Stream<String> get messagesStream;

  Stream<bool> get connectionStream;

  bool get isConnected;
}
