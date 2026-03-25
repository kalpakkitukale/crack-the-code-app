/// ExpandedWordCard — Shown when a user taps a word in the WordGrid.
///
/// Animates open (300ms, Curves.easeOutCubic) to reveal:
///   1. Phonogram breakdown tiles with arrows: [SH] -> [I] -> [P]
///   2. Age-adaptive meaning text
///   3. Example sentence (italic)
///   4. Spelling note with lightbulb icon
///   5. Close button (top right)
///
/// Visual spec:
///   - Background: cardSurfaceElevated (#1C1938)
///   - Border: 1px category color at 20%, border-radius 16
///   - Padding: 20
///   - Inner content gap: 12
///
/// Breakdown tiles:
///   - Each tile: 48x40 (tiny/starter), 40x34 (explorer/master)
///   - Background: category color at 15%
///   - Border: 1px category color at 30%
///   - Border-radius: 8
///   - Text: 16sp (tiny/starter), 14sp (explorer/master), bold, white
///   - The tile matching the current phonogram gets the full category gradient
///   - Arrow between tiles: 12sp, category color at 50%
///
/// Spelling note:
///   - Row with lightbulb icon (18sp, gold) + text (13sp, secondary)
///   - Background: gold at 8%, border-radius 8, padding 10
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_colors.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/highlighted_word.dart';

class ExpandedWordCard extends StatelessWidget {
  final PhonogramWord word;
  final PhonogramCategory category;
  final AgeLevel ageLevel;
  final VoidCallback onClose;
  final VoidCallback? onPlayAudio;

  const ExpandedWordCard({
    super.key,
    required this.word,
    required this.category,
    required this.ageLevel,
    required this.onClose,
    this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    final accent = PhonogramColors.primaryFor(category);
    final gradient = PhonogramColors.gradientFor(category);

    return Semantics(
      label: 'Expanded detail for the word ${word.word}',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: PhonogramColors.cardSurfaceElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accent.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Header: emoji + word + close button ─────────────
            Row(
              children: [
                Text(
                  word.emoji,
                  style: TextStyle(
                    fontSize: _emojiSize,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HighlightedWord(
                    word: word.word,
                    highlightStart: word.highlightStart,
                    highlightLength: word.highlightLength,
                    category: category,
                    fontSize:
                        HighlightedWord.fontSizeForAge(ageLevel, expanded: true),
                    textAlign: TextAlign.left,
                  ),
                ),
                // Play button
                if (onPlayAudio != null)
                  _IconCircleButton(
                    icon: Icons.volume_up_rounded,
                    color: accent,
                    size: 32,
                    iconSize: 16,
                    onTap: onPlayAudio!,
                    semanticLabel: 'Play pronunciation of ${word.word}',
                  ),
                const SizedBox(width: 8),
                // Close button
                _IconCircleButton(
                  icon: Icons.close_rounded,
                  color: PhonogramColors.cardTextSecondary,
                  size: 32,
                  iconSize: 16,
                  onTap: onClose,
                  semanticLabel: 'Close expanded view',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ─── 1. Phonogram breakdown tiles ────────────────────
            if (word.breakdown.isNotEmpty)
              _BreakdownRow(
                breakdown: word.breakdown,
                phonogramLetters: word.phonogramLetters,
                accent: accent,
                gradient: gradient,
                ageLevel: ageLevel,
              ),

            if (word.breakdown.isNotEmpty) const SizedBox(height: 16),

            // ─── 2. Age-adaptive meaning ─────────────────────────
            if (word.meanings.containsKey(ageLevel))
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  word.meanings[ageLevel]!,
                  style: TextStyle(
                    fontSize: _meaningFontSize,
                    fontWeight: FontWeight.w400,
                    color: PhonogramColors.cardTextPrimary.withValues(alpha: 0.87),
                    height: 1.5,
                  ),
                ),
              ),

            // ─── 3. Example sentence ─────────────────────────────
            if (word.sentence != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.format_quote_rounded,
                      size: 16,
                      color: accent.withValues(alpha: 0.5),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        word.sentence!,
                        style: TextStyle(
                          fontSize: _sentenceFontSize,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          color: PhonogramColors.cardTextSecondary
                              .withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // ─── 4. Spelling note ────────────────────────────────
            if (word.spellingNote != null) _SpellingNote(note: word.spellingNote!),
          ],
        ),
      ),
    );
  }

  double get _emojiSize {
    switch (ageLevel) {
      case AgeLevel.tiny:
        return 36;
      case AgeLevel.starter:
        return 32;
      case AgeLevel.explorer:
        return 28;
      case AgeLevel.master:
        return 24;
    }
  }

  double get _meaningFontSize {
    switch (ageLevel) {
      case AgeLevel.tiny:
      case AgeLevel.starter:
        return 16;
      case AgeLevel.explorer:
      case AgeLevel.master:
        return 14;
    }
  }

  double get _sentenceFontSize {
    switch (ageLevel) {
      case AgeLevel.tiny:
      case AgeLevel.starter:
        return 15;
      case AgeLevel.explorer:
      case AgeLevel.master:
        return 13;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Private Sub-Widgets
// ═════════════════════════════════════════════════════════════════════════════

/// Circular icon button used for play/close actions.
class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconSize;
  final VoidCallback onTap;
  final String semanticLabel;

  const _IconCircleButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.iconSize,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.12),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 0.5,
            ),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: iconSize, color: color),
        ),
      ),
    );
  }
}

