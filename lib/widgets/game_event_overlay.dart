import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hand_cricke/utils/image_path.dart';
import 'package:hand_cricke/utils/image_provider.dart';

enum GameEventType {
  sixer,
  wicket,
}

class GameEventOverlay extends StatefulWidget {
  final GameEventType eventType;
  final VoidCallback? onDismissed;
  final Duration displayDuration;

  const GameEventOverlay({
    super.key,
    required this.eventType,
    this.onDismissed,
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
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: _buildEventContent(),
        ),
      ),
    );
  }

  Widget _buildEventContent() {
    switch (widget.eventType) {
      case GameEventType.sixer:
        return _buildSixerContent();
      case GameEventType.wicket:
        return _buildWicketContent();
    }
  }

  Widget _buildSixerContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageWidget.getImage(
          ImagePath.sixerImage,
          height: 200.h,
          width: 200.w,
        ),
      ],
    );
  }

  Widget _buildWicketContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        ImageWidget.getImage(
          ImagePath.wicketBackground,
          height: 200.h,
          width: 200.w,
        ),
      ],
    );
  }
}
