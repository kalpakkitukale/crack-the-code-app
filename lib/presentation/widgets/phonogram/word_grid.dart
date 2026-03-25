/// WordGrid — Responsive grid of tappable word cards grouped by difficulty.
///
/// Layout per age level:
///   | Level    | Columns | Card Height | Emoji Size | Word Font |
///   |----------|---------|-------------|------------|-----------|
///   | Tiny     | 1       | 72          | 32         | 22        |
///   | Starter  | 2       | 64          | 28         | 20        |
///   | Explorer | 3       | 56          | 24         | 18        |
///   | Master   | 3       | 52          | 20         | 16        |
///
/// Section headers:
///   - "EASY WORDS" / "MORE WORDS" / "CHALLENGE WORDS"
///   - Left aligned, 11sp, FontWeight.w700, letterSpacing 2.0
///   - Colored dot (6x6) prefix matching difficulty badge color
///   - Bottom margin: 8
///
/// Word cards:
///   - Background: wordCardBackground (#1A1730)
///   - Border: 1px category color at 12%, border-radius 12
///   - Padding: horizontal 12, vertical 8
///   - Row: [emoji (left)] [highlighted word (center)] [play icon (right, 20sp)]
///   - Tap: triggers onWordTap callback
///   - Long press: triggers audio playback
///   - Hover (desktop): border brightens to 25% category color
///
/// Animation:
///   - Section appears with staggered FadeIn (50ms per card)
///   - Card tap: scale down to 0.97 for 100ms, then expand selected card
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_colors.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/highlighted_word.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/expanded_word_card.dart';

class WordGrid extends StatefulWidget {
  final PhonogramSound sound;
  final PhonogramCategory category;
  final AgeLevel ageLevel;
  final ValueChanged<PhonogramWord>? onPlayAudio;

  const WordGrid({
    super.key,
    required this.sound,
    required this.category,
    required this.ageLevel,
    this.onPlayAudio,
  });

  @override
  State<WordGrid> createState() => _WordGridState();
}

