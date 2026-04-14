import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/cubit/machine_events_state.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

class MachineEventsCubit extends Cubit<MachineEventsState> {
  MachineEventsCubit(this._workshopRepository)
    : super(const MachineEventsState());

  final WorkshopRepository _workshopRepository;

  Future<void> loadEvents({required bool hasInternet}) async {
    emit(
      state.copyWith(
        status: MachineEventsStatus.loading,
        hasInternet: hasInternet,
      ),
    );

    try {
      final events = await _workshopRepository.getMachineEvents();
      emit(
        state.copyWith(
          status: MachineEventsStatus.success,
          events: events,
          hasInternet: hasInternet,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: MachineEventsStatus.failure,
          hasInternet: hasInternet,
        ),
      );
    }
  }
}
