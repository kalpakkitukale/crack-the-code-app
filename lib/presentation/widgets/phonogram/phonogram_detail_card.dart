/// PhonogramDetailCard — The full-screen detail view for a phonogram.
///
/// This is the primary screen shown when a user taps a phonogram tile
/// in the collection or during a lesson. It presents:
///   1. PhonogramHeroCard (top) — large phonogram display with glow
///   2. WordGrid (scrollable) — all words grouped by difficulty
///
/// Layout:
///   - Scaffold background: PhonogramColors.cardBackground (#0D0B1A)
///   - AppBar: transparent, no elevation, back arrow + phonogram title
///   - Body: CustomScrollView with SliverToBoxAdapter for hero + grid
///   - Horizontal padding: 16 (mobile), 24 (tablet), 32 (desktop)
///   - Max content width: 600px (centered on large screens)
///
/// Responsive behavior:
///   - Mobile (<600px): full bleed, bottom sheet style entry
///   - Tablet (600-1200px): centered card with max-width 560
///   - Desktop (>1200px): centered card with max-width 560, sidebar context
///
/// This widget is a ConsumerStatefulWidget to integrate with Riverpod
/// for phonogram data and user preferences (age level).
///
/// Usage:
///   Navigator.push(context, MaterialPageRoute(
///     builder: (_) => PhonogramDetailCard(phonogram: myPhonogram),
///   ));
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/services/tts_service.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_colors.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_hero_card.dart';
import 'package:crack_the_code/presentation/widgets/phonogram/word_grid.dart';

class PhonogramDetailCard extends ConsumerStatefulWidget {
  final Phonogram phonogram;

  /// Override age level (otherwise reads from user profile provider).
  /// Useful for previewing different age adaptations.
  final AgeLevel? ageLevelOverride;

  const PhonogramDetailCard({
    super.key,
    required this.phonogram,
    this.ageLevelOverride,
  });

  @override
  ConsumerState<PhonogramDetailCard> createState() =>
      _PhonogramDetailCardState();
}

class _PhonogramDetailCardState extends ConsumerState<PhonogramDetailCard>
    with SingleTickerProviderStateMixin {
  int _selectedSoundIndex = 0;
  late final AnimationController _entryController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeIn = CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOut,
    );
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entryController,
      curve: Curves.easeOutCubic,
    ));
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  AgeLevel get _ageLevel => widget.ageLevelOverride ?? AgeLevel.explorer;

  @override
  Widget build(BuildContext context) {
    final phonogram = widget.phonogram;
    final accent = PhonogramColors.primaryFor(phonogram.category);

    return Theme(
      // Force dark theme for the card — this screen is always dark
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: PhonogramColors.cardBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: Semantics(
            button: true,
            label: 'Go back',
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white70),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text(
            phonogram.letters,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: accent,
              letterSpacing: 2,
            ),
          ),
          centerTitle: true,
          actions: [
            Semantics(
              button: true,
              label: 'Play phonogram sound',
              child: IconButton(
                icon: Icon(
                  Icons.volume_up_rounded,
                  color: accent.withValues(alpha: 0.7),
                ),
                onPressed: _playPhonogramAudio,
              ),
            ),
          ],
        ),
        body: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideIn,
            child: ResponsiveBuilder(
              builder: (context, deviceType) {
                final horizontalPadding = _paddingForDevice(deviceType);
                final maxWidth = _maxWidthForDevice(deviceType);

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      slivers: [
                        // Top safe area + app bar spacing
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).padding.top + 56,
                          ),
                        ),

                        // ─── Hero Card ─────────────────────────────
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: PhonogramHeroCard(
                              phonogram: phonogram,
                              ageLevel: _ageLevel,
                              selectedSoundIndex: _selectedSoundIndex,
                              onSoundSelected: (index) {
                                setState(() => _selectedSoundIndex = index);
                              },
                              onPlayAudio: _playPhonogramAudio,
                            ),
                          ),
                        ),

                        const SliverToBoxAdapter(child: SizedBox(height: 24)),

                        // ─── Word Grid ─────────────────────────────
                        if (phonogram.sounds.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: WordGrid(
                                sound: phonogram.sounds[_selectedSoundIndex],
                                category: phonogram.category,
                                ageLevel: _ageLevel,
                                onPlayAudio: _playWordAudio,
                              ),
                            ),
                          ),

                        // Bottom padding for safe area
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: MediaQuery.of(context).padding.bottom + 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  double _paddingForDevice(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return 16;
      case DeviceType.tablet:
        return 24;
      case DeviceType.desktop:
        return 32;
    }
  }

  double _maxWidthForDevice(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return double.infinity;
      case DeviceType.tablet:
      case DeviceType.desktop:
        return 600;
    }
  }

  void _playPhonogramAudio() {
    final phonogram = widget.phonogram;
    // Use TTS as fallback when no audio asset exists
    if (phonogram.audioPath != null) {
      // TODO: Play from asset when audio files are ready
    }
    ttsService.speak(phonogram.letters);
  }

  void _playWordAudio(PhonogramWord word) {
    if (word.audioPath != null) {
      // TODO: Play from asset when audio files are ready
    }
    ttsService.speak(word.word.toLowerCase());
  }
}
