import 'package:flutter/material.dart';
import 'colors.dart';

/// * CROPFRESH MATERIAL DESIGN 3 THEME CONFIGURATION
/// * Following 60-30-10 Color Rule: 60% Light Backgrounds, 30% Green Supporting, 10% Orange Actions
/// * Implements latest Material Design 3 specifications with useMaterial3: true
class CropFreshTheme {
  // Private constructor to prevent instantiation
  CropFreshTheme._();

  // ============================================================================
  // * LIGHT THEME CONFIGURATION (Material Design 3)
  // ============================================================================
  
  /// * Creates the light theme for CropFresh app
  /// * Follows Material Design 3 specifications with proper color mappings
  /// * Uses ColorScheme.fromSeed for consistent color generation
  static ThemeData get lightTheme => ThemeData(
    // ! IMPORTANT: Enable Material Design 3
    useMaterial3: true,
    
    // * 60-30-10 COLOR SCHEME (Material Design 3)
    colorScheme: ColorScheme.fromSeed(
      seedColor: CropFreshColors.brandGreen, // 30% supporting color as seed
      brightness: Brightness.light,
      // 60% - Light backgrounds
      surface: CropFreshColors.background60Primary,
      surfaceContainerHighest: CropFreshColors.background60Container,
      // 30% - Green supporting elements  
      primary: CropFreshColors.green30Primary,
      primaryContainer: CropFreshColors.green30Container,
      // 10% - Orange action elements
      secondary: CropFreshColors.orange10Primary,
      secondaryContainer: CropFreshColors.orange10Container,
      // Semantic colors following the rule
      tertiary: CropFreshColors.green30Light,
      tertiaryContainer: CropFreshColors.green30Surface,
      error: CropFreshColors.errorPrimary,
      errorContainer: CropFreshColors.errorContainer,
    ),
    
    // * APP BAR THEME (Material Design 3)
    appBarTheme: AppBarTheme(
      backgroundColor: CropFreshColors.background60Primary, // 60% background
      foregroundColor: CropFreshColors.onBackground60,
      elevation: 0, // Material 3 style - no elevation by default
      surfaceTintColor: CropFreshColors.green30Light, // 30% supporting tint
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    ),

    // * ELEVATED BUTTON THEME (Material Design 3)
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: CropFreshColors.orange10Primary, // 10% action color
        foregroundColor: CropFreshColors.onOrange10,
        elevation: 1, // Material 3 reduced elevation
        shadowColor: CropFreshColors.orange10Primary.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Material 3 rounded corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // * OUTLINED BUTTON THEME (Material Design 3)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: CropFreshColors.green30Primary, // 30% supporting color
        side: BorderSide(
          color: CropFreshColors.green30Primary,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // * TEXT BUTTON THEME (Material Design 3)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: CropFreshColors.green30Primary, // 30% supporting color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),

    // * FLOATING ACTION BUTTON THEME (Material Design 3)
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: CropFreshColors.orange10Primary, // 10% action color
      foregroundColor: CropFreshColors.onOrange10,
      elevation: 6, // Material 3 elevation
      focusElevation: 8,
      hoverElevation: 8,
      highlightElevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Material 3 rounded corners
      ),
    ),