/// Row of phoneme breakdown tiles with arrows between them.
/// The tile matching [phonogramLetters] receives the full gradient fill.
class _BreakdownRow extends StatelessWidget {
  final List<String> breakdown;
  final String phonogramLetters;
  final Color accent;
  final List<Color> gradient;
  final AgeLevel ageLevel;

  const _BreakdownRow({
    required this.breakdown,
    required this.phonogramLetters,
    required this.accent,
    required this.gradient,
    required this.ageLevel,
  });

  @override
  Widget build(BuildContext context) {
    final tileHeight = _isLargeAge ? 40.0 : 34.0;
    final tileFontSize = _isLargeAge ? 16.0 : 14.0;
    final tileHPadding = _isLargeAge ? 16.0 : 12.0;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < breakdown.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 12,
                  color: accent.withValues(alpha: 0.5),
                ),
              ),
            _BreakdownTile(
              text: breakdown[i],
              isPhonogram:
                  breakdown[i].toUpperCase() == phonogramLetters.toUpperCase(),
              accent: accent,
              gradient: gradient,
              height: tileHeight,
              fontSize: tileFontSize,
              horizontalPadding: tileHPadding,
            ),
          ],
        ],
      ),
    );
  }

  bool get _isLargeAge =>
      ageLevel == AgeLevel.tiny || ageLevel == AgeLevel.starter;
}

/// A single breakdown tile — e.g. [SH], [I], [P].
class _BreakdownTile extends StatelessWidget {
  final String text;
  final bool isPhonogram;
  final Color accent;
  final List<Color> gradient;
  final double height;
  final double fontSize;
  final double horizontalPadding;

  const _BreakdownTile({
    required this.text,
    required this.isPhonogram,
    required this.accent,
    required this.gradient,
    required this.height,
    required this.fontSize,
    required this.horizontalPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: isPhonogram ? LinearGradient(colors: gradient) : null,
        color: isPhonogram ? null : accent.withValues(alpha: 0.15),
        border: isPhonogram
            ? null
            : Border.all(color: accent.withValues(alpha: 0.3), width: 1),
        boxShadow: isPhonogram
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w700,
          color: isPhonogram ? Colors.white : accent,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

/// Spelling note with lightbulb icon.
/// Background: gold at 8%, border-radius 8, padding 10.
class _SpellingNote extends StatelessWidget {
  final String note;

  const _SpellingNote({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: PhonogramColors.gold.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: PhonogramColors.gold.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_rounded,
            size: 18,
            color: PhonogramColors.gold.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              note,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
