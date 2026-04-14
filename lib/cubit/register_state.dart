enum RegisterStatus { initial, loading, success, failure }

class RegisterState {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.errorMessage = '',
  });

  final RegisterStatus status;
  final String errorMessage;

  bool get isLoading => status == RegisterStatus.loading;
}
