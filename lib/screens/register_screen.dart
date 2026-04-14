import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/register_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/register_state.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/custom_button.dart';
import 'package:mobile_flutter_lab1/widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    await context.read<RegisterCubit>().register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status != RegisterStatus.success) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful. Please log in.'),
          ),
        );
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.sp(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.isTablet ? 420 : double.infinity,
              ),
              child: BlocBuilder<RegisterCubit, RegisterState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Icon(Icons.person_add_alt_1, size: context.sp(80)),
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
                      CustomTextField(
                        labelText: 'Full name',
                        hintText: 'Name Surname',
                        controller: _fullNameController,
                      ),
                      SizedBox(height: context.sp(16)),
                      CustomTextField(
                        labelText: 'Email',
                        controller: _emailController,
                      ),
                      SizedBox(height: context.sp(16)),
                      CustomTextField(
                        labelText: 'Password',
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      SizedBox(height: context.sp(16)),
                      CustomTextField(
                        labelText: 'Confirm password',
                        obscureText: true,
                        controller: _confirmPasswordController,
                      ),
                      SizedBox(height: context.sp(16)),
                      if (state.errorMessage.isNotEmpty)
                        Text(
                          state.errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: context.sp(14),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: context.sp(16)),
                      if (state.isLoading)
                        const CircularProgressIndicator()
                      else
                        CustomButton(
                          text: 'Create account',
                          icon: Icons.person_add,
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          onPressed: _register,
                        ),
                      SizedBox(height: context.sp(12)),
                      TextButton(
                        onPressed: () {
                          context.read<RegisterCubit>().clearError();
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          'Back to login',
                          style: TextStyle(fontSize: context.sp(15)),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
