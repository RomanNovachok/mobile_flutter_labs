import 'package:mobile_flutter_lab1/data/models/user_model.dart';

enum ProfileStatus { loading, ready, submitting }

enum ProfileAction { none, failure, updated, deleted, loggedOut }

class ProfileState {
  const ProfileState({
    this.status = ProfileStatus.loading,
    this.action = ProfileAction.none,
    this.user,
    this.message = '',
  });

  final ProfileStatus status;
  final ProfileAction action;
  final UserModel? user;
  final String message;

  bool get isLoading => status != ProfileStatus.ready;
}
