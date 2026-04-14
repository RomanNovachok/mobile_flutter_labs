import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';

class EventsEmptyState extends StatelessWidget {
  const EventsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedbackCard(
      text: 'No machine events are available yet.',
    );
  }
}

class EventsErrorState extends StatelessWidget {
  const EventsErrorState({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeedbackCard(
      text: 'Machine events could not be loaded right now.',
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.text});

  final String text;

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
        text,
        style: TextStyle(
          fontSize: context.sp(15),
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
