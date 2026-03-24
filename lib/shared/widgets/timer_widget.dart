import 'dart:async';

import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final int totalSeconds;
  final VoidCallback onTimeUp;
  final ValueChanged<int>? onTick;
  final double size;

  const TimerWidget({
    super.key,
    required this.totalSeconds,
    required this.onTimeUp,
    this.onTick,
    this.size = 60,
  });

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.totalSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining <= 0) {
        _timer?.cancel();
        widget.onTimeUp();
        return;
      }
      setState(() => _remaining--);
      widget.onTick?.call(_remaining);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color get _color {
    final ratio = _remaining / widget.totalSeconds;
    if (ratio > 0.5) return const Color(0xFF4CAF50);
    if (ratio > 0.25) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  String get _text {
    final min = _remaining ~/ 60;
    final sec = _remaining % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / widget.totalSeconds;
    final isPulsing = _remaining <= 10;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedScale(
        scale: isPulsing ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 500),
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: progress,
              strokeWidth: 4,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(_color),
            ),
            Text(
              _text,
              style: TextStyle(
                fontSize: widget.size * 0.22,
                fontWeight: FontWeight.w700,
                color: _color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
