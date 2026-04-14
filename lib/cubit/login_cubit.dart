import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/auth_validators.dart';
import 'package:mobile_flutter_lab1/cubit/login_state.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository, this._connectivityService)
    : super(const LoginState());

  final AuthRepository _authRepository;
  final ConnectivityService _connectivityService;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    if (!AuthValidators.isValidEmail(email)) {
      emit(_failure('Please enter a valid email.'));
      return;
    }

    if (password.isEmpty) {
      emit(_failure('Password cannot be empty.'));
      return;
    }

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      emit(_failure('No internet connection. Please try again later.'));
      return;
    }

    emit(const LoginState(status: LoginStatus.loading));

    UserModel? user;

    try {
      user = await _authRepository.loginUser(
        email: email,
        password: password,
      );
    } catch (_) {
      emit(_failure('Login failed. Please try again.'));
      return;
    }

    if (user == null) {
      emit(_failure('Invalid email or password.'));
      return;
    }

    emit(const LoginState(status: LoginStatus.success));
  }

  void clearError() {
    if (state.errorMessage.isEmpty && state.status != LoginStatus.failure) {
      return;
    }

    emit(const LoginState());
  }

  LoginState _failure(String message) {
    return LoginState(
      status: LoginStatus.failure,
      errorMessage: message,
    );
  }
}
