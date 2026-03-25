/// HighlightedWord Widget
///
/// Displays a word with the phonogram portion colored in the category accent
/// color while the remaining letters appear in a neutral color.
///
/// Handles phonogram at any position: start (SHIP), middle (FISHER), end (FISH).
///
/// Usage:
///   HighlightedWord(
///     word: 'SHIP',
///     highlightStart: 0,
///     highlightLength: 2,
///     category: PhonogramCategory.team,
///   )
///
/// Specs:
///   - Highlighted portion: category color, FontWeight.w800
///   - Normal portion: white at 87% opacity, FontWeight.w600
///   - Letter spacing: 1.5 (mobile), 2.0 (tablet/desktop)
///   - Font size adapts per age level (see _fontSizeForAge)
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_colors.dart';

class HighlightedWord extends StatelessWidget {
  /// The full word in uppercase, e.g. "SHIP"
  final String word;

  /// Start index of the phonogram within [word]
  final int highlightStart;

  /// Number of characters to highlight
  final int highlightLength;

  /// Phonogram category — determines the highlight color
  final PhonogramCategory category;

  /// Override font size (otherwise uses [defaultFontSize])
  final double? fontSize;

  /// Default font size when [fontSize] is null
  final double defaultFontSize;

  /// Text alignment
  final TextAlign textAlign;

  const HighlightedWord({
    super.key,
    required this.word,
    required this.highlightStart,
    required this.highlightLength,
    required this.category,
    this.fontSize,
    this.defaultFontSize = 18.0,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? defaultFontSize;
    final accentColor = PhonogramColors.primaryFor(category);
    final normalColor = PhonogramColors.cardTextPrimary.withValues(alpha: 0.87);

    // Guard: if highlight range is out of bounds, show plain text
    if (highlightStart < 0 ||
        highlightStart + highlightLength > word.length) {
      return Text(
        word,
        textAlign: textAlign,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w600,
          color: normalColor,
          letterSpacing: 1.5,
        ),
      );
    }

    final before = word.substring(0, highlightStart);
    final highlighted =
        word.substring(highlightStart, highlightStart + highlightLength);
    final after = word.substring(highlightStart + highlightLength);

    return Semantics(
      label: 'Word: $word. '
          'The letters $highlighted are highlighted as the phonogram.',
      child: Text.rich(
        TextSpan(
          children: [
            if (before.isNotEmpty)
              TextSpan(
                text: before,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w600,
                  color: normalColor,
                  letterSpacing: 1.5,
                ),
              ),
            TextSpan(
              text: highlighted,
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w800,
                color: accentColor,
                letterSpacing: 1.5,
                shadows: [
                  Shadow(
                    color: accentColor.withValues(alpha: 0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
            if (after.isNotEmpty)
              TextSpan(
                text: after,
                style: TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w600,
                  color: normalColor,
                  letterSpacing: 1.5,
                ),
              ),
          ],
        ),
        textAlign: textAlign,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // Age-Adaptive Font Sizes
  // ═══════════════════════════════════════════════════════════════════════════

  /// Returns font size appropriate for the given age level.
  ///
  /// | Level    | Grid Card | Expanded |
  /// |----------|-----------|----------|
  /// | Tiny     | 22        | 28       |
  /// | Starter  | 20        | 26       |
  /// | Explorer | 18        | 22       |
  /// | Master   | 16        | 20       |
  static double fontSizeForAge(AgeLevel level, {bool expanded = false}) {
    switch (level) {
      case AgeLevel.tiny:
        return expanded ? 28.0 : 22.0;
      case AgeLevel.starter:
        return expanded ? 26.0 : 20.0;
      case AgeLevel.explorer:
        return expanded ? 22.0 : 18.0;
      case AgeLevel.master:
        return expanded ? 20.0 : 16.0;
    }
  }
}
