import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_flutter_lab1/data/models/user_model.dart';

class AuthApiService {
  static final Uri _usersUri = Uri.parse(
    'https://69d2abd65043d95be9721706.mockapi.io/users',
  );

  Future<List<UserModel>> fetchUsers() async {
    final response = await http.get(_usersUri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load users');
    }

    final decoded = jsonDecode(response.body) as List<dynamic>;

    return decoded
        .map((user) => UserModel.fromDynamicMap(user as Map<String, dynamic>))
        .toList();
  }

  Future<UserModel> createUser(UserModel user) async {
    final response = await http.post(
      _usersUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()..remove('id')),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user');
    }

    return UserModel.fromDynamicMap(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<UserModel> updateUser(UserModel user) async {
    final userId = user.id;

    if (userId == null || userId.isEmpty) {
      throw Exception('User id is missing');
    }

    final response = await http.put(
      Uri.parse('${_usersUri.toString()}/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toMap()..remove('id')),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }

    return UserModel.fromDynamicMap(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> deleteUser(String userId) async {
    final response = await http.delete(
      Uri.parse('${_usersUri.toString()}/$userId'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}
