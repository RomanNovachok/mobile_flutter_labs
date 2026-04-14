import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_palette.dart';

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
