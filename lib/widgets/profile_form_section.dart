import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/cubit/profile_cubit.dart';
import 'package:mobile_flutter_lab1/cubit/profile_state.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/custom_text_field.dart';
import 'package:mobile_flutter_lab1/widgets/profile_action_buttons.dart';
import 'package:mobile_flutter_lab1/widgets/profile_content.dart';

class ProfileFormSection extends StatelessWidget {
  const ProfileFormSection({
    required this.state,
    required this.fullNameController,
    required this.emailController,
    required this.roleController,
    required this.onSave,
    required this.onLogout,
    super.key,
  });

  final ProfileState state;
  final TextEditingController fullNameController;
  final TextEditingController emailController;
  final TextEditingController roleController;
  final Future<void> Function() onSave;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ProfileHeader(
          userName: state.user?.fullName,
          role: state.user?.role,
        ),
        SizedBox(height: context.sp(24)),
        const ProfileSectionTitle(title: 'Personal information'),
        SizedBox(height: context.sp(16)),
        CustomTextField(
          labelText: 'Full name',
          hintText: 'Name Surname',
          controller: fullNameController,
        ),
        SizedBox(height: context.sp(16)),
        CustomTextField(
          labelText: 'Email',
          hintText: 'example@email.com',
          controller: emailController,
        ),
        SizedBox(height: context.sp(16)),
        CustomTextField(
          labelText: 'Role',
          hintText: 'Operator',
          controller: roleController,
        ),
        SizedBox(height: context.sp(24)),
        const ProfileSectionTitle(title: 'Device information'),
        SizedBox(height: context.sp(16)),
        const ProfileInfoCard(
          title: 'Connected device',
          value: 'ESP32 Workshop Node',
        ),
        SizedBox(height: context.sp(12)),
        const ProfileInfoCard(
          title: 'Connection status',
          value: 'Online',
        ),
        SizedBox(height: context.sp(12)),
        const ProfileInfoCard(
          title: 'Location',
          value: 'Workshop A',
        ),
        SizedBox(height: context.sp(24)),
        if (state.status == ProfileStatus.submitting)
          const Center(child: CircularProgressIndicator())
        else
          ProfileActionButtons(
            onSave: onSave,
            onBack: () => Navigator.pushNamed(context, AppRoutes.home),
            onLogout: onLogout,
            onDelete: context.read<ProfileCubit>().deleteAccount,
          ),
      ],
    );
  }
}
