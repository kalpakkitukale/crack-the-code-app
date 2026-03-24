import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendation_status.dart';

class AppTheme {
  // Crack the Code brand colors
  static const primaryNavy = Color(0xFF0a0618);
  static const primaryGold = Color(0xFFFFD700);
  static const accentOrange = Color(0xFFFF6B35);

  // Legacy aliases (referenced by theme factory)
  static const primaryBlue = primaryNavy;
  static const primaryGreen = primaryGold;
  static const accentColor = accentOrange;
  static const errorColor = Color(0xFFE91E63);
  static const warningColor = Color(0xFFFF9800);
  static const successColor = Color(0xFF4CAF50);

  // Warning color shades (for gradients and varied UI states)
  static const warningLight50 = Color(0xFFFFF3E0);   // orange.shade50
  static const warningLight100 = Color(0xFFFFE0B2);  // orange.shade100
  static const warningLight200 = Color(0xFFFFCC80);  // orange.shade200
  static const warningLight300 = Color(0xFFFFB74D);  // orange.shade300
  static const warningDark800 = Color(0xFFEF6C00);   // orange.shade800
  static const warningDark900 = Color(0xFFE65100);   // orange.shade900

  // Success color shades (for gradients and varied UI states)
  static const successLight50 = Color(0xFFE8F5E9);   // green.shade50
  static const successLight100 = Color(0xFFC8E6C9);  // green.shade100
  static const successLight200 = Color(0xFFA5D6A7);  // green.shade200
  static const successDark700 = Color(0xFF388E3C);   // green.shade700
  static const successDark900 = Color(0xFF1B5E20);   // green.shade900

  // Error color shades
  static const errorDark = Color(0xFFD32F2F);        // red for error states

  // Performance level colors (for quiz statistics)
  static const performanceExcellent = Color(0xFF4CAF50);
  static const performanceGood = Color(0xFF8BC34A);
  static const performanceAverage = Color(0xFFFF9800);
  static const performanceNeedsImprovement = Color(0xFFFF5722);
  static const performanceStruggling = Color(0xFFF44336);

  // Recommendation status colors - Complete palette for all statuses
  // None status (perfect score, no recommendations)
  static const statusNoneLight = Color(0xFFE8F5E9);
  static const statusNoneBorder = Color(0xFF4CAF50);
  static const statusNoneIcon = Color(0xFF4CAF50);
  static const statusNoneText = Color(0xFF2E7D32);
  static const statusNoneDark = Color(0xFF1B5E20);

  // Available status (new recommendations)
  static const statusAvailableLight = Color(0xFFFFF3E0);
  static const statusAvailableBorder = Color(0xFFFF9800);
  static const statusAvailableIcon = Color(0xFFFF9800);
  static const statusAvailableText = Color(0xFFE65100);
  static const statusAvailableDark = Color(0xFFE65100);

  // Viewed status (recommendations viewed)
  static const statusViewedLight = Color(0xFFE3F2FD);
  static const statusViewedBorder = Color(0xFF2196F3);
  static const statusViewedIcon = Color(0xFF2196F3);
  static const statusViewedText = Color(0xFF1565C0);
  static const statusViewedDark = Color(0xFF0D47A1);

  // In Progress status (user started learning)
  static const statusInProgressLight = Color(0xFFF3E5F5);
  static const statusInProgressBorder = Color(0xFF9C27B0);
  static const statusInProgressIcon = Color(0xFF9C27B0);
  static const statusInProgressText = Color(0xFF6A1B9A);
  static const statusInProgressDark = Color(0xFF4A148C);

  // Completed status (recommendations completed)
  static const statusCompletedLight = Color(0xFFE0F2F1);
  static const statusCompletedBorder = Color(0xFF009688);
  static const statusCompletedIcon = Color(0xFF009688);
  static const statusCompletedText = Color(0xFF00695C);
  static const statusCompletedDark = Color(0xFF004D40);

  // Outdated status (recommendations outdated)
  static const statusOutdatedLight = Color(0xFFFBE9E7);
  static const statusOutdatedBorder = Color(0xFFFF5722);
  static const statusOutdatedIcon = Color(0xFFFF5722);
  static const statusOutdatedText = Color(0xFFD84315);
  static const statusOutdatedDark = Color(0xFFBF360C);

  // Severity colors (for weak areas, recommendations)
  static const severityCritical = Color(0xFFD32F2F);
  static const severitySevere = Color(0xFFEF6C00);
  static const severityModerate = Color(0xFFFFA726);
  static const severityMild = Color(0xFFFFB74D);

  // Assessment type colors
  static const readinessAssessment = Color(0xFF7C4DFF);  // Purple for readiness check
  static const practiceAssessment = Color(0xFF00ACC1);   // Cyan for practice/verification

  // Readiness level colors
  static const readinessReady = Color(0xFF2E7D32);       // Deep green - ready to advance
  static const readinessReadyLight = Color(0xFF66BB6A);  // Light green
  static const readinessNeedsWork = Color(0xFFF57C00);   // Deep orange - needs more work
  static const readinessNeedsWorkLight = Color(0xFFFFB74D); // Light orange

