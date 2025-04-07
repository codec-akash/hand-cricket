import 'dart:async';
import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final VoidCallback? onTimerComplete;
  final int durationInSeconds;

  const GameTimer({
    Key? key,
    this.onTimerComplete,
    this.durationInSeconds = 10,
  }) : super(key: key);

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer _timer;
  int _currentSeconds = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _currentSeconds = widget.durationInSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_currentSeconds > 0) {
          _currentSeconds--;
        } else {
          _timer.cancel();
          widget.onTimerComplete?.call();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Time's up!")));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 60,
          width: 60,
          child: CircularProgressIndicator(
            value: _currentSeconds / widget.durationInSeconds,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 5,
          ),
        ),
        Text(
          '$_currentSeconds',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
