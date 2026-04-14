import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_palette.dart';

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