  // Achievement badge colors
  static const achievementGold = Color(0xFFFFD700);
  static const achievementSilver = Color(0xFFC0C0C0);
  static const achievementBronze = Color(0xFFCD7F32);
  static const achievementPlatinum = Color(0xFFE5E4E2);

  // Gamification colors
  static const xpGold = Color(0xFFFFB300);
  static const streakFire = Color(0xFFFF6F00);
  static const levelUpGradientStart = Color(0xFFFFD54F);
  static const levelUpGradientEnd = Color(0xFFFFB300);

  // XP Level tier gradients (for different level ranges)
  static const xpTier1Start = Color(0xFF3F51B5);  // indigo
  static const xpTier1End = Color(0xFF2196F3);    // blue
  static const xpTier2Start = Color(0xFF2196F3);  // blue
  static const xpTier2End = Color(0xFF03A9F4);    // lightBlue
  static const xpTier3Start = Color(0xFF4CAF50);  // green
  static const xpTier3End = Color(0xFF8BC34A);    // lightGreen
  static const xpTier4Start = Color(0xFF009688);  // teal
  static const xpTier4End = Color(0xFF00BCD4);    // cyan
  static const xpTier5Start = Color(0xFFFFB300);  // amber/gold
  static const xpTier5End = Color(0xFFFF9800);    // orange
  static const xpTier6Start = Color(0xFF9C27B0);  // purple
  static const xpTier6End = Color(0xFFE91E63);    // pink

