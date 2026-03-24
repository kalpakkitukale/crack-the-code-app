// Theme Factory for Crack the Code
// Navy (#0a0618) + Gold (#FFD700) brand colors with adaptive sizing

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Abstract base class for segment color palettes
abstract class SegmentColorPalette {
  Color get primary;
  Color get secondary;
  Color get accent;
  Color get primaryDark;
  Color get secondaryDark;
  Color get accentDark;
}

/// Factory for creating segment-specific themes
class SegmentThemeFactory {
  SegmentThemeFactory._();

  /// Get the light theme for the current segment
  static ThemeData lightTheme() {
    final settings = SegmentConfig.settings;
    return _buildTheme(
      brightness: Brightness.light,
      fontScale: settings.fontScale,
      touchTargetScale: settings.touchTargetScale,
      radiusScale: settings.uiComplexity == UIComplexity.simple ? 1.5 : 1.0,
      isJunior: settings.uiComplexity == UIComplexity.simple,
    );
  }

  /// Get the dark theme for the current segment
  static ThemeData darkTheme() {
    final settings = SegmentConfig.settings;
    return _buildTheme(
      brightness: Brightness.dark,
      fontScale: settings.fontScale,
      touchTargetScale: settings.touchTargetScale,
      radiusScale: settings.uiComplexity == UIComplexity.simple ? 1.5 : 1.0,
      isJunior: settings.uiComplexity == UIComplexity.simple,
    );
  }

