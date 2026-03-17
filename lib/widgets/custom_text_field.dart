import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    required this.labelText,
    super.key,
    this.hintText,
    this.obscureText = false,
  });

  final String labelText;
  final String? hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(fontSize: context.sp(16)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.sp(12)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.sp(16),
          vertical: context.sp(16),
        ),
      ),
    );
  }
}
