import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/widgets/home_screen_palette.dart';

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