class _WordGridState extends State<WordGrid>
    with SingleTickerProviderStateMixin {
  /// Key of the currently expanded word card, or null
  String? _expandedWordKey;

  late final AnimationController _staggerController;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void didUpdateWidget(covariant WordGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sound.id != widget.sound.id) {
      _expandedWordKey = null;
      _staggerController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = <_WordSection>[];

    if (widget.sound.easyWords.isNotEmpty) {
      sections.add(_WordSection(
        label: 'EASY WORDS',
        dotColor: PhonogramColors.easyBadge,
        words: widget.sound.easyWords,
      ));
    }
    if (widget.sound.moreWords.isNotEmpty) {
      sections.add(_WordSection(
        label: 'MORE WORDS',
        dotColor: PhonogramColors.moreBadge,
        words: widget.sound.moreWords,
      ));
    }
    if (widget.sound.challengeWords.isNotEmpty) {
      sections.add(_WordSection(
        label: 'CHALLENGE WORDS',
        dotColor: PhonogramColors.challengeBadge,
        words: widget.sound.challengeWords,
      ));
    }

    if (sections.isEmpty) {
      return _EmptyState(ageLevel: widget.ageLevel);
    }

    return AnimatedBuilder(
      animation: _staggerController,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int sIdx = 0; sIdx < sections.length; sIdx++) ...[
              if (sIdx > 0) const SizedBox(height: 24),
              _buildSectionHeader(sections[sIdx]),
              const SizedBox(height: 8),
              _buildWordGridForSection(sections[sIdx], sIdx),
            ],
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(_WordSection section) {
    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: section.dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          section.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.7),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 0.5,
            color: PhonogramColors.cardBorder.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildWordGridForSection(_WordSection section, int sectionIndex) {
    final columns = _columnsForAge;

    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 8.0;
        final totalSpacing = spacing * (columns - 1);
        final cardWidth = (constraints.maxWidth - totalSpacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: 8,
          children: [
            for (int i = 0; i < section.words.length; i++) ...[
              _buildWordItem(
                section.words[i],
                cardWidth,
                sectionIndex,
                i,
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildWordItem(
    PhonogramWord word,
    double cardWidth,
    int sectionIndex,
    int itemIndex,
  ) {
    final key = '${sectionIndex}_${itemIndex}_${word.word}';
    final isExpanded = _expandedWordKey == key;

    // Stagger delay: 50ms per card
    final totalIndex = sectionIndex * 10 + itemIndex;
    final delay = (totalIndex * 0.08).clamp(0.0, 0.8);
    final end = (delay + 0.2).clamp(0.0, 1.0);
    final opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: Interval(delay, end, curve: Curves.easeOut),
      ),
    );

    return FadeTransition(
      opacity: opacity,
      child: SizedBox(
        width: isExpanded ? double.infinity : cardWidth,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: isExpanded
              ? ExpandedWordCard(
                  key: ValueKey('expanded_$key'),
                  word: word,
                  category: widget.category,
                  ageLevel: widget.ageLevel,
                  onClose: () => setState(() => _expandedWordKey = null),
                  onPlayAudio: widget.onPlayAudio != null
                      ? () => widget.onPlayAudio!(word)
                      : null,
                )
              : _CompactWordCard(
                  key: ValueKey('compact_$key'),
                  word: word,
                  category: widget.category,
                  ageLevel: widget.ageLevel,
                  onTap: () => setState(() => _expandedWordKey = key),
                  onLongPress: widget.onPlayAudio != null
                      ? () => widget.onPlayAudio!(word)
                      : null,
                ),
        ),
      ),
    );
  }

  int get _columnsForAge {
    switch (widget.ageLevel) {
      case AgeLevel.tiny:
        return 1;
      case AgeLevel.starter:
        return 2;
      case AgeLevel.explorer:
      case AgeLevel.master:
        return 3;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Private Sub-Widgets
// ═════════════════════════════════════════════════════════════════════════════

class _WordSection {
  final String label;
  final Color dotColor;
  final List<PhonogramWord> words;

  const _WordSection({
    required this.label,
    required this.dotColor,
    required this.words,
  });
}

/// Compact word card — the default state in the grid.
/// Specs:
///   - Background: wordCardBackground (#1A1730)
///   - Border: 1px category color at 12%, border-radius 12
///   - Height: age-adaptive (see _cardHeight)
///   - Padding: horizontal 12, vertical 8
///   - Row: emoji | highlighted word | play icon
///   - Tap scale: 0.97 for 100ms
class _CompactWordCard extends StatefulWidget {
  final PhonogramWord word;
  final PhonogramCategory category;
  final AgeLevel ageLevel;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _CompactWordCard({
    super.key,
    required this.word,
    required this.category,
    required this.ageLevel,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<_CompactWordCard> createState() => _CompactWordCardState();
}

class _CompactWordCardState extends State<_CompactWordCard> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final accent = PhonogramColors.primaryFor(widget.category);
    final borderOpacity = _isHovered ? 0.3 : 0.12;

    return Semantics(
      button: true,
      label: '${widget.word.emoji} ${widget.word.word}. Tap to see details.',
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          onLongPress: widget.onLongPress,
          child: AnimatedScale(
            scale: _isPressed ? 0.97 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              height: _cardHeight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: PhonogramColors.wordCardBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accent.withValues(alpha: borderOpacity),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Text(
                    widget.word.emoji,
                    style: TextStyle(fontSize: _emojiSize),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: HighlightedWord(
                      word: widget.word.word,
                      highlightStart: widget.word.highlightStart,
                      highlightLength: widget.word.highlightLength,
                      category: widget.category,
                      fontSize: HighlightedWord.fontSizeForAge(widget.ageLevel),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Icon(
                    Icons.volume_up_rounded,
                    size: 18,
                    color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get _cardHeight {
    switch (widget.ageLevel) {
      case AgeLevel.tiny:
        return 72;
      case AgeLevel.starter:
        return 64;
      case AgeLevel.explorer:
        return 56;
      case AgeLevel.master:
        return 52;
    }
  }

  double get _emojiSize {
    switch (widget.ageLevel) {
      case AgeLevel.tiny:
        return 32;
      case AgeLevel.starter:
        return 28;
      case AgeLevel.explorer:
        return 24;
      case AgeLevel.master:
        return 20;
    }
  }
}

/// Empty state when no words exist for the selected sound.
class _EmptyState extends StatelessWidget {
  final AgeLevel ageLevel;

  const _EmptyState({required this.ageLevel});

  @override
  Widget build(BuildContext context) {
    final isYoung =
        ageLevel == AgeLevel.tiny || ageLevel == AgeLevel.starter;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: isYoung ? 48 : 40,
              color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              isYoung
                  ? 'No words here yet!'
                  : 'No example words available for this sound.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isYoung ? 16 : 14,
                color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
