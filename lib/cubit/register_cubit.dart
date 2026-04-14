import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/auth_validators.dart';
import 'package:mobile_flutter_lab1/cubit/register_state.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._authRepository, this._connectivityService)
    : super(const RegisterState());

  final AuthRepository _authRepository;
  final ConnectivityService _connectivityService;

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (!AuthValidators.isValidName(fullName)) {
      emit(
        _failure(
          'Full name must contain only letters, spaces, '
          'apostrophes or hyphens.',
        ),
      );
      return;
    }

    if (!AuthValidators.isValidEmail(email)) {
      emit(_failure('Please enter a valid email.'));
      return;
    }

    if (!AuthValidators.isValidPassword(password)) {
      emit(_failure('Password must be at least 6 characters long.'));
      return;
    }

    if (password != confirmPassword) {
      emit(_failure('Passwords do not match.'));
      return;
    }

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      emit(_failure('Internet connection is required to register.'));
      return;
    }

    emit(const RegisterState(status: RegisterStatus.loading));

    final user = UserModel(
      fullName: fullName,
      email: email,
      password: password,
      role: 'Operator',
    );

    try {
      await _authRepository.registerUser(user);
    } catch (error) {
      emit(_failure(error.toString().replaceFirst('Exception: ', '')));
      return;
    }

    emit(const RegisterState(status: RegisterStatus.success));
  }

  void clearError() {
    if (state.errorMessage.isEmpty && state.status != RegisterStatus.failure) {
      return;
    }

    emit(const RegisterState());
  }

  RegisterState _failure(String message) {
    return RegisterState(
      status: RegisterStatus.failure,
      errorMessage: message,
    );
  }
}
