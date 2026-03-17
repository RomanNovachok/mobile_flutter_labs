import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _primaryDark = Color(0xFF1F2937);
  static const _primaryBlue = Color(0xFF2563EB);
  static const _textMuted = Color(0xFF6B7280);
  static const _danger = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
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
                    color: _primaryDark,
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
                        'Roman Novachok',
                        style: TextStyle(
                          fontSize: context.sp(24),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: context.sp(6)),
                      Text(
                        'Operator',
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
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Full name',
                    hintText: 'Roman Novachok',
                    labelStyle: TextStyle(fontSize: context.sp(16)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.sp(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.sp(16),
                      vertical: context.sp(16),
                    ),
                  ),
                ),
                SizedBox(height: context.sp(16)),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'roman@example.com',
                    labelStyle: TextStyle(fontSize: context.sp(16)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.sp(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.sp(16),
                      vertical: context.sp(16),
                    ),
                  ),
                ),
                SizedBox(height: context.sp(16)),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Role',
                    hintText: 'Operator',
                    labelStyle: TextStyle(fontSize: context.sp(16)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(context.sp(12)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.sp(16),
                      vertical: context.sp(16),
                    ),
                  ),
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
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text('Save changes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: context.sp(16)),
                    ),
                  ),
                ),
                SizedBox(height: context.sp(12)),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.home);
                    },
                    icon: const Icon(Icons.home),
                    label: const Text('Back to home'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryDark,
                      padding: EdgeInsets.symmetric(vertical: context.sp(16)),
                      side: const BorderSide(color: _primaryDark),
                    ),
                  ),
                ),
                SizedBox(height: context.sp(12)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _danger,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: context.sp(16)),
                    ),
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
                color: ProfileScreen._textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(16),
              fontWeight: FontWeight.w600,
              color: ProfileScreen._primaryDark,
            ),
          ),
        ],
      ),
    );
  }
}
