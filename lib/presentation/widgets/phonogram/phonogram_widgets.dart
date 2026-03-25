/// Barrel file for all phonogram detail card widgets.
///
/// Usage:
///   import 'package:crack_the_code/presentation/widgets/phonogram/phonogram_widgets.dart';
///
/// Provides:
///   - PhonogramDetailCard — full screen detail view (the entry point)
///   - PhonogramHeroCard — hero display with glow animation
///   - WordGrid — difficulty-grouped word grid with expand/collapse
///   - ExpandedWordCard — expanded word breakdown view
///   - HighlightedWord — word text with phonogram letters colored
///   - PhonogramColors — centralized color constants
///   - Phonogram, PhonogramSound, PhonogramWord, AgeLevel, etc. — data models

library;

export 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';
export 'phonogram_colors.dart';
export 'highlighted_word.dart';
export 'phonogram_hero_card.dart';
export 'expanded_word_card.dart';
export 'word_grid.dart';
export 'phonogram_detail_card.dart';
export 'phonogram_sample_data.dart';
