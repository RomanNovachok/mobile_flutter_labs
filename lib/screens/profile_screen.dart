import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/profile_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/profile_state.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/profile_form_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    await context.read<ProfileCubit>().saveProfile(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      role: _roleController.text.trim(),
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldLogout != true) {
      return;
    }

    await context.read<ProfileCubit>().logout();
  }

  void _syncControllers(ProfileState state) {
    final user = state.user;

    if (user == null) {
      return;
    }

    _fullNameController.text = user.fullName;
    _emailController.text = user.email;
    _roleController.text = user.role;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        _syncControllers(state);
        if (state.action == ProfileAction.none) {
          return;
        }
        if (state.message.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state.action == ProfileAction.deleted ||
            state.action == ProfileAction.loggedOut) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
        context.read<ProfileCubit>().clearAction();
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: TextStyle(fontSize: context.sp(20))),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(context.sp(20)),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: context.isTablet ? 700 : double.infinity,
                ),
                child: ProfileFormSection(
                  state: state,
                  fullNameController: _fullNameController,
                  emailController: _emailController,
                  roleController: _roleController,
                  onSave: _saveChanges,
                  onLogout: _logout,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
