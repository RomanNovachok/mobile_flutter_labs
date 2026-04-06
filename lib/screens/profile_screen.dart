import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/repositories/remote_auth_repository.dart';
import 'package:mobile_flutter_lab1/data/repositories/workshop_repository_impl.dart';
import 'package:mobile_flutter_lab1/data/services/auth_api_service.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/data/services/workshop_api_service.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/custom_button.dart';
import 'package:mobile_flutter_lab1/widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const primaryDark = Color(0xFF1F2937);
  static const primaryBlue = Color(0xFF2563EB);
  static const textMuted = Color(0xFF6B7280);
  static const danger = Color(0xFFDC2626);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();
  final _localStorageService = LocalStorageService();
  final _connectivityService = ConnectivityService();

  late final _authRepository = RemoteAuthRepository(
    AuthApiService(),
    _localStorageService,
  );
  late final _workshopRepository = WorkshopRepositoryImpl(
    WorkshopApiService(),
    _localStorageService,
  );

  String _errorMessage = '';
  bool _isLoading = true;
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _loadUser() async {
    var user = await _authRepository.getCurrentUser();

    if (!mounted) {
      return;
    }

    if (user != null) {
      final syncedUser = await _workshopRepository.syncUserProfile(user);
      final profileUser = syncedUser ?? user;

      _fullNameController.text = profileUser.fullName;
      _emailController.text = profileUser.email;
      _roleController.text = profileUser.role;

      user = profileUser;
    }

    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
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

  Future<void> _saveChanges() async {
    if (_currentUser == null) {
      return;
    }

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final role = _roleController.text.trim();

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

    if (role.isEmpty) {
      setState(() {
        _errorMessage = 'Role cannot be empty.';
      });
      return;
    }

    setState(() {
      _errorMessage = '';
      _isLoading = true;
    });

    final updatedUser = _currentUser!.copyWith(
      fullName: fullName,
      email: email,
      role: role,
    );

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!hasInternet) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Internet connection is required to update profile.';
      });
      return;
    }

    try {
      await _authRepository.updateUser(updatedUser);
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'Profile update failed. Please try again.';
      });
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _currentUser = updatedUser;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully.'),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!mounted) {
      return;
    }

    if (!hasInternet) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internet connection is required to delete account.'),
        ),
      );
      return;
    }

    try {
      await _authRepository.deleteUser();
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account deletion failed. Please try again.'),
        ),
      );
      return;
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account deleted.'),
      ),
    );

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm logout'),
          content: const Text(
            'Are you sure you want to log out of your account?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true) {
      return;
    }

    await _authRepository.logout();

    if (!mounted) {
      return;
    }

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontSize: context.sp(20)),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.sp(20)),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.isTablet ? 700 : double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(context.sp(20)),
                  decoration: BoxDecoration(
                    color: ProfileScreen.primaryDark,
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
                        _currentUser?.fullName ?? 'User',
                        style: TextStyle(
                          fontSize: context.sp(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.sp(6)),
                      Text(
                        _currentUser?.role ?? 'Operator',
                        style: TextStyle(
                          fontSize: context.sp(14),
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sp(24)),
                Text(
                  'Personal information',
                  style: TextStyle(
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.sp(16)),
                CustomTextField(
                  labelText: 'Full name',
                  hintText: 'Name Surname',
                  controller: _fullNameController,
                ),
                SizedBox(height: context.sp(16)),
                CustomTextField(
                  labelText: 'Email',
                  hintText: 'example@email.com',
                  controller: _emailController,
                ),
                SizedBox(height: context.sp(16)),
                CustomTextField(
                  labelText: 'Role',
                  hintText: 'Operator',
                  controller: _roleController,
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
                SizedBox(height: context.sp(24)),
                Text(
                  'Device information',
                  style: TextStyle(
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.sp(16)),
                const _InfoCard(
                  title: 'Connected device',
                  value: 'ESP32 Workshop Node',
                ),
                SizedBox(height: context.sp(12)),
                const _InfoCard(
                  title: 'Connection status',
                  value: 'Online',
                ),
                SizedBox(height: context.sp(12)),
                const _InfoCard(
                  title: 'Location',
                  value: 'Workshop A',
                ),
                SizedBox(height: context.sp(24)),
                CustomButton(
                  text: 'Save changes',
                  icon: Icons.save,
                  backgroundColor: ProfileScreen.primaryBlue,
                  foregroundColor: Colors.white,
                  onPressed: _saveChanges,
                ),
                SizedBox(height: context.sp(12)),
                CustomButton(
                  text: 'Back to home',
                  icon: Icons.home,
                  isOutlined: true,
                  foregroundColor: ProfileScreen.primaryDark,
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                ),
                SizedBox(height: context.sp(12)),
                CustomButton(
                  text: 'Logout',
                  icon: Icons.logout,
                  backgroundColor: ProfileScreen.danger,
                  foregroundColor: Colors.white,
                  onPressed: _logout,
                ),
                SizedBox(height: context.sp(12)),
                CustomButton(
                  text: 'Delete account',
                  icon: Icons.delete,
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  onPressed: _deleteAccount,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.value,
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
                color: ProfileScreen.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: ProfileScreen.primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