    // * CARD THEME (Material Design 3)
    cardTheme: CardThemeData(
      color: CropFreshColors.background60Card, // 60% background
      elevation: 1, // Material 3 reduced elevation
      shadowColor: CropFreshColors.green30Primary.withValues(alpha: 0.1),
      surfaceTintColor: CropFreshColors.green30Light, // 30% supporting tint
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Material 3 rounded corners
      ),
      margin: const EdgeInsets.all(8),
    ),

    // * INPUT DECORATION THEME (Material Design 3)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: CropFreshColors.background60Secondary, // 60% background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), // Material 3 rounded corners
        borderSide: BorderSide(
          color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: CropFreshColors.green30Primary, // 30% supporting color
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: CropFreshColors.errorPrimary,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: CropFreshColors.errorPrimary,
          width: 2,
        ),
      ),
      labelStyle: TextStyle(
        color: CropFreshColors.onBackground60Secondary,
      ),
      hintStyle: TextStyle(
        color: CropFreshColors.onBackground60Tertiary,
      ),
    ),

    // * NAVIGATION BAR THEME (Material Design 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: CropFreshColors.background60Primary, // 60% background
      indicatorColor: CropFreshColors.green30Container, // 30% supporting color
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              color: CropFreshColors.green30Primary, // 30% supporting color
              fontWeight: FontWeight.w600,
            );
          }
          return TextStyle(
            color: CropFreshColors.onBackground60Secondary,
            fontWeight: FontWeight.w500,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: CropFreshColors.green30Primary, // 30% supporting color
            );
          }
          return IconThemeData(
            color: CropFreshColors.onBackground60Secondary,
          );
        },
      ),
    ),

    // * CHIP THEME (Material Design 3)
    chipTheme: ChipThemeData(
      backgroundColor: CropFreshColors.background60Container, // 60% background
      selectedColor: CropFreshColors.green30Container, // 30% supporting color
      labelStyle: TextStyle(
        color: CropFreshColors.onBackground60,
      ),
      secondaryLabelStyle: TextStyle(
        color: CropFreshColors.onGreen30Container,
      ),
      side: BorderSide(
        color: CropFreshColors.green30Primary.withValues(alpha: 0.3), // 30% supporting color
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Material 3 rounded corners
      ),
    ),

    // * DIALOG THEME (Material Design 3)
    dialogTheme: DialogThemeData(
      backgroundColor: CropFreshColors.background60Card, // 60% background
      surfaceTintColor: CropFreshColors.green30Light, // 30% supporting tint
      elevation: 6, // Material 3 elevation
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Material 3 rounded corners
      ),
      titleTextStyle: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: TextStyle(
        color: CropFreshColors.onBackground60Secondary,
        fontSize: 16,
      ),
    ),

    // * SNACK BAR THEME (Material Design 3)
    snackBarTheme: SnackBarThemeData(
      backgroundColor: CropFreshColors.green30Dark, // 30% supporting color
      contentTextStyle: TextStyle(
        color: CropFreshColors.onGreen30,
      ),
      actionTextColor: CropFreshColors.orange10Light, // 10% action color
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Material 3 rounded corners
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    // * BOTTOM SHEET THEME (Material Design 3)
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: CropFreshColors.background60Card, // 60% background
      surfaceTintColor: CropFreshColors.green30Light, // 30% supporting tint
      elevation: 8, // Material 3 elevation
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), // Material 3 rounded corners
          topRight: Radius.circular(20),
        ),
      ),
    ),

    // * DIVIDER THEME (Material Design 3)
    dividerTheme: DividerThemeData(
      color: CropFreshColors.green30Primary.withValues(alpha: 0.1), // 30% supporting color
      thickness: 1,
      space: 1,
    ),

    // * PROGRESS INDICATOR THEME (Material Design 3)
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: CropFreshColors.green30Primary, // 30% supporting color
      linearTrackColor: CropFreshColors.green30Container, // 30% supporting color
      circularTrackColor: CropFreshColors.green30Container, // 30% supporting color
    ),

    // * SCAFFOLD BACKGROUND (60% Background)
    scaffoldBackgroundColor: CropFreshColors.background60Primary,

    // * CANVAS COLOR (60% Background)
    canvasColor: CropFreshColors.background60Secondary,

    // * TYPOGRAPHY (Material Design 3)
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 57,
        fontWeight: FontWeight.w400,
      ),
      displayMedium: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 45,
        fontWeight: FontWeight.w400,
      ),
      displaySmall: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      headlineLarge: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 32,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: TextStyle(
        color: CropFreshColors.onBackground60Secondary,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: CropFreshColors.onBackground60Secondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: TextStyle(
        color: CropFreshColors.onBackground60,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: CropFreshColors.onBackground60Secondary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: CropFreshColors.onBackground60Tertiary,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    ),
  );

  // ============================================================================
  // * DARK THEME CONFIGURATION (Material Design 3)
  // ============================================================================
  
  /// * Creates the dark theme for CropFresh app
  /// * Follows Material Design 3 specifications with proper dark color mappings
  /// * Maintains 60-30-10 rule with dark-adapted colors
  static ThemeData get darkTheme => ThemeData(
    // ! IMPORTANT: Enable Material Design 3
    useMaterial3: true,
    
    // * 60-30-10 COLOR SCHEME (Material Design 3 Dark)
    colorScheme: ColorScheme.fromSeed(
      seedColor: CropFreshColors.brandGreen,
      brightness: Brightness.dark,
      // 60% - Dark backgrounds
      surface: CropFreshColors.darkBackground60,
      surfaceContainerHighest: CropFreshColors.darkContainer60,
      // 30% - Green supporting elements (lighter for dark theme)
      primary: CropFreshColors.darkGreen30,
      primaryContainer: CropFreshColors.darkGreen30Container,
      // 10% - Orange action elements (softer for dark theme)
      secondary: CropFreshColors.darkOrange10,
      secondaryContainer: CropFreshColors.darkOrange10Container,
      // Semantic colors adapted for dark theme
      tertiary: CropFreshColors.green30Light,
      tertiaryContainer: CropFreshColors.darkGreen30Surface,
      error: CropFreshColors.errorSecondary,
      errorContainer: CropFreshColors.errorContainer,
    ),
    
    // * SCAFFOLD BACKGROUND (60% Dark Background)
    scaffoldBackgroundColor: CropFreshColors.darkBackground60,
    
    // * CANVAS COLOR (60% Dark Background)
    canvasColor: CropFreshColors.darkSurface60,
    
    // TODO: Add more dark theme configurations following the same pattern
    // NOTE: Additional dark theme properties can be added as needed
    // ? Should we add more specific dark theme customizations?
  );

  // ============================================================================
  // * UTILITY METHODS
  // ============================================================================
  
  /// * Get theme based on brightness
  /// * Returns appropriate theme following Material Design 3 specifications
  static ThemeData getTheme(Brightness brightness) {
    return brightness == Brightness.light ? lightTheme : darkTheme;
  }

  /// * Check if theme is dark
  /// * Utility method for conditional styling
  static bool isDarkTheme(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// * Get appropriate text color for background
  /// * Uses CropFreshColors utility method for accessibility
  static Color getTextColorForBackground(Color backgroundColor) {
    return CropFreshColors.getAccessibleTextColor(backgroundColor);
  }

  /// * Get semantic color for agricultural context
  /// * Follows 60-30-10 rule for agricultural features
  static Color getAgriculturalColor(String context) {
    switch (context.toLowerCase()) {
      case 'crop-excellent':
        return CropFreshColors.cropExcellent; // 30% green
      case 'crop-healthy':
        return CropFreshColors.cropHealthy; // 30% green
      case 'crop-moderate':
        return CropFreshColors.cropModerate; // 10% orange
      case 'crop-poor':
        return CropFreshColors.cropPoor; // 10% orange/red
      case 'background':
        return CropFreshColors.cropBackground; // 60% background
      default:
        return CropFreshColors.green30Primary; // 30% default
    }
  }
}

