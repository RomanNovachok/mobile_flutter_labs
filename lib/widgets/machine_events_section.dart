import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/machine_event_model.dart';
import 'package:mobile_flutter_lab1/domain/repositories/workshop_repository.dart';

class MachineEventsSection extends StatefulWidget {
  const MachineEventsSection({
    required this.repository,
    required this.hasInternet,
    super.key,
  });

  final WorkshopRepository repository;
  final bool hasInternet;

  @override
  State<MachineEventsSection> createState() => _MachineEventsSectionState();
}

class _MachineEventsSectionState extends State<MachineEventsSection> {
  late Future<List<MachineEventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = widget.repository.getMachineEvents();
  }

  @override
  void didUpdateWidget(covariant MachineEventsSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.hasInternet != widget.hasInternet && widget.hasInternet) {
      _refreshEvents();
    }
  }

  void _refreshEvents() {
    if (!mounted) {
      return;
    }

    setState(() {
      _eventsFuture = widget.repository.getMachineEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MachineEventModel>>(
      future: _eventsFuture,
      builder: (context, snapshot) {
        final events = snapshot.data ?? <MachineEventModel>[];

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
              widget.hasInternet
                  ? 'Latest workshop activity from the API.'
                  : 'Showing saved machine events while you are offline.',
              style: TextStyle(
                fontSize: context.sp(14),
                color: const Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: context.sp(16)),
            if (snapshot.connectionState == ConnectionState.waiting)
              const Center(child: CircularProgressIndicator())
            else if (events.isEmpty)
              const _EventsEmptyState()
            else
              ...events.map(_MachineEventCard.new),
          ],
        );
      },
    );
  }
}

class _EventsEmptyState extends StatelessWidget {
  const _EventsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Text(
        'No machine events are available yet.',
        style: TextStyle(
          fontSize: context.sp(15),
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

class _MachineEventCard extends StatelessWidget {
  const _MachineEventCard(this.event);

  final MachineEventModel event;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.sp(12)),
      padding: EdgeInsets.all(context.sp(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  event.title,
                  style: TextStyle(
                    fontSize: context.sp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                event.severity,
                style: TextStyle(
                  fontSize: context.sp(13),
                  color: _severityColor(event.severity),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.sp(8)),
          Text(
            event.description,
            style: TextStyle(
              fontSize: context.sp(14),
              color: const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Color _severityColor(String severity) {
    switch (severity) {
      case 'High':
        return const Color(0xFFDC2626);
      case 'Medium':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF2563EB);
    }
  }
}
