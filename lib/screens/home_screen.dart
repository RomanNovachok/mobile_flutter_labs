import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _primaryDark = Color(0xFF1F2937);
  static const _primaryBlue = Color(0xFF2563EB);
  static const _softBlue = Color(0xFFDBEAFE);
  static const _textMuted = Color(0xFF6B7280);
  static const _danger = Color(0xFFDC2626);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LatheGuard IoT',
          style: TextStyle(fontSize: context.sp(20)),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: context.sp(8)),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.profile);
              },
              icon: Icon(
                Icons.account_circle,
                size: context.sp(32),
              ),
            ),
          ),
        ],
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
                  padding: EdgeInsets.all(context.sp(18)),
                  decoration: BoxDecoration(
                    color: _primaryDark,
                    borderRadius: BorderRadius.circular(context.sp(16)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Machine status',
                        style: TextStyle(
                          fontSize: context.sp(16),
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: context.sp(8)),
                      Text(
                        'Running',
                        style: TextStyle(
                          fontSize: context.sp(28),
                          fontWeight: FontWeight.bold,
                          color: _softBlue,
                        ),
                      ),
                      SizedBox(height: context.sp(8)),
                      Text(
                        'Workshop node is online',
                        style: TextStyle(
                          fontSize: context.sp(14),
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sp(20)),
                Row(
                  children: [
                    const Expanded(
                      child: _StatusCard(
                        title: 'Flood sensor',
                        value: 'Safe',
                        valueColor: _primaryBlue,
                      ),
                    ),
                    SizedBox(width: context.sp(12)),
                    const Expanded(
                      child: _StatusCard(
                        title: 'Lathe speed',
                        value: '65%',
                        valueColor: _primaryBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.sp(12)),
                Row(
                  children: [
                    const Expanded(
                      child: _StatusCard(
                        title: 'Mode',
                        value: 'Manual',
                        valueColor: _primaryBlue,
                      ),
                    ),
                    SizedBox(width: context.sp(12)),
                    const Expanded(
                      child: _StatusCard(
                        title: 'Emergency',
                        value: 'Normal',
                        valueColor: _primaryBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.sp(24)),
                Text(
                  'Quick controls',
                  style: TextStyle(
                    fontSize: context.sp(22),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: context.sp(16)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Start machine'),
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
                    onPressed: () {},
                    icon: const Icon(Icons.pause),
                    label: const Text('Stop machine'),
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
                    onPressed: () {},
                    icon: const Icon(Icons.warning_amber_rounded),
                    label: const Text('Emergency stop'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _danger,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: context.sp(16)),
                    ),
                  ),
                ),
                SizedBox(height: context.sp(24)),
                Container(
                  padding: EdgeInsets.all(context.sp(16)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.sp(16)),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Last event: Water leak alert resolved.',
                    style: TextStyle(
                      fontSize: context.sp(15),
                      color: _textMuted,
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.title,
    required this.value,
    required this.valueColor,
  });

  final String title;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.sp(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(context.sp(16)),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: context.sp(14),
              color: HomeScreen._textMuted,
            ),
          ),
          SizedBox(height: context.sp(8)),
          Text(
            value,
            style: TextStyle(
              fontSize: context.sp(22),
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
