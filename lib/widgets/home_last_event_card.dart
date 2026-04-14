import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_palette.dart';

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
