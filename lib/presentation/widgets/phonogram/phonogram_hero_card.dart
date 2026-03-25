/// PhonogramHeroCard — The premium hero display at the top of the detail view.
///
/// Visual spec (always rendered on dark card surface):
///   - Container: full width, min height 220 (tiny) / 200 (starter) / 180 (explorer/master)
///   - Background: radial gradient from category surface color to cardBackground
///   - Border: 1px category color at 30% opacity, border-radius 24
///   - Padding: 24 all sides
///
/// Layout (top to bottom):
///   1. Category label chip ("VOWEL", "LETTER TEAM") — 10sp, category color
///   2. Phonogram letters — 64sp (tiny) / 56 (starter) / 48 (explorer) / 44 (master)
///      - FontWeight.w900, white, letter-spacing 8
///      - Pulsing glow shadow animation: 0→12→0 blur, category color at 50%
///      - Duration: 2000ms, Curves.easeInOut, infinite repeat
///   3. Sound notation — 20sp, category color, italic, e.g. "/sh/"
///   4. Sound selector chips (only for multi-sound phonograms)
///      - Row of FilterChip: selected=filled with category gradient, unselected=outlined
///      - Height 36, horizontal padding 12, gap 8
///   5. Age-adaptive explanation text — 14sp (explorer/master) / 16sp (starter/tiny)
///      - Max 2 lines, ellipsis overflow
///   6. Mastery progress bar — 4px height, gold fill, rounded ends
///
/// Animation:
///   - Glow pulse: AnimationController 2000ms, CurvedAnimation easeInOut
///   - Chip selection: AnimatedContainer 200ms
///   - Entry: FadeTransition + SlideTransition 400ms from top
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_colors.dart';

class PhonogramHeroCard extends StatefulWidget {
  final Phonogram phonogram;
  final AgeLevel ageLevel;
  final int selectedSoundIndex;
  final ValueChanged<int> onSoundSelected;
  final VoidCallback? onPlayAudio;

  const PhonogramHeroCard({
    super.key,
    required this.phonogram,
    required this.ageLevel,
    this.selectedSoundIndex = 0,
    required this.onSoundSelected,
    this.onPlayAudio,
  });

  @override
  State<PhonogramHeroCard> createState() => _PhonogramHeroCardState();
}

