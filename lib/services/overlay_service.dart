import 'package:flutter/material.dart';
import 'package:hand_cricke/widgets/game_event_overlay.dart';

class OverlayService {
  // Singleton pattern
  static final OverlayService _instance = OverlayService._internal();
  factory OverlayService() => _instance;
  OverlayService._internal();

  OverlayEntry? _currentOverlay;

  // Display a game event overlay
  void showGameEventOverlay(
    BuildContext context,
    GameEventType eventType,
  ) {
    // Remove any existing overlay
    hideCurrentOverlay();

    // Create and insert the new overlay
    _currentOverlay = OverlayEntry(
      builder: (context) => GameEventOverlay(
        eventType: eventType,
        onDismissed: hideCurrentOverlay,
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  // Hide the current overlay if it exists
  void hideCurrentOverlay() {
    if (_currentOverlay != null) {
      _currentOverlay!.remove();
      _currentOverlay = null;
    }
  }
}
