import 'package:flutter/material.dart';
import '../services/inactivity_service.dart';

class ActivityDetector extends StatefulWidget {
  final Widget child;

  const ActivityDetector({super.key, required this.child});

  @override
  State<ActivityDetector> createState() => _ActivityDetectorState();
}

class _ActivityDetectorState extends State<ActivityDetector> {
  @override
  void initState() {
    super.initState();
    InactivityService().resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => InactivityService().resetTimer(),
      onPanDown: (_) => InactivityService().resetTimer(),
      onScaleStart: (_) => InactivityService().resetTimer(),
      onLongPress: () => InactivityService().resetTimer(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          InactivityService().resetTimer();
          return false;
        },
        child: FocusScope(
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              InactivityService().resetTimer();
            }
          },
          child: widget.child,
        ),
      ),
    );
  }
}