import 'package:mobile_flutter_lab1/data/models/machine_event_model.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';

abstract class WorkshopRepository {
  Future<List<MachineEventModel>> getMachineEvents();

  Future<UserModel?> syncUserProfile(UserModel user);
}