  /// Build theme with segment-specific adjustments
  static ThemeData _buildTheme({
    required Brightness brightness,
    required double fontScale,
    required double touchTargetScale,
    required double radiusScale,
    required bool isJunior,
  }) {
    final isLight = brightness == Brightness.light;

    // Crack the Code brand colors — Navy + Gold
    final SegmentColorPalette colors = _CrackTheCodeColors();

    // Scaled dimensions
    final minTouchTarget = AppTheme.minTouchTarget * touchTargetScale;
    final radiusMd = AppTheme.radiusMd * radiusScale;
    final radiusLg = AppTheme.radiusLg * radiusScale;
    final radiusXl = AppTheme.radiusXl * radiusScale;

    // Scaled spacing
    final spacingSm = AppTheme.spacingSm * (isJunior ? 1.25 : 1.0);
    final spacingMd = AppTheme.spacingMd * (isJunior ? 1.25 : 1.0);

    // Build color scheme
    final colorScheme = isLight
        ? ColorScheme.light(
            primary: colors.primary,
            onPrimary: Colors.white,
            secondary: colors.secondary,
            onSecondary: Colors.white,
            tertiary: colors.accent,
            error: AppTheme.errorColor,
            surface: AppTheme.lightSurface,
            onSurface: AppTheme.lightTextPrimary,
            surfaceContainerHighest: const Color(0xFFF0F0F0),
            outline: const Color(0xFFE0E0E0),
          )
        : ColorScheme.dark(
            primary: colors.primaryDark,
            onPrimary: Colors.black,
            secondary: colors.secondaryDark,
            onSecondary: Colors.white,
            tertiary: colors.accentDark,
            error: AppTheme.errorColor,
            surface: AppTheme.darkSurface,
            onSurface: AppTheme.darkTextPrimary,
            surfaceContainerHighest: AppTheme.darkSurfaceElevated1,
            outline: const Color(0xFF424242),
          );

    // Build text theme with scaling
    final textTheme = _buildTextTheme(
      brightness: brightness,
      fontScale: fontScale,
      isJunior: isJunior,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isLight ? AppTheme.lightBackground : AppTheme.darkBackground,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: isLight ? 2 : 4,
        backgroundColor:
            isLight ? AppTheme.lightSurface : AppTheme.darkSurface,
        foregroundColor:
            isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary,
        systemOverlayStyle:
            isLight ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color:
              isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary,
          fontSize: 20 * fontScale,
          fontWeight: isJunior ? FontWeight.w700 : FontWeight.w600,
        ),
        toolbarHeight: isJunior ? 64 : 56,
      ),
      cardTheme: CardThemeData(
        color: isLight ? AppTheme.lightSurface : AppTheme.darkSurfaceElevated1,
        elevation: isLight ? AppTheme.elevation1 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(88, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          elevation: isLight ? AppTheme.elevation1 : 0,
          padding: EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: TextStyle(
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: Size(88, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: TextStyle(
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(88, minTouchTarget),
          padding: EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
          textStyle: TextStyle(
            fontSize: 14 * fontScale,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: isLight ? AppTheme.elevation2 : 0,
        highlightElevation: isLight ? AppTheme.elevation3 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isJunior ? radiusXl : radiusLg),
        ),
        // Larger FAB for junior
        sizeConstraints: BoxConstraints.tightFor(
          width: isJunior ? 64 : 56,
          height: isJunior ? 64 : 56,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isLight
            ? AppTheme.lightSurface
            : AppTheme.darkSurfaceElevated1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(
            color: isLight ? const Color(0xFFE0E0E0) : const Color(0xFF424242),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(
            color: isLight ? const Color(0xFFE0E0E0) : const Color(0xFF424242),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: AppTheme.errorColor),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm + 4,
        ),
        labelStyle: TextStyle(fontSize: 14 * fontScale),
        hintStyle: TextStyle(fontSize: 14 * fontScale),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isLight
            ? colorScheme.surfaceContainerHighest
            : AppTheme.darkSurfaceElevated2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusRound),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: AppTheme.spacingXs * (isJunior ? 1.5 : 1.0),
        ),
        labelStyle: TextStyle(
          fontSize: 12 * fontScale,
          fontWeight: FontWeight.w500,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: isJunior ? 90 : 80,
        elevation: 0,
        backgroundColor:
            isLight ? AppTheme.lightSurface : AppTheme.darkSurface,
        indicatorShape: const StadiumBorder(),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(
            fontSize: 12 * fontScale,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.all(
          IconThemeData(
            size: isJunior ? 28 : 24,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        elevation: 0,
        backgroundColor:
            isLight ? AppTheme.lightSurface : AppTheme.darkSurface,
        selectedIconTheme: IconThemeData(
          color: colors.primary,
          size: isJunior ? 28 : 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: isLight
              ? AppTheme.lightTextSecondary
              : AppTheme.darkTextSecondary,
          size: isJunior ? 28 : 24,
        ),
        selectedLabelTextStyle: TextStyle(
          fontSize: 12 * fontScale,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontSize: 12 * fontScale,
        ),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: isJunior ? 12 : 8,
        contentPadding: EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: isJunior ? 4 : 0,
        ),
        titleTextStyle: TextStyle(
          fontSize: 16 * fontScale,
          fontWeight: FontWeight.w500,
          color:
              isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14 * fontScale,
          color: isLight
              ? AppTheme.lightTextSecondary
              : AppTheme.darkTextSecondary,
        ),
      ),
      iconTheme: IconThemeData(
        size: isJunior ? 28 : 24,
      ),
      dividerTheme: DividerThemeData(
        color: isLight ? const Color(0xFFE0E0E0) : const Color(0xFF424242),
        thickness: 1,
        space: 0,
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
        titleTextStyle: TextStyle(
          fontSize: 20 * fontScale,
          fontWeight: FontWeight.w600,
          color:
              isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontSize: 16 * fontScale,
          color:
              isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXl),
          ),
        ),
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        contentTextStyle: TextStyle(
          fontSize: 14 * fontScale,
        ),
      ),
      textTheme: textTheme,
      extensions: [
        SegmentThemeExtension(
          isJunior: isJunior,
          fontScale: fontScale,
          touchTargetScale: touchTargetScale,
          juniorPrimary: _CrackTheCodeColors().primary,
          juniorSecondary: _CrackTheCodeColors().secondary,
          juniorAccent: _CrackTheCodeColors().accent,
          celebrationGold: const Color(0xFFFFD700),
          celebrationConfetti: const Color(0xFF9C27B0),
          streakFlame: const Color(0xFFFF6B35),
          badgeBackground: isJunior
              ? const Color(0xFFFFF8E1)
              : const Color(0xFFF5F5F5),
        ),
      ],
    );
  }

  /// Build text theme with proper scaling
  static TextTheme _buildTextTheme({
    required Brightness brightness,
    required double fontScale,
    required bool isJunior,
  }) {
    final isLight = brightness == Brightness.light;
    final textColor =
        isLight ? AppTheme.lightTextPrimary : AppTheme.darkTextPrimary;
    final secondaryColor =
        isLight ? AppTheme.lightTextSecondary : AppTheme.darkTextSecondary;

    // Junior uses slightly bolder weights for better readability
    final regularWeight = isJunior ? FontWeight.w500 : FontWeight.normal;
    final mediumWeight = isJunior ? FontWeight.w600 : FontWeight.w500;
    final boldWeight = isJunior ? FontWeight.w700 : FontWeight.bold;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32 * fontScale,
        fontWeight: boldWeight,
        color: textColor,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontSize: 28 * fontScale,
        fontWeight: boldWeight,
        color: textColor,
        height: 1.2,
      ),
      displaySmall: TextStyle(
        fontSize: 24 * fontScale,
        fontWeight: boldWeight,
        color: textColor,
        height: 1.2,
      ),
      headlineLarge: TextStyle(
        fontSize: 22 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 16 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 12 * fontScale,
        fontWeight: FontWeight.w600,
        color: textColor,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 16 * fontScale,
        fontWeight: regularWeight,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14 * fontScale,
        fontWeight: regularWeight,
        color: textColor,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontSize: 12 * fontScale,
        fontWeight: regularWeight,
        color: secondaryColor,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14 * fontScale,
        fontWeight: mediumWeight,
        color: textColor,
        height: 1.4,
      ),
      labelMedium: TextStyle(
        fontSize: 12 * fontScale,
        fontWeight: mediumWeight,
        color: textColor,
        height: 1.4,
      ),
      labelSmall: TextStyle(
        fontSize: 10 * fontScale,
        fontWeight: mediumWeight,
        color: secondaryColor,
        height: 1.4,
      ),
    );
  }
}

