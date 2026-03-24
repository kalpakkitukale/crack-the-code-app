import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/mastery_data.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';

class PhonogramCollectionTile extends StatefulWidget {
  final Phonogram phonogram;
  final bool isDiscovered;
  final MasteryLevel masteryLevel;
  final double size;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PhonogramCollectionTile({
    super.key,
    required this.phonogram,
    required this.isDiscovered,
    required this.masteryLevel,
    this.size = 64,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<PhonogramCollectionTile> createState() =>
      _PhonogramCollectionTileState();
}

class _PhonogramCollectionTileState extends State<PhonogramCollectionTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(PhonogramCollectionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isDiscovered && widget.isDiscovered) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isDiscovered) {
      return _buildMysteryTile();
    }
    return _buildDiscoveredTile();
  }

  Widget _buildMysteryTile() {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(widget.size * 0.2),
            border: Border.all(
                color: Colors.white.withValues(alpha: 0.1), width: 1.5),
          ),
          child: Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: widget.size * 0.4,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveredTile() {
    final color = widget.phonogram.color;
    final isMastered = widget.masteryLevel == MasteryLevel.mastered;

    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(widget.size * 0.2),
            border: Border.all(
              color: isMastered
                  ? const Color(0xFFFFD700)
                  : color.withValues(alpha: 0.4),
              width: isMastered ? 2.5 : 1.5,
            ),
            boxShadow: isMastered
                ? [
                    BoxShadow(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.3),
                        blurRadius: 8)
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.phonogram.text,
                style: TextStyle(
                  fontSize: widget.size * 0.32,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              _buildMasteryIndicator(color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasteryIndicator(Color color) {
    if (widget.masteryLevel == MasteryLevel.mastered) {
      return const Icon(Icons.star, size: 12, color: Color(0xFFFFD700));
    }

    final dots = widget.masteryLevel.index; // 0=unheard, 1=heard, etc.
    if (dots <= 0) return const SizedBox(height: 12);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        dots.clamp(0, 3),
        (_) => Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
