import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    required this.labelText,
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
  });

  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool obscureText;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: TextStyle(fontSize: context.sp(16)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.sp(12)),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.sp(16),
          vertical: context.sp(16),
        ),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: _toggleVisibility,
                icon: Icon(
                  _isObscured ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ),
    );
  }
}
