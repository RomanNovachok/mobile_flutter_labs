import 'package:mobile_flutter_lab1/data/models/machine_event_model.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/data/services/workshop_api_service.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

class WorkshopRepositoryImpl implements WorkshopRepository {
  WorkshopRepositoryImpl(this._apiService, this._localStorageService);

  final WorkshopApiService _apiService;
  final LocalStorageService _localStorageService;

  @override
  Future<List<MachineEventModel>> getMachineEvents() async {
    try {
      final remoteEvents = await _apiService.fetchMachineEvents();
      final mappedEvents = remoteEvents
          .map(MachineEventModel.fromApi)
          .toList()
        ..sort((first, second) => second.id.compareTo(first.id));

      await _localStorageService.saveMachineEvents(mappedEvents);
      return mappedEvents;
    } catch (_) {
      final cachedEvents = await _localStorageService.getMachineEvents();

      cachedEvents.sort((first, second) => second.id.compareTo(first.id));
      return cachedEvents;
    }
  }

  @override
  Future<UserModel?> syncUserProfile(UserModel user) async {
    return user;
  }
}
