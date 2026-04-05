import 'dart:convert';

import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const _userKey = 'user_data';
  static const _isLoggedInKey = 'is_logged_in';
  static const _mqttPayloadKey = 'last_mqtt_payload';

  Future<void> saveUser(UserModel user) async {
    final preferences = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toMap());

    await preferences.setString(_userKey, userJson);
  }

  Future<UserModel?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    final userJson = preferences.getString(_userKey);

    if (userJson == null) {
      return null;
    }

    final decodedJson = jsonDecode(userJson) as Map<String, dynamic>;
    final userMap = decodedJson.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    return UserModel.fromMap(userMap);
  }

  Future<void> setLoggedIn(bool value) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_isLoggedInKey, value);
  }

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getBool(_isLoggedInKey) ?? false;
  }

  Future<void> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_userKey);
    await preferences.remove(_isLoggedInKey);
  }

  Future<void> logout() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(_isLoggedInKey, false);
  }

  Future<void> saveLastMqttPayload(String payload) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString(_mqttPayloadKey, payload);
  }

  Future<String?> getLastMqttPayload() async {
    final preferences = await SharedPreferences.getInstance();

    return preferences.getString(_mqttPayloadKey);
  }

  Future<void> clearLastMqttPayload() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.remove(_mqttPayloadKey);
  }
}
