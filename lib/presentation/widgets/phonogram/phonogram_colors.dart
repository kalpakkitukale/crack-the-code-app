/// Centralized color constants and helpers for phonogram UI components.
///
/// Category colors follow the trading-card-game aesthetic:
/// - Vowels: warm red/crimson (power cards)
/// - Consonants: cool blue (foundation cards)
/// - Teams: emerald green (combo cards)
/// - Advanced Teams: royal purple (rare cards)
library;

import 'package:flutter/material.dart';
import 'package:crack_the_code/domain/entities/phonogram/phonogram.dart';

class PhonogramColors {
  PhonogramColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // Brand Colors (from AppTheme)
  // ═══════════════════════════════════════════════════════════════════════════
  static const navy = Color(0xFF0A0618);
  static const gold = Color(0xFFFFD700);
  static const goldDark = Color(0xFFB8960F);

  // ═══════════════════════════════════════════════════════════════════════════
  // Card Surface Colors (dark theme — the phonogram card is always dark)
  // ═══════════════════════════════════════════════════════════════════════════
  static const cardBackground = Color(0xFF0D0B1A);
  static const cardSurface = Color(0xFF151328);
  static const cardSurfaceElevated = Color(0xFF1C1938);
  static const cardBorder = Color(0xFF2A2650);
  static const cardTextPrimary = Color(0xFFEEEEEE);
  static const cardTextSecondary = Color(0xFF9E9AAF);

  // ═══════════════════════════════════════════════════════════════════════════
  // Word Card Colors (inside the detail view)
  // ═══════════════════════════════════════════════════════════════════════════
  static const wordCardBackground = Color(0xFF1A1730);
  static const wordCardBorder = Color(0xFF2E2A4A);
  static const wordCardExpandedBg = Color(0xFF12101F);

  // ═══════════════════════════════════════════════════════════════════════════
  // Section Badge Colors
  // ═══════════════════════════════════════════════════════════════════════════
  static const easyBadge = Color(0xFF4CAF50);
  static const moreBadge = Color(0xFFFFA726);
  static const challengeBadge = Color(0xFFEF5350);

  // ═══════════════════════════════════════════════════════════════════════════
  // Category Colors
  // ═══════════════════════════════════════════════════════════════════════════

  /// Vowel accent color — warm crimson
  static const vowelPrimary = Color(0xFFE53935);
  static const vowelGlow = Color(0x40E53935);
  static const vowelGradientStart = Color(0xFFFF5252);
  static const vowelGradientEnd = Color(0xFFD32F2F);
  static const vowelSurface = Color(0xFF2A1520);

  /// Consonant accent color — cool blue
  static const consonantPrimary = Color(0xFF42A5F5);
  static const consonantGlow = Color(0x4042A5F5);
  static const consonantGradientStart = Color(0xFF64B5F6);
  static const consonantGradientEnd = Color(0xFF1E88E5);
  static const consonantSurface = Color(0xFF152030);

  /// Team accent color — emerald green
  static const teamPrimary = Color(0xFF66BB6A);
  static const teamGlow = Color(0x4066BB6A);
  static const teamGradientStart = Color(0xFF81C784);
  static const teamGradientEnd = Color(0xFF43A047);
  static const teamSurface = Color(0xFF152A18);

  /// Advanced team accent color — royal purple
  static const advancedTeamPrimary = Color(0xFFAB47BC);
  static const advancedTeamGlow = Color(0x40AB47BC);
  static const advancedTeamGradientStart = Color(0xFFCE93D8);
  static const advancedTeamGradientEnd = Color(0xFF8E24AA);
  static const advancedTeamSurface = Color(0xFF201530);

  // ═══════════════════════════════════════════════════════════════════════════
  // Category Color Getters
  // ═══════════════════════════════════════════════════════════════════════════

  static Color primaryFor(PhonogramCategory category) {
    switch (category) {
      case PhonogramCategory.vowel:
        return vowelPrimary;
      case PhonogramCategory.consonant:
        return consonantPrimary;
      case PhonogramCategory.team:
        return teamPrimary;
      case PhonogramCategory.advancedTeam:
        return advancedTeamPrimary;
    }
  }

  static Color glowFor(PhonogramCategory category) {
    switch (category) {
      case PhonogramCategory.vowel:
        return vowelGlow;
      case PhonogramCategory.consonant:
        return consonantGlow;
      case PhonogramCategory.team:
        return teamGlow;
      case PhonogramCategory.advancedTeam:
        return advancedTeamGlow;
    }
  }

  static List<Color> gradientFor(PhonogramCategory category) {
    switch (category) {
      case PhonogramCategory.vowel:
        return [vowelGradientStart, vowelGradientEnd];
      case PhonogramCategory.consonant:
        return [consonantGradientStart, consonantGradientEnd];
      case PhonogramCategory.team:
        return [teamGradientStart, teamGradientEnd];
      case PhonogramCategory.advancedTeam:
        return [advancedTeamGradientStart, advancedTeamGradientEnd];
    }
  }

  static Color surfaceFor(PhonogramCategory category) {
    switch (category) {
      case PhonogramCategory.vowel:
        return vowelSurface;
      case PhonogramCategory.consonant:
        return consonantSurface;
      case PhonogramCategory.team:
        return teamSurface;
      case PhonogramCategory.advancedTeam:
        return advancedTeamSurface;
    }
  }

  static String labelFor(PhonogramCategory category) {
    switch (category) {
      case PhonogramCategory.vowel:
        return 'VOWEL';
      case PhonogramCategory.consonant:
        return 'CONSONANT';
      case PhonogramCategory.team:
        return 'LETTER TEAM';
      case PhonogramCategory.advancedTeam:
        return 'ADVANCED TEAM';
    }
  }
}
