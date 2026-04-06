import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/repositories/remote_auth_repository.dart';
import 'package:mobile_flutter_lab1/data/services/auth_api_service.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
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

  final _authRepository = RemoteAuthRepository(
    AuthApiService(),
    LocalStorageService(),
  );

  final _connectivityService = ConnectivityService();

  String _errorMessage = '';
  bool _isLoading = false;

  bool _isEmailValid(String value) {
    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    return emailRegex.hasMatch(value);
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!_isEmailValid(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email.';
      });
      return;
    }

    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty.';
      });
      return;
    }

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      setState(() {
        _errorMessage = 'No internet connection. Please try again later.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    UserModel? user;

    try {
      user = await _authRepository.loginUser(
        email: email,
        password: password,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Login failed. Please try again.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    if (user == null) {
      setState(() {
        _errorMessage = 'Invalid email or password.';
      });
      return;
    }

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: context.sp(14),
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: context.sp(16)),
                if (_isLoading)
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
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: Text(
                    'Create account',
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
