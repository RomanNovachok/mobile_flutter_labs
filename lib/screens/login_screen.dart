import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/login_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/login_state.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/custom_button.dart';
import 'package:mobile_flutter_lab1/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await context.read<LoginCubit>().login(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: context.sp(24)),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.isTablet ? 420 : double.infinity,
              ),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Icon(Icons.precision_manufacturing, size: context.sp(80)),
                      SizedBox(height: context.sp(20)),
                      Text(
                        'LatheGuard IoT',
                        style: TextStyle(
                          fontSize: context.sp(28),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.sp(40)),
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
                          text: 'Login',
                          icon: Icons.login,
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          onPressed: _login,
                        ),
                      SizedBox(height: context.sp(12)),
                      TextButton(
                        onPressed: () {
                          context.read<LoginCubit>().clearError();
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: Text(
                          'Create account',
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
