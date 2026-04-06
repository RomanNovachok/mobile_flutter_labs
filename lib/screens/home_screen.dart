import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mobile_flutter_lab1/core/utils/responsive_utils.dart';
import 'package:mobile_flutter_lab1/data/models/user_model.dart';
import 'package:mobile_flutter_lab1/data/repositories/local_auth_repository.dart';
import 'package:mobile_flutter_lab1/data/repositories/mqtt_repository_impl.dart';
import 'package:mobile_flutter_lab1/data/repositories/workshop_repository_impl.dart';
import 'package:mobile_flutter_lab1/data/services/connectivity_service.dart';
import 'package:mobile_flutter_lab1/data/services/local_storage_service.dart';
import 'package:mobile_flutter_lab1/data/services/mqtt_service.dart';
import 'package:mobile_flutter_lab1/data/services/workshop_api_service.dart';
import 'package:mobile_flutter_lab1/routes/app_routes.dart';
import 'package:mobile_flutter_lab1/widgets/machine_events_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const primaryDark = Color(0xFF1F2937);
  static const primaryBlue = Color(0xFF2563EB);
  static const softBlue = Color(0xFFDBEAFE);
  static const textMuted = Color(0xFF6B7280);
  static const danger = Color(0xFFDC2626);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _localStorageService = LocalStorageService();
  final _connectivityService = ConnectivityService();
  final _mqttRepository = MqttRepositoryImpl(MqttService());
  late final _workshopRepository = WorkshopRepositoryImpl(
    WorkshopApiService(),
    _localStorageService,
  );

  late final LocalAuthRepository _authRepository =
      LocalAuthRepository(_localStorageService);

  static const _mqttTopic = 'latheguard/status';

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  StreamSubscription<String>? _mqttSubscription;
  StreamSubscription<bool>? _mqttConnectionSubscription;
  Timer? _mqttStatusTimer;

  bool _hasInternet = true;
  bool _isLoading = true;
  bool _isConnectingMqtt = false;
  bool _isWaitingForFreshPayload = false;
  String? _mqttStatusLabel;
  Color? _mqttStatusColor;

  UserModel? _currentUser;

  String _floodStatus = 'Safe';
  String _latheSpeed = '65';
  String _lastEvent = 'Waiting for MQTT updates...';

  @override
  void initState() {
    super.initState();
    _loadUser();
    _restoreLastMqttPayload();
    _checkInternet();
    _listenToInternet();
    _listenToMqttConnection();
    _connectToMqtt();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _mqttSubscription?.cancel();
    _mqttConnectionSubscription?.cancel();
    _mqttStatusTimer?.cancel();
    _mqttRepository.disconnect();
    super.dispose();
  }

  Future<void> _loadUser() async {
    final user = await _authRepository.getCurrentUser();

    if (!mounted) {
      return;
    }

    setState(() {
      _currentUser = user;
      _isLoading = false;
    });

    if (user != null) {
      await _syncUserProfile(user);
    }
  }

  Future<void> _checkInternet() async {
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (!mounted) {
      return;
    }

    setState(() {
      _hasInternet = hasInternet;
    });

    if (!hasInternet) {
      _updateLastEvent(
        'You are offline now, so the dashboard is showing '
        'the last saved state.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Limited functionality.'),
        ),
      );
    }
  }

  Future<void> _restoreLastMqttPayload() async {
    final savedPayload = await _localStorageService.getLastMqttPayload();

    if (!mounted || savedPayload == null) {
      return;
    }

    _applyPayload(
      savedPayload,
      persistPayload: false,
      fallbackEvent: 'Loaded the last known MQTT state from device storage.',
    );
  }

  void _listenToMqttConnection() {
    _mqttConnectionSubscription = _mqttRepository.connectionStream.listen((
      isConnected,
    ) {
      if (!mounted) {
        return;
      }

      if (isConnected) {
        _updateLastEvent(
          'Connection restored. Waiting for the next '
          'live update from the machine.',
        );
        return;
      }

      if (_hasInternet) {
        _showPersistentMqttStatus(
          'Connecting...',
          color: Colors.orange,
        );
        _updateLastEvent(
          'The broker connection dropped, trying to reconnect '
          'in the background.',
        );
      }
    });
  }

  void _listenToInternet() {
    _connectivitySubscription =
        _connectivityService.connectivityStream.listen((result) async {
      final hasInternet = !result.contains(ConnectivityResult.none);

      if (!mounted) {
        return;
      }

      final wasOffline = !_hasInternet;

      setState(() {
        _hasInternet = hasInternet;
      });

      if (!hasInternet) {
        _clearMqttStatus();
        _mqttRepository.disconnect();

        _updateLastEvent(
          'Internet connection was lost, so live MQTT updates '
          'are paused for now.',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internet connection lost.'),
          ),
        );
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Internet connection restored.'),
        ),
      );

      if (wasOffline) {
        await _reconnectMqtt();
      }
    });
  }

  Future<void> _syncUserProfile(UserModel user) async {
    final syncedUser = await _workshopRepository.syncUserProfile(user);

    if (!mounted || syncedUser == null) {
      return;
    }

    setState(() {
      _currentUser = syncedUser;
    });
  }

  Future<void> _reconnectMqtt() async {
    _mqttSubscription?.cancel();
    _mqttRepository.disconnect();
    await Future<void>.delayed(const Duration(milliseconds: 500));
    await _connectToMqtt(forceReconnect: true);
  }

  Future<void> _connectToMqtt({bool forceReconnect = false}) async {
    if (!_hasInternet || _isConnectingMqtt) {
      return;
    }

    if (!forceReconnect && _mqttRepository.isConnected) {
      return;
    }

    _isConnectingMqtt = true;
    _isWaitingForFreshPayload = true;
    _showPersistentMqttStatus(
      'Connecting...',
      color: Colors.orange,
    );

    if (forceReconnect) {
      _mqttSubscription?.cancel();
      _mqttRepository.disconnect();
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }

    final isConnected = await _mqttRepository.connect();
    _isConnectingMqtt = false;

    if (!mounted) {
      return;
    }

    if (!isConnected) {
      _updateLastEvent(
        'The app could not reach the MQTT broker yet. '
        'It will try again when the network changes.',
      );
      _showPersistentMqttStatus(
        'Connecting...',
        color: Colors.orange,
      );
      return;
    }

    await _mqttRepository.subscribe(_mqttTopic);
    await _mqttSubscription?.cancel();

    _mqttSubscription = _mqttRepository.messagesStream.listen(_applyPayload);
  }

  Future<void> _applyPayload(
    String payload, {
    bool persistPayload = true,
    String? fallbackEvent,
  }) async {
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final flood = decoded['flood']?.toString() ?? _floodStatus;
      final speed = decoded['speed']?.toString() ?? _latheSpeed;

      if (!mounted) {
        return;
      }

      setState(() {
        _floodStatus = flood;
        _latheSpeed = speed;
        _lastEvent = fallbackEvent ?? _buildPayloadEvent(flood, speed);
      });

      if (_isWaitingForFreshPayload) {
        final hasFreshPayload = persistPayload;

        if (hasFreshPayload) {
          _isWaitingForFreshPayload = false;
          _showTransientMqttStatus(
            'Connected!',
            color: Colors.green,
          );
        }
      }

      if (persistPayload) {
        await _localStorageService.saveLastMqttPayload(payload);
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      _updateLastEvent(
        'A message arrived from MQTT, but its format was invalid '
        'and was ignored.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid MQTT payload format.'),
        ),
      );
    }
  }

  void _updateLastEvent(String value) {
    if (!mounted) {
      return;
    }

    setState(() {
      _lastEvent = value;
    });
  }

  String _buildPayloadEvent(String flood, String speed) {
    return 'Fresh data received: '
        'flood sensor is $flood, lathe speed is $speed%.';
  }

  void _showPersistentMqttStatus(
    String label, {
    required Color color,
  }) {
    _mqttStatusTimer?.cancel();

    if (!mounted) {
      return;
    }

    setState(() {
      _mqttStatusLabel = label;
      _mqttStatusColor = color;
    });
  }

  void _showTransientMqttStatus(
    String label, {
    required Color color,
  }) {
    _showPersistentMqttStatus(label, color: color);
    _mqttStatusTimer = Timer(const Duration(seconds: 1), _clearMqttStatus);
  }

  void _clearMqttStatus() {
    _mqttStatusTimer?.cancel();
    _mqttStatusTimer = null;

    if (!mounted) {
      return;
    }

    setState(() {
      _mqttStatusLabel = null;
      _mqttStatusColor = null;
    });
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
                Text(
                  'Welcome, ${_currentUser?.fullName ?? 'User'}',
                  style: TextStyle(
                    fontSize: context.sp(24),
                    fontWeight: FontWeight.bold,
                    color: HomeScreen.primaryDark,
                  ),
                ),
                SizedBox(height: context.sp(6)),
                Text(
                  _currentUser?.email ?? '',
                  style: TextStyle(
                    fontSize: context.sp(14),
                    color: HomeScreen.textMuted,
                  ),
                ),
                if (!_hasInternet)
                  Padding(
                    padding: EdgeInsets.only(top: context.sp(8)),
                    child: Text(
                      'Offline mode',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                if (_mqttStatusLabel != null)
                  Padding(
                    padding: EdgeInsets.only(top: context.sp(8)),
                    child: Text(
                      _mqttStatusLabel!,
                      style: TextStyle(
                        color: _mqttStatusColor,
                        fontSize: context.sp(14),
                      ),
                    ),
                  ),
                SizedBox(height: context.sp(20)),
                Container(
                  padding: EdgeInsets.all(context.sp(18)),
                  decoration: BoxDecoration(
                    color: HomeScreen.primaryDark,
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
                          color: HomeScreen.softBlue,
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
                    Expanded(
                      child: _StatusCard(
                        title: 'Flood sensor',
                        value: _floodStatus,
                        valueColor: HomeScreen.primaryBlue,
                      ),
                    ),
                    SizedBox(width: context.sp(12)),
                    Expanded(
                      child: _StatusCard(
                        title: 'Lathe speed',
                        value: '$_latheSpeed%',
                        valueColor: HomeScreen.primaryBlue,
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
                        valueColor: HomeScreen.primaryBlue,
                      ),
                    ),
                    SizedBox(width: context.sp(12)),
                    const Expanded(
                      child: _StatusCard(
                        title: 'Emergency',
                        value: 'Normal',
                        valueColor: HomeScreen.primaryBlue,
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
                      backgroundColor: HomeScreen.primaryBlue,
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
                      foregroundColor: HomeScreen.primaryDark,
                      padding: EdgeInsets.symmetric(vertical: context.sp(16)),
                      side: const BorderSide(color: HomeScreen.primaryDark),
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
                      backgroundColor: HomeScreen.danger,
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
                    'Last event: $_lastEvent',
                    style: TextStyle(
                      fontSize: context.sp(15),
                      color: HomeScreen.textMuted,
                    ),
                  ),
                ),
                SizedBox(height: context.sp(24)),
                MachineEventsSection(
                  hasInternet: _hasInternet,
                  repository: _workshopRepository,
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
              color: HomeScreen.textMuted,
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
