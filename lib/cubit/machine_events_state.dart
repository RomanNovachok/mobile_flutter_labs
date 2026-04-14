import 'package:mobile_flutter_lab1/data/models/machine_event_model.dart';

enum MachineEventsStatus { initial, loading, success, failure }

class MachineEventsState {
  const MachineEventsState({
    this.status = MachineEventsStatus.initial,
    this.events = const [],
    this.hasInternet = true,
  });

  final MachineEventsStatus status;
  final List<MachineEventModel> events;
  final bool hasInternet;

  bool get isLoading =>
      status == MachineEventsStatus.loading && events.isEmpty;

  MachineEventsState copyWith({
    MachineEventsStatus? status,
    List<MachineEventModel>? events,
    bool? hasInternet,
  }) {
    return MachineEventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      hasInternet: hasInternet ?? this.hasInternet,
    );
  }
}
