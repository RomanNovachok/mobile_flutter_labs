import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';

class ProfileScreenPalette {
  static const primaryDark = Color(0xFF1F2937);
  static const primaryBlue = Color(0xFF2563EB);
  static const textMuted = Color(0xFF6B7280);
  static const danger = Color(0xFFDC2626);
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.userName,
    required this.role,
    super.key,
  });

  final String? userName;
  final String? role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(20)),
      decoration: BoxDecoration(
        color: ProfileScreenPalette.primaryDark,
        borderRadius: BorderRadius.circular(context.sp(16)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_circle,
            size: context.sp(72),
            color: Colors.white,
          ),
          SizedBox(height: context.sp(12)),
          Text(
            userName ?? 'User',
            style: TextStyle(
              fontSize: context.sp(24),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.sp(6)),
          Text(
            role ?? 'Operator',
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

class ProfileSectionTitle extends StatelessWidget {
  const ProfileSectionTitle({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.sp(22),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    required this.title,
    required this.value,
    super.key,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: context.sp(15),
                color: ProfileScreenPalette.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: ProfileScreenPalette.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
