import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/custom_button.dart';
import 'package:mobile_flutter_lab1/widgets/custom_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: context.sp(24)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isTablet ? 420 : double.infinity,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.person_add_alt_1,
                  size: context.sp(80),
                ),
                SizedBox(height: context.sp(20)),
                Text(
                  'Create account',
                  style: TextStyle(
                    fontSize: context.sp(28),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: context.sp(32)),
                const CustomTextField(labelText: 'Username'),
                SizedBox(height: context.sp(16)),
                const CustomTextField(labelText: 'Email'),
                SizedBox(height: context.sp(16)),
                const CustomTextField(
                  labelText: 'Password',
                  obscureText: true,
                ),
                SizedBox(height: context.sp(16)),
                const CustomTextField(
                  labelText: 'Confirm password',
                  obscureText: true,
                ),
                SizedBox(height: context.sp(24)),
                CustomButton(
                  text: 'Create account',
                  icon: Icons.person_add,
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                ),
                SizedBox(height: context.sp(12)),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
                  },
                  child: Text(
                    'Back to login',
                    style: TextStyle(fontSize: context.sp(15)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
