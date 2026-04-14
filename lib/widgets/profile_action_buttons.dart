import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/widgets/custom_button.dart';
import 'package:mobile_flutter_lab1/widgets/profile_content.dart';

class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({
    required this.onSave,
    required this.onBack,
    required this.onLogout,
    required this.onDelete,
    super.key,
  });

  final VoidCallback onSave;
  final VoidCallback onBack;
  final VoidCallback onLogout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(
          text: 'Save changes',
          icon: Icons.save,
          backgroundColor: ProfileScreenPalette.primaryBlue,
          foregroundColor: Colors.white,
          onPressed: onSave,
        ),
        SizedBox(height: context.sp(12)),
        CustomButton(
          text: 'Back to home',
          icon: Icons.home,
          isOutlined: true,
          foregroundColor: ProfileScreenPalette.primaryDark,
          onPressed: onBack,
        ),
        SizedBox(height: context.sp(12)),
        CustomButton(
          text: 'Logout',
          icon: Icons.logout,
          backgroundColor: ProfileScreenPalette.danger,
          foregroundColor: Colors.white,
          onPressed: onLogout,
        ),
        SizedBox(height: context.sp(12)),
        CustomButton(
          text: 'Delete account',
          icon: Icons.delete,
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          onPressed: onDelete,
        ),
      ],
    );
  }
}