/// Crack the Code brand colors — Navy + Gold
class _CrackTheCodeColors implements SegmentColorPalette {
  // Light theme colors
  @override
  final Color primary = const Color(0xFF0a0618); // Navy (brand primary)
  @override
  final Color secondary = const Color(0xFFFFD700); // Gold (brand accent)
  @override
  final Color accent = const Color(0xFFFF6B35); // Warm orange (energy)

  // Dark theme colors
  @override
  final Color primaryDark = const Color(0xFF2A2845); // Lighter navy for dark theme
  @override
  final Color secondaryDark = const Color(0xFFFFE082); // Lighter gold
  @override
  final Color accentDark = const Color(0xFFFF8A65); // Lighter orange
}

/// Theme extension for segment-specific values
class SegmentThemeExtension extends ThemeExtension<SegmentThemeExtension> {
  final bool isJunior;
  final double fontScale;
  final double touchTargetScale;
  final Color juniorPrimary;
  final Color juniorSecondary;
  final Color juniorAccent;
  final Color celebrationGold;
  final Color celebrationConfetti;
  final Color streakFlame;
  final Color badgeBackground;

  const SegmentThemeExtension({
    required this.isJunior,
    required this.fontScale,
    required this.touchTargetScale,
    required this.juniorPrimary,
    required this.juniorSecondary,
    required this.juniorAccent,
    required this.celebrationGold,
    required this.celebrationConfetti,
    required this.streakFlame,
    required this.badgeBackground,
  });

  @override
  SegmentThemeExtension copyWith({
    bool? isJunior,
    double? fontScale,
    double? touchTargetScale,
    Color? juniorPrimary,
    Color? juniorSecondary,
    Color? juniorAccent,
    Color? celebrationGold,
    Color? celebrationConfetti,
    Color? streakFlame,
    Color? badgeBackground,
  }) {
    return SegmentThemeExtension(
      isJunior: isJunior ?? this.isJunior,
      fontScale: fontScale ?? this.fontScale,
      touchTargetScale: touchTargetScale ?? this.touchTargetScale,
      juniorPrimary: juniorPrimary ?? this.juniorPrimary,
      juniorSecondary: juniorSecondary ?? this.juniorSecondary,
      juniorAccent: juniorAccent ?? this.juniorAccent,
      celebrationGold: celebrationGold ?? this.celebrationGold,
      celebrationConfetti: celebrationConfetti ?? this.celebrationConfetti,
      streakFlame: streakFlame ?? this.streakFlame,
      badgeBackground: badgeBackground ?? this.badgeBackground,
    );
  }

  @override
  SegmentThemeExtension lerp(SegmentThemeExtension? other, double t) {
    if (other is! SegmentThemeExtension) return this;
    return SegmentThemeExtension(
      isJunior: t < 0.5 ? isJunior : other.isJunior,
      fontScale: lerpDouble(fontScale, other.fontScale, t) ?? fontScale,
      touchTargetScale:
          lerpDouble(touchTargetScale, other.touchTargetScale, t) ??
              touchTargetScale,
      juniorPrimary: Color.lerp(juniorPrimary, other.juniorPrimary, t)!,
      juniorSecondary: Color.lerp(juniorSecondary, other.juniorSecondary, t)!,
      juniorAccent: Color.lerp(juniorAccent, other.juniorAccent, t)!,
      celebrationGold: Color.lerp(celebrationGold, other.celebrationGold, t)!,
      celebrationConfetti:
          Color.lerp(celebrationConfetti, other.celebrationConfetti, t)!,
      streakFlame: Color.lerp(streakFlame, other.streakFlame, t)!,
      badgeBackground: Color.lerp(badgeBackground, other.badgeBackground, t)!,
    );
  }

  /// Helper to get the extension from context
  static SegmentThemeExtension of(BuildContext context) {
    return Theme.of(context).extension<SegmentThemeExtension>()!;
  }

  /// Safe helper that returns null if extension not found
  static SegmentThemeExtension? maybeOf(BuildContext context) {
    return Theme.of(context).extension<SegmentThemeExtension>();
  }
}

/// Helper function for lerping doubles
double? lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