  // Light theme colors
  static const lightBackground = Color(0xFFF5F5F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightPrimary = primaryBlue;
  static const lightOnPrimary = Color(0xFFFFFFFF);
  static const lightTextPrimary = Color(0xFF212121);
  static const lightTextSecondary = Color(0xFF757575);

  // Dark theme colors
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkSurfaceElevated1 = Color(0xFF242424);
  static const darkSurfaceElevated2 = Color(0xFF272727);
  static const darkSurfaceElevated3 = Color(0xFF2C2C2C);
  static const darkPrimary = Color(0xFF64B5F6);
  static const darkOnPrimary = Color(0xFF000000);
  static const darkTextPrimary = Color(0xFFE0E0E0);
  static const darkTextSecondary = Color(0xFF9E9E9E);

  // Spacing
  static const double spacingXxs = 2.0;  // For very tight spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Additional spacing for specific use cases
  static const double spacing6 = 6.0;   // Between Xs and Sm
  static const double spacing12 = 12.0; // Between Sm and Md
  static const double spacing20 = 20.0; // Between Md and Lg

  // Border radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 8.0;
  static const double radiusLg = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusXxl = 20.0;  // For larger cards
  static const double radiusRound = 999.0;

  // Additional radius for specific use cases
  static const double radius2 = 2.0;   // Very subtle rounding
  static const double radius6 = 6.0;   // Between Sm and Md

  // Elevation
  static const double elevation1 = 2.0;
  static const double elevation2 = 4.0;
  static const double elevation3 = 8.0;
  static const double elevation4 = 12.0;

  // Animation duration
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // Minimum touch target
  static const double minTouchTarget = 48.0;

  // Light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        secondary: primaryGreen,
        onSecondary: Colors.white,
        tertiary: accentColor,
        error: errorColor,
        surface: lightSurface,
        onSurface: lightTextPrimary,
        surfaceContainerHighest: Color(0xFFF0F0F0),
        outline: Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: lightBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: elevation1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(88, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          elevation: elevation1,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm,
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 80,
        elevation: 0,
        backgroundColor: lightSurface,
        indicatorShape: StadiumBorder(),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        elevation: 0,
        backgroundColor: lightSurface,
        selectedIconTheme: IconThemeData(color: lightPrimary),
        unselectedIconTheme: IconThemeData(color: lightTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E0E0),
        thickness: 1,
        space: 0,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  // Dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        secondary: primaryGreen.withValues(alpha: 0.8),
        onSecondary: Colors.white,
        tertiary: accentColor.withValues(alpha: 0.8),
        error: errorColor,
        surface: darkSurface,
        onSurface: darkTextPrimary,
        surfaceContainerHighest: darkSurfaceElevated1,
        outline: const Color(0xFF424242),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 4,
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: darkSurfaceElevated1,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkOnPrimary,
          minimumSize: const Size(88, minTouchTarget),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingMd,
            vertical: spacingSm,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurfaceElevated1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF424242)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: spacingSm,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkSurfaceElevated2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusRound),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingSm,
          vertical: spacingXs,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 80,
        elevation: 0,
        backgroundColor: darkSurface,
        indicatorShape: StadiumBorder(),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        elevation: 0,
        backgroundColor: darkSurface,
        selectedIconTheme: IconThemeData(color: darkPrimary),
        unselectedIconTheme: IconThemeData(color: darkTextSecondary),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF424242),
        thickness: 1,
        space: 0,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: darkTextPrimary.withValues(alpha: 0.87)),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: darkTextPrimary.withValues(alpha: 0.87)),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: darkTextPrimary.withValues(alpha: 0.87)),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: darkTextPrimary.withValues(alpha: 0.87)),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: darkTextPrimary.withValues(alpha: 0.87)),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: darkTextPrimary.withValues(alpha: 0.87)),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: darkTextPrimary.withValues(alpha: 0.60)),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkTextPrimary.withValues(alpha: 0.87)),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: darkTextPrimary.withValues(alpha: 0.87)),
        labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: darkTextPrimary.withValues(alpha: 0.60)),
      ),
    );
  }

  // High contrast theme
  static ThemeData highContrastTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF000000),
        onPrimary: Color(0xFFFFFFFF),
        secondary: Color(0xFF000000),
        onSecondary: Color(0xFFFFFFFF),
        error: Color(0xFFB00020),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF000000),
        outline: Color(0xFF000000),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
    );
  }

  // Helper methods for theme-aware colors

  /// Get recommendation status background color based on theme brightness
  static Color getStatusBackgroundColor(
    RecommendationStatus status,
    Brightness brightness,
  ) {
    switch (status) {
      case RecommendationStatus.none:
        return brightness == Brightness.light
            ? statusNoneLight
            : statusNoneDark;
      case RecommendationStatus.available:
        return brightness == Brightness.light
            ? statusAvailableLight
            : statusAvailableDark;
      case RecommendationStatus.viewed:
        return brightness == Brightness.light
            ? statusViewedLight
            : statusViewedDark;
      case RecommendationStatus.inProgress:
        return brightness == Brightness.light
            ? statusInProgressLight
            : statusInProgressDark;
      case RecommendationStatus.completed:
        return brightness == Brightness.light
            ? statusCompletedLight
            : statusCompletedDark;
      case RecommendationStatus.outdated:
        return brightness == Brightness.light
            ? statusOutdatedLight
            : statusOutdatedDark;
    }
  }

  /// Get recommendation status border color
  static Color getStatusBorderColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.none:
        return statusNoneBorder;
      case RecommendationStatus.available:
        return statusAvailableBorder;
      case RecommendationStatus.viewed:
        return statusViewedBorder;
      case RecommendationStatus.inProgress:
        return statusInProgressBorder;
      case RecommendationStatus.completed:
        return statusCompletedBorder;
      case RecommendationStatus.outdated:
        return statusOutdatedBorder;
    }
  }

  /// Get recommendation status icon color
  static Color getStatusIconColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.none:
        return statusNoneIcon;
      case RecommendationStatus.available:
        return statusAvailableIcon;
      case RecommendationStatus.viewed:
        return statusViewedIcon;
      case RecommendationStatus.inProgress:
        return statusInProgressIcon;
      case RecommendationStatus.completed:
        return statusCompletedIcon;
      case RecommendationStatus.outdated:
        return statusOutdatedIcon;
    }
  }

  /// Get recommendation status text color
  static Color getStatusTextColor(RecommendationStatus status) {
    switch (status) {
      case RecommendationStatus.none:
        return statusNoneText;
      case RecommendationStatus.available:
        return statusAvailableText;
      case RecommendationStatus.viewed:
        return statusViewedText;
      case RecommendationStatus.inProgress:
        return statusInProgressText;
      case RecommendationStatus.completed:
        return statusCompletedText;
      case RecommendationStatus.outdated:
        return statusOutdatedText;
    }
  }

  /// Get performance level color
  static Color getPerformanceColor(double percentage) {
    if (percentage >= 90) return performanceExcellent;
    if (percentage >= 75) return performanceGood;
    if (percentage >= 60) return performanceAverage;
    if (percentage >= 40) return performanceNeedsImprovement;
    return performanceStruggling;
  }

  /// Get severity color and icon
  static (Color, IconData) getSeverityColorAndIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return (severityCritical, Icons.error_outline);
      case 'severe':
        return (severitySevere, Icons.warning_amber_outlined);
      case 'moderate':
        return (severityModerate, Icons.info_outline);
      case 'mild':
        return (severityMild, Icons.lightbulb_outline);
      default:
        return (severityModerate, Icons.info_outline);
    }
  }

  /// Get XP level gradient colors based on level
  static List<Color> getXPLevelGradient(int level) {
    if (level >= 50) return [xpTier6Start, xpTier6End];       // Purple/Pink
    if (level >= 40) return [xpTier5Start, xpTier5End];       // Amber/Orange
    if (level >= 30) return [xpTier4Start, xpTier4End];       // Teal/Cyan
    if (level >= 20) return [xpTier3Start, xpTier3End];       // Green/LightGreen
    if (level >= 10) return [xpTier2Start, xpTier2End];       // Blue/LightBlue
    return [xpTier1Start, xpTier1End];                        // Indigo/Blue
  }
}