class _PhonogramHeroCardState extends State<PhonogramHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phonogram = widget.phonogram;
    final category = phonogram.category;
    final accent = PhonogramColors.primaryFor(category);
    final gradient = PhonogramColors.gradientFor(category);
    final surface = PhonogramColors.surfaceFor(category);

    final selectedSound = phonogram.sounds.isNotEmpty
        ? phonogram.sounds[widget.selectedSoundIndex]
        : null;

    return Semantics(
      label:
          'Phonogram ${phonogram.letters}. ${phonogram.soundCount} sound${phonogram.soundCount == 1 ? '' : 's'}. '
          '${selectedSound != null ? 'Current sound: ${selectedSound.notation}' : ''}',
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          final glowRadius = 4.0 + (_glowAnimation.value * 12.0);
          final glowOpacity = 0.3 + (_glowAnimation.value * 0.2);

          return Container(
            width: double.infinity,
            constraints: BoxConstraints(
              minHeight: _minHeightForAge(widget.ageLevel),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: accent.withValues(alpha: 0.3),
                width: 1,
              ),
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.4,
                colors: [
                  surface,
                  PhonogramColors.cardBackground,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: glowOpacity),
                  blurRadius: glowRadius,
                  spreadRadius: 0,
                ),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ─── 1. Category label ───────────────────────────
                _CategoryChip(
                  category: category,
                  accent: accent,
                ),
                const SizedBox(height: 12),

                // ─── 2. Phonogram letters with glow ──────────────
                _GlowingLetters(
                  letters: phonogram.letters,
                  fontSize: _letterFontSize(widget.ageLevel),
                  glowRadius: glowRadius,
                  glowColor: accent,
                  onTap: widget.onPlayAudio,
                ),
                const SizedBox(height: 8),

                // ─── 3. Sound notation ───────────────────────────
                if (selectedSound != null)
                  Text(
                    selectedSound.notation,
                    style: TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: accent,
                      letterSpacing: 1.0,
                    ),
                  ),
                const SizedBox(height: 16),

                // ─── 4. Sound selector chips ─────────────────────
                if (phonogram.isMultiSound)
                  _SoundSelectorRow(
                    sounds: phonogram.sounds,
                    selectedIndex: widget.selectedSoundIndex,
                    accent: accent,
                    gradient: gradient,
                    onSelected: widget.onSoundSelected,
                  ),

                if (phonogram.isMultiSound) const SizedBox(height: 12),

                // ─── 5. Age-adaptive explanation ─────────────────
                if (selectedSound != null &&
                    selectedSound.explanations.containsKey(widget.ageLevel))
                  Text(
                    selectedSound.explanations[widget.ageLevel]!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: _explanationFontSize(widget.ageLevel),
                      fontWeight: FontWeight.w400,
                      color:
                          PhonogramColors.cardTextSecondary.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),

                const SizedBox(height: 16),

                // ─── 6. Mastery progress bar ─────────────────────
                _MasteryBar(mastery: phonogram.mastery),
              ],
            ),
          );
        },
      ),
    );
  }

  double _minHeightForAge(AgeLevel level) {
    switch (level) {
      case AgeLevel.tiny:
        return 240;
      case AgeLevel.starter:
        return 220;
      case AgeLevel.explorer:
      case AgeLevel.master:
        return 200;
    }
  }

  double _letterFontSize(AgeLevel level) {
    switch (level) {
      case AgeLevel.tiny:
        return 64;
      case AgeLevel.starter:
        return 56;
      case AgeLevel.explorer:
        return 48;
      case AgeLevel.master:
        return 44;
    }
  }

  double _explanationFontSize(AgeLevel level) {
    switch (level) {
      case AgeLevel.tiny:
      case AgeLevel.starter:
        return 16;
      case AgeLevel.explorer:
      case AgeLevel.master:
        return 14;
    }
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// Private Sub-Widgets
// ═════════════════════════════════════════════════════════════════════════════

/// Category label chip at the top: "VOWEL", "CONSONANT", etc.
/// Specs: height 24, horizontal padding 12, border-radius 12,
///        background category color at 15%, text 10sp bold uppercase.
class _CategoryChip extends StatelessWidget {
  final PhonogramCategory category;
  final Color accent;

  const _CategoryChip({required this.category, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: accent.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
      child: Text(
        PhonogramColors.labelFor(category),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: accent,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

/// The large phonogram letters with glow shadow.
/// Tap triggers audio playback.
/// Specs: FontWeight.w900, letterSpacing 8, white color.
class _GlowingLetters extends StatelessWidget {
  final String letters;
  final double fontSize;
  final double glowRadius;
  final Color glowColor;
  final VoidCallback? onTap;

  const _GlowingLetters({
    required this.letters,
    required this.fontSize,
    required this.glowRadius,
    required this.glowColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        letters,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 8,
          shadows: [
            Shadow(
              color: glowColor.withValues(alpha: 0.5),
              blurRadius: glowRadius,
            ),
            Shadow(
              color: glowColor.withValues(alpha: 0.25),
              blurRadius: glowRadius * 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Row of FilterChips for selecting between multiple sounds.
/// Selected chip: filled with category gradient, white text.
/// Unselected chip: transparent with category-colored border, category text.
/// Specs: height 36, horizontal padding 12, gap 8, border-radius 18.
/// Animation: AnimatedContainer 200ms easeOut.
class _SoundSelectorRow extends StatelessWidget {
  final List<PhonogramSound> sounds;
  final int selectedIndex;
  final Color accent;
  final List<Color> gradient;
  final ValueChanged<int> onSelected;

  const _SoundSelectorRow({
    required this.sounds,
    required this.selectedIndex,
    required this.accent,
    required this.gradient,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(sounds.length, (index) {
        final isSelected = index == selectedIndex;
        final sound = sounds[index];

        return Semantics(
          label: 'Sound ${sound.notation}. '
              '${isSelected ? 'Selected' : 'Tap to select'}',
          selected: isSelected,
          child: GestureDetector(
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: isSelected
                    ? LinearGradient(colors: gradient)
                    : null,
                color: isSelected ? null : Colors.transparent,
                border: isSelected
                    ? null
                    : Border.all(color: accent.withValues(alpha: 0.5)),
              ),
              alignment: Alignment.center,
              child: Text(
                sound.notation,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : accent.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Gold mastery progress bar.
/// Specs: height 4, border-radius 2, background #2A2650, fill gold gradient.
class _MasteryBar extends StatelessWidget {
  final double mastery;

  const _MasteryBar({required this.mastery});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Mastery ${(mastery * 100).round()} percent',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MASTERY',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: PhonogramColors.cardTextSecondary.withValues(alpha: 0.6),
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${(mastery * 100).round()}%',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: PhonogramColors.gold.withValues(alpha: 0.8),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              height: 4,
              child: LinearProgressIndicator(
                value: mastery,
                backgroundColor: PhonogramColors.cardBorder,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  PhonogramColors.gold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
