import 'package:mobile_flutter_lab1/data/models/user_model.dart';

abstract class AuthRepository {
  Future<void> registerUser(UserModel user);

  Future<UserModel?> loginUser({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();

  Future<void> updateUser(UserModel user);

  Future<void> deleteUser();

  Future<void> logout();
}
