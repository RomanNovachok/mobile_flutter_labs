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

  final _authRepository = RemoteAuthRepository(
    AuthApiService(),
    LocalStorageService(),
  );
  final _connectivityService = ConnectivityService();

  String _errorMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isNameValid(String value) {
  final nameRegex = RegExp(r"^[a-zA-Zа-яА-ЯіІїЇєЄґҐ'\-\s]+$");

  return value.isNotEmpty && nameRegex.hasMatch(value);
}

bool _isEmailValid(String value) {
  final emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  return emailRegex.hasMatch(value);
}

  bool _isPasswordValid(String value) {
    return value.length >= 6;
  }

  Future<void> _register() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!_isNameValid(fullName)) {
      setState(() {
        _errorMessage =
    'Full name must contain only letters, spaces, apostrophes or hyphens.';
      });
      return;
    }

    if (!_isEmailValid(email)) {
      setState(() {
        _errorMessage = 'Please enter a valid email.';
      });
      return;
    }

    if (!_isPasswordValid(password)) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      setState(() {
        _errorMessage = 'Internet connection is required to register.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final user = UserModel(
      fullName: fullName,
      email: email,
      password: password,
      role: 'Operator',
    );

    try {
      await _authRepository.registerUser(user);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful. Please log in.'),
      ),
    );

    Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                    text: 'Create account',
                    icon: Icons.person_add,
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    onPressed: _register,
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
