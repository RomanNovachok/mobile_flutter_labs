import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_palette.dart';

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
