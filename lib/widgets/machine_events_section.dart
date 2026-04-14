import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/machine_events_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/machine_events_state.dart';
import 'package:mobile_flutter_lab1/widgets/machine_event_card.dart';
import 'package:mobile_flutter_lab1/widgets/machine_events_feedback.dart';

class MachineEventsSection extends StatelessWidget {
  const MachineEventsSection({
    required this.hasInternet,
    super.key,
  });

  final bool hasInternet;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MachineEventsCubit, MachineEventsState>(
      builder: (context, state) {
        final events = state.events;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Machine events',
              style: TextStyle(
                fontSize: context.sp(22),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: context.sp(8)),
            Text(
              hasInternet
                  ? 'Latest workshop activity from the API.'
                  : 'Showing saved machine events while you are offline.',
              style: TextStyle(
                fontSize: context.sp(14),
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: context.sp(16)),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.status == MachineEventsStatus.failure)
              const EventsErrorState()
            else if (events.isEmpty)
              const EventsEmptyState()
            else
              ...events.map(MachineEventCard.new),
          ],
        );
      },
    );
  }
}
