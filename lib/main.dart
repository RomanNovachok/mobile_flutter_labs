import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speed Command Game',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpeedGamePage(title: 'Speed Command Game'),
    );
  }
}

class SpeedGamePage extends StatefulWidget {
  const SpeedGamePage({required this.title, super.key});

  final String title;

  @override
  State<SpeedGamePage> createState() => _SpeedGamePageState();
}

class _SpeedGamePageState extends State<SpeedGamePage> {
  static const int _minSpeed = 0;
  static const int _maxSpeed = 100;

  final TextEditingController _controller = TextEditingController();

  int _speed = 0;
  String _message = 'We’re not getting anywhere like this. Hit the gas! 🚗';
  String _status = 'Type a command like: boost 15, brake 10, set 50, stop';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetSpeed() {
    setState(() {
      _speed = 0;
      _message = _messageForSpeed(_speed);
      _status = 'Restarted. Speed reset to 0.';
    });
  }

  void _applyCommand() {
    final raw = _controller.text.trim();
    if (raw.isEmpty) {
      setState(() {
        _status = 'Type something 🙂 Example: boost 10';
      });
      return;
    }

    if (raw == 'deer!' || raw == 'Deer!') {
      setState(() {
        _speed = 0;
        _message = 'Deer! Emergency stop! 🛑🦌';
        _status = 'Secret phrase activated.';
        _controller.clear();
      });
      return;
    }

    final parts = raw.split(RegExp(r'\s+'));
    final command = parts.first.toLowerCase();

    int? value;
    if (parts.length >= 2) {
      value = int.tryParse(parts[1]);
    }

    switch (command) {
      case 'boost':
        if (value == null) {
          _setError('I need a number: boost 15');
          return;
        }
        _changeSpeedBy(value);
        _setOk('Boosted by $value.');
        break;

      case 'brake':
        if (value == null) {
          _setError('I need a number: brake 20');
          return;
        }
        _changeSpeedBy(-value);
        _setOk('Braked by $value.');
        break;

      case 'set':
        if (value == null) {
          _setError('I need a number: set 50');
          return;
        }
        _setSpeed(value);
        _setOk('Speed set to $value (clamped to 0..100).');
        break;

      case 'stop':
        _setSpeed(0);
        _setOk('Stopped.');
        break;

      default:
        _setError('Unknown command. Try: boost 10, brake 10, set 50, stop.');
        return;
    }

    setState(() {
      _message = _messageForSpeed(_speed);
      _controller.clear();
    });
  }

  void _changeSpeedBy(int delta) {
    setState(() {
      _speed = (_speed + delta).clamp(_minSpeed, _maxSpeed);
    });
  }

  void _setSpeed(int value) {
    setState(() {
      _speed = value.clamp(_minSpeed, _maxSpeed);
    });
  }

  void _setOk(String text) {
    setState(() {
      _status = text;
    });
  }

  void _setError(String text) {
    setState(() {
      _status = text;
    });
  }

  String _messageForSpeed(int speed) {
    if (speed == 0) {
      return 'We’re not getting anywhere like this. Hit the gas! 🚗';
    }
    if (speed >= 1 && speed <= 30) {
      return 'The turtle is faster than you! 🐢';
    }
    if (speed >= 31 && speed <= 60) {
      return "Perfect speed, you're a good driver! 😎";
    }
    if (speed >= 61 && speed <= 99) {
      return "It's dangerous, slow down! 😱";
    }
    return "Maximum speed! Even the car tells you it's too fast! 😅";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: _resetSpeed,
            tooltip: 'Restart',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Text(
              'Speed: $_speed / $_maxSpeed',
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Text(
                _message,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _applyCommand(),
              decoration: const InputDecoration(
                labelText: 'Command',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _applyCommand,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Run command'),
            ),
            const SizedBox(height: 12),
            Text(
              _status,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
