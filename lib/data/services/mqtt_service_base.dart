abstract class MqttServiceBase {
  Future<bool> connect();

  Future<void> subscribe(String topic);

  Stream<String> get messagesStream;

  Stream<bool> get connectionStream;

  bool get isConnected;

  void disconnect();

  void dispose();
}
