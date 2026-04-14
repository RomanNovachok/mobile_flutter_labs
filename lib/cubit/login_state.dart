enum LoginStatus { initial, loading, success, failure }

class LoginState {
  const LoginState({
    this.status = LoginStatus.initial,
    this.errorMessage = '',
  });

  final LoginStatus status;
  final String errorMessage;

  bool get isLoading => status == LoginStatus.loading;
}
