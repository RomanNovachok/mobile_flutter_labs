import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._localStorageService);

  final LocalStorageService _localStorageService;

  @override
  Future<void> registerUser(UserModel user) async {
    await _localStorageService.saveUser(user);
  }

  @override
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final savedUser = await _localStorageService.getUser();

    if (savedUser == null) {
      return null;
    }

    final isValidUser =
        savedUser.email == email && savedUser.password == password;

    if (!isValidUser) {
      return null;
    }

    await _localStorageService.setLoggedIn(true);

    return savedUser;
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
    await _localStorageService.saveUser(user);
  }

  @override
  Future<void> deleteUser() async {
    await _localStorageService.deleteUser();
  }

  @override
  Future<void> logout() async {
    await _localStorageService.logout();
  }
}
