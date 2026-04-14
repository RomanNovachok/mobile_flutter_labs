part of 'home_cubit.dart';

extension HomeCubitSessionX on HomeCubit {
  Future<void> loadUser() async {
    final user = await _authRepository.getCurrentUser();
    emitState(state.copyWith(user: user, isLoading: false));

    if (user != null) {
      await syncUserProfile(user);
    }
  }

  Future<void> syncUserProfile(UserModel user) async {
    final syncedUser = await _workshopRepository.syncUserProfile(user);

    if (syncedUser != null) {
      emitState(state.copyWith(user: syncedUser));
    }
  }

  Future<void> checkInternet() async {
    final hasInternet = await _connectivityService.hasInternetConnection();
    emitState(state.copyWith(hasInternet: hasInternet));

    if (!hasInternet) {
      emitState(
        state.copyWith(
          lastEvent: 'You are offline now, so the dashboard is showing '
              'the last saved state.',
          notificationMessage: 'No internet connection. Limited functionality.',
        ),
      );
    }
  }

  void listenToInternet() {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((result) async {
      final hasInternet = !result.contains(ConnectivityResult.none);
      final wasOffline = !state.hasInternet;

      emitState(state.copyWith(hasInternet: hasInternet));

      if (!hasInternet) {
        clearMqttIndicator();
        _mqttRepository.disconnect();
        emitState(
          state.copyWith(
            lastEvent: 'Internet connection was lost, so live MQTT updates '
                'are paused for now.',
            notificationMessage: 'Internet connection lost.',
          ),
        );
        return;
      }

      emitState(
        state.copyWith(
          notificationMessage: 'Internet connection restored.',
        ),
      );

      if (wasOffline) {
        await reconnectMqtt();
      }
    });
  }
}