/// * THEME EXTENSIONS
/// * Custom theme extensions for CropFresh-specific styling
class CropFreshThemeExtension {
  // ! IMPORTANT: These extensions provide additional theming capabilities
  // * beyond standard Material Design 3 specifications
  
  /// * Agricultural status colors
  /// * Following 60-30-10 rule for agricultural context
  static const Map<String, Color> agriculturalColors = {
    'excellent': CropFreshColors.cropExcellent, // 30% green
    'healthy': CropFreshColors.cropHealthy, // 30% green
    'moderate': CropFreshColors.cropModerate, // 10% orange
    'poor': CropFreshColors.cropPoor, // 10% orange/red
    'background': CropFreshColors.cropBackground, // 60% background
  };

  /// * Financial status colors
  /// * Following 60-30-10 rule for financial context
  static const Map<String, Color> financialColors = {
    'profit': CropFreshColors.profit, // 30% green
    'loss': CropFreshColors.loss, // 10% orange/red
    'stable': CropFreshColors.priceStable, // neutral
    'background': CropFreshColors.financialBackground, // 60% background
  };

  /// * Weather status colors
  /// * Following color rule for weather context
  static const Map<String, Color> weatherColors = {
    'water': CropFreshColors.waterBlue, // 30% intensity
    'sunshine': CropFreshColors.sunshineYellow, // 10% intensity
    'background': CropFreshColors.sunshineBackground, // 60% background
  };
} 