import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/utils/image_path.dart';
import 'package:hand_cricke/utils/image_provider.dart';

enum GameEventType {
  battingStarted,
  sixer,
  wicket,
  battingEnded,
}

class GameEventOverlay extends StatefulWidget {
  final GameEventType eventType;
  final VoidCallback? onDismissed;
  final Widget? child;
  final Duration displayDuration;

  const GameEventOverlay({
    super.key,
    required this.eventType,
    this.onDismissed,
    this.child,
    this.displayDuration = const Duration(seconds: 1),
  });

  @override
  State<GameEventOverlay> createState() => _GameEventOverlayState();
}

class _GameEventOverlayState extends State<GameEventOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    // Schedule dismiss after the display duration
    Future.delayed(widget.displayDuration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismissed?.call();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        color: Colors.black.withOpacity(0.8),
        child: Center(
          child: _buildEventContent(),
        ),
      ),
    );
  }

  Widget _buildEventContent() {
    switch (widget.eventType) {
      case GameEventType.sixer:
        return _buildGameEventDetail(ImagePath.sixerImage);
      case GameEventType.wicket:
        return _buildGameEventDetail(ImagePath.outImage);
      case GameEventType.battingStarted:
        return _buildGameEventDetail(ImagePath.batting);
      case GameEventType.battingEnded:
        return _buildGameEventDetail(ImagePath.gameDefendImage);
    }
  }

  Widget _buildGameEventDetail(String imagePath) {
    return Column(
      // alignment: Alignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageWidget.getImage(
          imagePath,
          height: 200.h,
          width: 200.w,
        ),
        if (widget.child != null) ...[
          widget.child!,
        ]
      ],
    );
  }
}
