import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  final VoidCallback? onTimerComplete;
  final int durationInSeconds;
  final bool shouldReset;
  final bool isVisible;

  const GameTimer({
    super.key,
    this.onTimerComplete,
    this.durationInSeconds = 10,
    this.shouldReset = false,
    this.isVisible = true,
  });

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.durationInSeconds),
    );

    _animation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onTimerComplete?.call();
      }
    });

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  void resetTimer() {
    _controller.reset();
    if (widget.isVisible) {
      _controller.forward();
    }
  }

  void pauseTimer() {
    if (!_isPaused) {
      _controller.stop();
      _isPaused = true;
    }
  }

  void resumeTimer() {
    if (_isPaused) {
      _controller.forward();
      _isPaused = false;
    }
  }

  @override
  void didUpdateWidget(GameTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shouldReset != oldWidget.shouldReset && widget.shouldReset) {
      resetTimer();
    }
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible) {
      return const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                value: _animation.value,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 5,
              ),
            ),
            Text(
              '${(_animation.value * widget.durationInSeconds).ceil()}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
