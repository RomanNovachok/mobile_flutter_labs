import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/auth_api_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';

class RemoteAuthRepository implements AuthRepository {
  RemoteAuthRepository(this._apiService, this._localStorageService);

  final AuthApiService _apiService;
  final LocalStorageService _localStorageService;

  @override
  Future<void> registerUser(UserModel user) async {
    final users = await _apiService.fetchUsers();
    final alreadyExists = users.any(
      (existingUser) =>
          existingUser.email.toLowerCase() == user.email.toLowerCase(),
    );

    if (alreadyExists) {
      throw Exception('An account with this email already exists.');
    }

    final createdUser = await _apiService.createUser(user);
    await _localStorageService.saveUser(createdUser);
  }

  @override
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final users = await _apiService.fetchUsers();

    final matchingUsers = users.where(
      (user) =>
          user.email.toLowerCase() == email.toLowerCase() &&
          user.password == password,
    );

    if (matchingUsers.isEmpty) {
      return null;
    }

    final user = matchingUsers.first;
    await _localStorageService.saveUser(user);
    await _localStorageService.setLoggedIn(true);
    return user;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final isLoggedIn = await _localStorageService.isLoggedIn();

    if (!isLoggedIn) {
      return null;
    }

    return _localStorageService.getUser();
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final updatedUser = await _apiService.updateUser(user);
    await _localStorageService.saveUser(updatedUser);
  }

  @override
  Future<void> deleteUser() async {
    final currentUser = await _localStorageService.getUser();
    final userId = currentUser?.id;

    if (userId == null || userId.isEmpty) {
      throw Exception('No saved user found.');
    }

    await _apiService.deleteUser(userId);
    await _localStorageService.deleteUser();
  }

  @override
  Future<void> logout() async {
    await _localStorageService.logout();
  }
}
