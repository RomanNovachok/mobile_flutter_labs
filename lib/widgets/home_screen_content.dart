import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';

class HomeScreenPalette {
  static const primaryDark = Color(0xFF1F2937);
  static const primaryBlue = Color(0xFF2563EB);
  static const softBlue = Color(0xFFDBEAFE);
  static const textMuted = Color(0xFF6B7280);
  static const danger = Color(0xFFDC2626);
}

class HomeGreetingSection extends StatelessWidget {
  const HomeGreetingSection({
    required this.user,
    required this.hasInternet,
    required this.mqttStatusLabel,
    required this.mqttStatusColor,
    super.key,
  });

  final UserModel? user;
  final bool hasInternet;
  final String? mqttStatusLabel;
  final Color? mqttStatusColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome, ${user?.fullName ?? 'User'}',
          style: TextStyle(
            fontSize: context.sp(24),
            fontWeight: FontWeight.bold,
            color: HomeScreenPalette.primaryDark,
          ),
        ),
        SizedBox(height: context.sp(6)),
        Text(
          user?.email ?? '',
          style: TextStyle(
            fontSize: context.sp(14),
            color: HomeScreenPalette.textMuted,
          ),
        ),
        if (!hasInternet)
          Padding(
            padding: EdgeInsets.only(top: context.sp(8)),
            child: Text(
              'Offline mode',
              style: TextStyle(
                color: Colors.red,
                fontSize: context.sp(14),
              ),
            ),
          ),
        if (mqttStatusLabel != null)
          Padding(
            padding: EdgeInsets.only(top: context.sp(8)),
            child: Text(
              mqttStatusLabel!,
              style: TextStyle(
                color: mqttStatusColor,
                fontSize: context.sp(14),
              ),
            ),
          ),
      ],
    );
  }
}

class HomeMachineOverviewCard extends StatelessWidget {
  const HomeMachineOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(18)),
      decoration: BoxDecoration(
        color: HomeScreenPalette.primaryDark,
        borderRadius: BorderRadius.circular(context.sp(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Machine status',
            style: TextStyle(
              fontSize: context.sp(16),
              color: Colors.white70,
            ),
          ),
          SizedBox(height: context.sp(8)),
          Text(
            'Running',
            style: TextStyle(
              fontSize: context.sp(28),
              fontWeight: FontWeight.bold,
              color: HomeScreenPalette.softBlue,
            ),
          ),
          SizedBox(height: context.sp(8)),
          Text(
            'Workshop node is online',
            style: TextStyle(
              fontSize: context.sp(14),
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeStatusGrid extends StatelessWidget {
  const HomeStatusGrid({
    required this.floodStatus,
    required this.latheSpeed,
    super.key,
  });

  final String floodStatus;
  final String latheSpeed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: HomeStatusCard(
                title: 'Flood sensor',
                value: floodStatus,
                valueColor: HomeScreenPalette.primaryBlue,
              ),
            ),
            SizedBox(width: context.sp(12)),
            Expanded(
              child: HomeStatusCard(
                title: 'Lathe speed',
                value: '$latheSpeed%',
                valueColor: HomeScreenPalette.primaryBlue,
              ),
            ),
          ],
        ),
        SizedBox(height: context.sp(12)),
        Row(
          children: [
            const Expanded(
              child: HomeStatusCard(
                title: 'Mode',
                value: 'Manual',
                valueColor: HomeScreenPalette.primaryBlue,
              ),
            ),
            SizedBox(width: context.sp(12)),
            const Expanded(
              child: HomeStatusCard(
                title: 'Emergency',
                value: 'Normal',
                valueColor: HomeScreenPalette.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class HomeQuickControlsSection extends StatelessWidget {
  const HomeQuickControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Quick controls',
          style: TextStyle(
            fontSize: context.sp(22),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.sp(16)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start machine'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeScreenPalette.primaryBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: context.sp(16)),
            ),
          ),
        ),
        SizedBox(height: context.sp(12)),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.pause),
            label: const Text('Stop machine'),
            style: OutlinedButton.styleFrom(
              foregroundColor: HomeScreenPalette.primaryDark,
              padding: EdgeInsets.symmetric(vertical: context.sp(16)),
              side: const BorderSide(color: HomeScreenPalette.primaryDark),
            ),
          ),
        ),
        SizedBox(height: context.sp(12)),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text('Emergency stop'),
            style: ElevatedButton.styleFrom(
              backgroundColor: HomeScreenPalette.danger,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: context.sp(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class HomeLastEventCard extends StatelessWidget {
  const HomeLastEventCard({
    required this.lastEvent,
    super.key,
  });

  final String lastEvent;

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
        'Last event: $lastEvent',
        style: TextStyle(
          fontSize: context.sp(15),
          color: HomeScreenPalette.textMuted,
        ),
      ),
    );
  }
}

class HomeStatusCard extends StatelessWidget {
  const HomeStatusCard({
    required this.title,
    required this.value,
    required this.valueColor,
    super.key,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(14),
              color: HomeScreenPalette.textMuted,
            ),
          ),
          SizedBox(height: context.sp(8)),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(22),
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
