import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/auth_validators.dart';
import 'package:mobile_flutter_lab1/cubit/profile_state.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/auth_repository.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(
    this._authRepository,
    this._workshopRepository,
    this._connectivityService,
  ) : super(const ProfileState());
  final AuthRepository _authRepository;
  final WorkshopRepository _workshopRepository;
  final ConnectivityService _connectivityService;

  Future<void> loadProfile() async {
    emit(const ProfileState());
    var user = await _authRepository.getCurrentUser();
    if (user != null) {
      final syncedUser = await _workshopRepository.syncUserProfile(user);
      user = syncedUser ?? user;
    }
    emit(ProfileState(status: ProfileStatus.ready, user: user));
  }

  Future<void> saveProfile({
    required String fullName,
    required String email,
    required String role,
  }) async {
    final currentUser = state.user;
    if (currentUser == null) {
      emit(_failure('No user data is available right now.'));
      return;
    }
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
    if (role.isEmpty) {
      emit(_failure('Role cannot be empty.'));
      return;
    }
    final hasInternet = await _connectivityService.hasInternetConnection();
    if (!hasInternet) {
      emit(_failure('Internet connection is required to update profile.'));
      return;
    }
    emit(ProfileState(status: ProfileStatus.submitting, user: currentUser));
    final updatedUser = currentUser.copyWith(
      fullName: fullName,
      email: email,
      role: role,
    );
    try {
      await _authRepository.updateUser(updatedUser);
    } catch (_) {
      emit(
        ProfileState(
          status: ProfileStatus.ready,
          action: ProfileAction.failure,
          user: currentUser,
          message: 'Profile update failed. Please try again.',
        ),
      );
      return;
    }
    emit(
      ProfileState(
        status: ProfileStatus.ready,
        action: ProfileAction.updated,
        user: updatedUser,
        message: 'Profile updated successfully.',
      ),
    );
  }

  Future<void> deleteAccount() async {
    final hasInternet = await _connectivityService.hasInternetConnection();
    if (!hasInternet) {
      emit(_failure('Internet connection is required to delete account.'));
      return;
    }
    try {
      await _authRepository.deleteUser();
    } catch (_) {
      emit(_failure('Account deletion failed. Please try again.'));
      return;
    }

    emit(
      const ProfileState(
        status: ProfileStatus.ready,
        action: ProfileAction.deleted,
        message: 'Account deleted.',
      ),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const ProfileState(
      status: ProfileStatus.ready,
      action: ProfileAction.loggedOut,
    ));
  }

  void clearAction() {
    emit(ProfileState(status: ProfileStatus.ready, user: state.user));
  }

  ProfileState _failure(String message) {
    return ProfileState(
      status: ProfileStatus.ready,
      action: ProfileAction.failure,
      user: state.user,
      message: message,
    );
  }
}
