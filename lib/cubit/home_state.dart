import 'package:mobile_flutter_lab1/data/models/user_model.dart';

enum HomeMqttIndicator { none, connecting, connected }

class HomeState {
  const HomeState({
    this.isLoading = true,
    this.hasInternet = true,
    this.user,
    this.floodStatus = 'Safe',
    this.latheSpeed = '65',
    this.lastEvent = 'Waiting for MQTT updates...',
    this.mqttIndicator = HomeMqttIndicator.none,
    this.notificationMessage,
  });

  final bool isLoading;
  final bool hasInternet;
  final UserModel? user;
  final String floodStatus;
  final String latheSpeed;
  final String lastEvent;
  final HomeMqttIndicator mqttIndicator;
  final String? notificationMessage;

  HomeState copyWith({
    bool? isLoading,
    bool? hasInternet,
    UserModel? user,
    bool preserveUser = true,
    String? floodStatus,
    String? latheSpeed,
    String? lastEvent,
    HomeMqttIndicator? mqttIndicator,
    String? notificationMessage,
    bool clearNotification = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      hasInternet: hasInternet ?? this.hasInternet,
      user: preserveUser ? (user ?? this.user) : user,
      floodStatus: floodStatus ?? this.floodStatus,
      latheSpeed: latheSpeed ?? this.latheSpeed,
      lastEvent: lastEvent ?? this.lastEvent,
      mqttIndicator: mqttIndicator ?? this.mqttIndicator,
      notificationMessage: clearNotification
          ? null
          : notificationMessage ?? this.notificationMessage,
    );
  }
}
