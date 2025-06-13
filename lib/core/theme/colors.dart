import 'package:flutter/material.dart';

/// CropFresh Color Palette (Corrected 60-30-10 Rule)
/// 60% - Light & Warm Backgrounds (Dominant, Clean Foundation)
/// 30% - Green Colors (Supporting, Agricultural Identity)
/// 10% - Orange Colors (Highlights, Actions & CTAs)
class CropFreshColors {
  // Private constructor to prevent instantiation
  CropFreshColors._();

  // ============================================================================
  // BRAND COLORS (From Logo Analysis)
  // ============================================================================

  /// Main brand green from logo
  static const Color brandGreen = Color(0xFF228B22);

  /// Orange accent from logo
  static const Color brandOrange = Color(0xFFFF5722);

  /// Fresh light green from logo
  static const Color brandLightGreen = Color(0xFF4CAF50);

  // ============================================================================
  // 60% - LIGHT & WARM BACKGROUNDS (DOMINANT)
  // ============================================================================

  /// Light & Warm Background Family - used for 60% of the interface
  static const Color background60Primary = Color(
    0xFFFFFBFF,
  ); // Pure white with warm tint
  static const Color background60Secondary = Color(
    0xFFFAF9F7,
  ); // Warm off-white
  static const Color background60Tertiary = Color(0xFFF8F6F4); // Cream white
  static const Color background60Container = Color(0xFFF5F5F5); // Light gray
  static const Color background60Card = Color(
    0xFFFFFFFF,
  ); // Pure white for cards

  /// Warm Light Tones (60% usage)
  static const Color warm60Light = Color(0xFFFFF8E1); // Warm cream
  static const Color warm60Beige = Color(0xFFF5F5DC); // Light beige
  static const Color warm60Ivory = Color(0xFFFFFFF0); // Ivory white
  static const Color warm60Snow = Color(0xFFFFFAFA); // Snow white with warmth
  static const Color warm60Linen = Color(0xFFFAF0E6); // Linen white
  static const Color warm60Pearl = Color(0xFFF8F6F0); // Pearl white

  /// Surface Colors for Main Areas (60% usage)
  static const Color surface60Primary = Color(0xFFFFFBFF); // Main surfaces
  static const Color surface60Secondary = Color(
    0xFFF7F7F7,
  ); // Secondary surfaces
  static const Color surface60Container = Color(
    0xFFF9F9F9,
  ); // Container surfaces
  static const Color surface60Modal = Color(0xFFFFFFFF); // Modal backgrounds

  /// Text on Light Backgrounds (60% usage)
  static const Color onBackground60 = Color(0xFF1C1B1F); // Primary dark text
  static const Color onBackground60Secondary = Color(
    0xFF49454F,
  ); // Secondary text
  static const Color onBackground60Tertiary = Color(
    0xFF79747E,
  ); // Tertiary text
  static const Color onBackground60Disabled = Color(
    0xFFC4C7C5,
  ); // Disabled text

  // ============================================================================
  // 30% - GREEN COLORS (SUPPORTING ELEMENTS)
  // ============================================================================

  /// Green Family - used for 30% of the interface (Supporting Elements)
  static const Color green30Primary = Color(0xFF228B22); // Main brand green
  static const Color green30Light = Color(0xFF4CAF50); // Light green
  static const Color green30Dark = Color(0xFF1B5E20); // Dark green
  static const Color green30Container = Color(
    0xFFE8F5E8,
  ); // Light green background
  static const Color green30Surface = Color(
    0xFFF1F8E9,
  ); // Very light green surface

  /// Green Variations for Different Elements (30% usage)
  static const Color green30Fresh = Color(
    0xFF66BB6A,
  ); // Fresh green for success
  static const Color green30Forest = Color(
    0xFF2E7D32,
  ); // Forest green for depth
  static const Color green30Mint = Color(
    0xFFA5D6A7,
  ); // Mint green for light accents
  static const Color green30Sage = Color(
    0xFF81C784,
  ); // Sage green for subtle elements
  static const Color green30Emerald = Color(
    0xFF00C853,
  ); // Emerald for highlights
  static const Color green30Olive = Color(
    0xFF689F38,
  ); // Olive green for natural feel

  /// Navigation and Branding (30% usage)
  static const Color navigation30Selected = Color(
    0xFF228B22,
  ); // Selected nav items
  static const Color navigation30Indicator = Color(
    0xFF4CAF50,
  ); // Active indicators
  static const Color brand30Primary = Color(0xFF228B22); // Primary brand usage
  static const Color brand30Secondary = Color(
    0xFF2E7D32,
  ); // Secondary brand usage

  /// Text on Green (30% usage)
  static const Color onGreen30 = Color(0xFFFFFFFF); // White text on green
  static const Color onGreen30Container = Color(
    0xFF0D4F0D,
  ); // Dark text on light green
  static const Color onGreen30Surface = Color(
    0xFF1B5E20,
  ); // Dark text on green surface

  // ============================================================================
  // 10% - ORANGE COLORS (HIGHLIGHTS & ACTIONS)
  // ============================================================================

  /// Orange Family - used for 10% of the interface (Highlights & Actions)
  static const Color orange10Primary = Color(0xFFFF5722); // Main brand orange
  static const Color orange10Bright = Color(
    0xFFFF8F00,
  ); // Bright orange for CTAs
  static const Color orange10Light = Color(0xFFFFB74D); // Light orange
  static const Color orange10Dark = Color(0xFFE64A19); // Dark orange
  static const Color orange10Container = Color(
    0xFFFFF3E0,
  ); // Light orange background

  /// Orange Action Variations (10% usage)
  static const Color orange10Vibrant = Color(
    0xFFFF7043,
  ); // Vibrant orange for emphasis
  static const Color orange10Warm = Color(
    0xFFFFAB40,
  ); // Warm orange for comfort
  static const Color orange10Sunset = Color(
    0xFFFF6F00,
  ); // Sunset orange for beauty
  static const Color orange10Amber = Color(
    0xFFFFB300,
  ); // Amber orange for warmth
  static const Color orange10Coral = Color(
    0xFFFF5722,
  ); // Coral orange for energy
  static const Color orange10Tangerine = Color(
    0xFFFF9800,
  ); // Tangerine for freshness

  /// Call-to-Action Colors (10% usage)
  static const Color cta10Primary = Color(0xFFFF5722); // Primary action buttons
  static const Color cta10Secondary = Color(
    0xFFFF8F00,
  ); // Secondary action buttons
  static const Color cta10Emergency = Color(
    0xFFFF3D00,
  ); // Emergency/urgent actions
  static const Color cta10Success = Color(
    0xFFFF9800,
  ); // Success action completion

  /// Text on Orange (10% usage)
  static const Color onOrange10 = Color(0xFFFFFFFF); // White text on orange
  static const Color onOrange10Container = Color(
    0xFF5D2D00,
  ); // Dark text on light orange
  static const Color onOrange10Light = Color(
    0xFF1A1A1A,
  ); // Dark text on light orange

  // ============================================================================
  // SEMANTIC COLORS (Following 60-30-10 Rule)
  // ============================================================================

  /// Success States (Using Green 30% + Light Backgrounds 60%)
  static const Color successPrimary = Color(0xFF4CAF50); // Green success (30%)
  static const Color successSecondary = Color(
    0xFF81C784,
  ); // Light green success (30%)
  static const Color successContainer = Color(
    0xFFF1F8E9,
  ); // Light success background (60%)
  static const Color successHighlight = Color(
    0xFF66BB6A,
  ); // Success highlight (30%)
  static const Color onSuccess = Color(0xFFFFFFFF); // Text on success
  static const Color onSuccessContainer = Color(
    0xFF1B5E20,
  ); // Text on success container

  /// Warning States (Using Orange 10% + Light Backgrounds 60%)
  static const Color warningPrimary = Color(0xFFFF9800); // Orange warning (10%)
  static const Color warningSecondary = Color(
    0xFFFFB74D,
  ); // Light orange warning (10%)
  static const Color warningContainer = Color(
    0xFFFFF8E1,
  ); // Light warning background (60%)
  static const Color warningHighlight = Color(
    0xFFFFAB40,
  ); // Warning highlight (10%)
  static const Color onWarning = Color(0xFFFFFFFF); // Text on warning
  static const Color onWarningContainer = Color(
    0xFFE65100,
  ); // Text on warning container

  /// Error States (Using Orange 10% Intensity + Light Backgrounds 60%)
  static const Color errorPrimary = Color(
    0xFFD32F2F,
  ); // Red error (10% intensity)
  static const Color errorSecondary = Color(0xFFEF5350); // Light red error
  static const Color errorContainer = Color(
    0xFFFFF5F5,
  ); // Light error background (60%)
  static const Color errorHighlight = Color(0xFFFF5252); // Error highlight
  static const Color onError = Color(0xFFFFFFFF); // Text on error
  static const Color onErrorContainer = Color(
    0xFFB71C1C,
  ); // Text on error container

  /// Information States (Using Green 30% Intensity + Light Backgrounds 60%)
  static const Color infoPrimary = Color(
    0xFF1976D2,
  ); // Blue info (30% intensity)
  static const Color infoSecondary = Color(0xFF64B5F6); // Light blue info
  static const Color infoContainer = Color(
    0xFFF8F9FA,
  ); // Light info background (60%)
  static const Color infoHighlight = Color(0xFF42A5F5); // Info highlight
  static const Color onInfo = Color(0xFFFFFFFF); // Text on info
  static const Color onInfoContainer = Color(
    0xFF0D47A1,
  ); // Text on info container

  // ============================================================================
  // AGRICULTURAL CONTEXT COLORS (Following 60-30-10 Rule)
  // ============================================================================

  /// Crop Health Indicators (Using 30% Green + 10% Orange + 60% Light)
  static const Color cropExcellent = Color(
    0xFF2E7D32,
  ); // Excellent crop health (30%)
  static const Color cropHealthy = Color(0xFF4CAF50); // Healthy crops (30%)
  static const Color cropModerate = Color(0xFFFF9800); // Needs attention (10%)
  static const Color cropPoor = Color(0xFFFF5722); // Poor health (10%)
  static const Color cropBackground = Color(
    0xFFF8F9FA,
  ); // Crop info background (60%)

  /// Agricultural Elements (Following Color Rule)
  static const Color soilRich = Color(0xFF8D6E63); // Rich soil (30% intensity)
  static const Color soilPoor = Color(0xFFBCAAA4); // Poor soil (30% intensity)
  static const Color soilBackground = Color(
    0xFFFAF9F7,
  ); // Soil info background (60%)

  static const Color waterBlue = Color(
    0xFF2196F3,
  ); // Water/irrigation (30% intensity)
  static const Color waterBackground = Color(
    0xFFF8F9FA,
  ); // Water info background (60%)

  static const Color sunshineYellow = Color(
    0xFFFFC107,
  ); // Weather/sunshine (10% intensity)
  static const Color sunshineBackground = Color(
    0xFFFFF8E1,
  ); // Sunshine background (60%)

  /// Market/Financial Indicators (Following Color Rule)
  static const Color priceUp = Color(0xFF4CAF50); // Price increase (30%)
  static const Color priceDown = Color(0xFFFF5722); // Price decrease (10%)
  static const Color priceStable = Color(0xFF757575); // Stable price (neutral)
  static const Color priceBackground = Color(
    0xFFFFFBFF,
  ); // Price background (60%)

  static const Color profit = Color(0xFF2E7D32); // Profit indicator (30%)
  static const Color loss = Color(0xFFFF3D00); // Loss indicator (10%)
  static const Color financialBackground = Color(
    0xFFF9F9F9,
  ); // Financial background (60%)

  // ============================================================================
  // DARK MODE COLORS (Maintaining 60-30-10 Rule)
  // ============================================================================

  /// Dark Theme 60% - Dark Backgrounds
  static const Color darkBackground60 = Color(
    0xFF121212,
  ); // Main dark background
  static const Color darkSurface60 = Color(0xFF1E1E1E); // Dark surfaces
  static const Color darkContainer60 = Color(0xFF2C2C2C); // Dark containers
  static const Color darkCard60 = Color(0xFF1F1F1F); // Dark cards
  static const Color onDarkBackground60 = Color(
    0xFFE0E0E0,
  ); // Light text on dark
  static const Color onDarkSurface60 = Color(
    0xFFCCCCCC,
  ); // Secondary light text

  /// Dark Theme 30% - Green Elements (Lighter/Desaturated)
  static const Color darkGreen30 = Color(
    0xFF4CAF50,
  ); // Lighter green for dark mode
  static const Color darkGreen30Container = Color(
    0xFF2E3A2E,
  ); // Dark green container
  static const Color darkGreen30Surface = Color(
    0xFF1A2E1A,
  ); // Dark green surface
  static const Color onDarkGreen30 = Color(
    0xFFE8F5E8,
  ); // Light text on dark green

  // * Additional Material 3 colors for forms and components
  static const Color surface = Color(0xFFFEFEFE);
  static const Color outline = Color(0xFF79767D);
  static const Color error = Color(0xFFB3261E);

  /// Dark Theme 10% - Orange Highlights (Softer)
  static const Color darkOrange10 = Color(
    0xFFFFB74D,
  ); // Softer orange for dark mode
  static const Color darkOrange10Container = Color(
    0xFF3A2E1A,
  ); // Dark orange container
  static const Color darkOrange10Surface = Color(
    0xFF2E1A0A,
  ); // Dark orange surface
  static const Color onDarkOrange10 = Color(
    0xFFFFF3E0,
  ); // Light text on dark orange

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get color with opacity (Material 3 compatible)
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get contrast color (black or white) for given background
  static Color getContrastColor(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Get appropriate text color for given background following 60-30-10 rule
  static Color getTextColor(Color backgroundColor) {
    final double luminance = backgroundColor.computeLuminance();
    if (luminance > 0.5) {
      return onBackground60; // Dark text on light background (60%)
    } else {
      return onDarkBackground60; // Light text on dark background
    }
  }

  /// Get color for crop health status (following 30% green, 10% orange rule)
  static Color getCropHealthColor(double healthPercentage) {
    if (healthPercentage >= 90) return cropExcellent; // 30% green
    if (healthPercentage >= 70) return cropHealthy; // 30% green
    if (healthPercentage >= 50) return cropModerate; // 10% orange
    return cropPoor; // 10% orange (red variant)
  }

  /// Get color for price change (following 30% green, 10% orange rule)
  static Color getPriceChangeColor(double changePercentage) {
    if (changePercentage > 0) return priceUp; // 30% green
    if (changePercentage < 0) return priceDown; // 10% orange
    return priceStable; // Neutral
  }

  /// Get background color following 60% rule
  static Color getBackgroundColor(String context) {
    switch (context.toLowerCase()) {
      case 'primary':
        return background60Primary;
      case 'secondary':
        return background60Secondary;
      case 'card':
        return background60Card;
      case 'container':
        return background60Container;
      case 'modal':
        return surface60Modal;
      default:
        return background60Primary;
    }
  }

  /// Get supporting color following 30% green rule
  static Color getSupportingColor(String context) {
    switch (context.toLowerCase()) {
      case 'navigation':
        return navigation30Selected;
      case 'brand':
        return brand30Primary;
      case 'success':
        return successPrimary;
      case 'info':
        return green30Light;
      default:
        return green30Primary;
    }
  }

  /// Get action color following 10% orange rule
  static Color getActionColor(String context) {
    switch (context.toLowerCase()) {
      case 'primary':
        return cta10Primary;
      case 'secondary':
        return cta10Secondary;
      case 'emergency':
        return cta10Emergency;
      case 'warning':
        return warningPrimary;
      case 'error':
        return errorPrimary;
      default:
        return orange10Primary;
    }
  }

  // ============================================================================
  // COLOR PALETTES FOR SPECIFIC FEATURES (Following 60-30-10 Rule)
  // ============================================================================

  /// Dashboard color palette
  static const List<Color> dashboardPalette = [
    background60Primary, // Main background (60%)
    green30Container, // Feature sections (30%)
    orange10Bright, // Action buttons (10%)
  ];

  /// Marketplace color palette
  static const List<Color> marketplacePalette = [
    background60Card, // Product cards background (60%)
    green30Light, // Product status indicators (30%)
    orange10Primary, // Buy/sell buttons (10%)
  ];

  /// Weather color palette
  static const List<Color> weatherPalette = [
    background60Secondary, // Weather widget background (60%)
    waterBlue, // Water/humidity indicators (30% intensity)
    sunshineYellow, // Temperature highlights (10% intensity)
  ];

  /// Financial color palette
  static const List<Color> financialPalette = [
    financialBackground, // Charts background (60%)
    profit, // Positive values (30% green)
    loss, // Negative values (10% orange/red)
  ];

  /// Authentication color palette
  static const List<Color> authPalette = [
    background60Primary, // Form backgrounds (60%)
    green30Container, // Success states (30%)
    orange10Primary, // Action buttons (10%)
  ];

  // ============================================================================
  // GRADIENT DEFINITIONS (Following 60-30-10 Rule)
  // ============================================================================

  /// Light background gradients (60% usage)
  static const LinearGradient backgroundGradient60 = LinearGradient(
    colors: [background60Primary, background60Secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Green supporting gradients (30% usage)
  static const LinearGradient supportingGradient30 = LinearGradient(
    colors: [green30Light, green30Primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Orange action gradients (10% usage)
  static const LinearGradient actionGradient10 = LinearGradient(
    colors: [orange10Primary, orange10Vibrant],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Success gradient (30% green theme)
  static const LinearGradient successGradient = LinearGradient(
    colors: [successPrimary, green30Fresh],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Agricultural theme gradient (combining all rules)
  static const LinearGradient agriculturalGradient = LinearGradient(
    colors: [
      background60Primary, // Light foundation (60%)
      green30Container, // Green middle (30%)
      orange10Container, // Orange highlight (10%)
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: [0.0, 0.6, 1.0], // Reflecting 60-30-10 distribution
  );

  /// Card elevation gradient (60% light theme)
  static const LinearGradient cardGradient = LinearGradient(
    colors: [background60Card, background60Container],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================================================
  // ACCESSIBILITY HELPERS
  // ============================================================================

  /// Check if color combination meets WCAG contrast requirements
  static bool meetsContrastRequirement(Color foreground, Color background) {
    final double fgLuminance = foreground.computeLuminance();
    final double bgLuminance = background.computeLuminance();
    final double contrast = (fgLuminance + 0.05) / (bgLuminance + 0.05);
    return contrast >= 4.5; // WCAG AA standard
  }

  /// Get accessible text color for any background
  static Color getAccessibleTextColor(Color backgroundColor) {
    if (meetsContrastRequirement(onBackground60, backgroundColor)) {
      return onBackground60;
    } else if (meetsContrastRequirement(onDarkBackground60, backgroundColor)) {
      return onDarkBackground60;
    } else {
      // Fallback to high contrast
      return backgroundColor.computeLuminance() > 0.5
          ? Colors.black
          : Colors.white;
    }
  }

  // ============================================================================
  // THEMED COLOR COLLECTIONS
  // ============================================================================

  /// Get complete color theme for light mode
  static Map<String, Color> get lightTheme => {
    // 60% - Backgrounds
    'primaryBackground': background60Primary,
    'secondaryBackground': background60Secondary,
    'cardBackground': background60Card,
    'containerBackground': background60Container,

    // 30% - Supporting elements
    'primarySupporting': green30Primary,
    'secondarySupporting': green30Light,
    'navigationSelected': navigation30Selected,
    'brandPrimary': brand30Primary,

    // 10% - Actions and highlights
    'primaryAction': orange10Primary,
    'secondaryAction': orange10Bright,
    'emergencyAction': cta10Emergency,
    'warningHighlight': warningPrimary,

    // Text colors
    'primaryText': onBackground60,
    'secondaryText': onBackground60Secondary,
    'tertiaryText': onBackground60Tertiary,
  };

  /// Get complete color theme for dark mode
  static Map<String, Color> get darkTheme => {
    // 60% - Dark backgrounds
    'primaryBackground': darkBackground60,
    'secondaryBackground': darkSurface60,
    'cardBackground': darkCard60,
    'containerBackground': darkContainer60,

    // 30% - Supporting elements
    'primarySupporting': darkGreen30,
    'secondarySupporting': green30Light,
    'navigationSelected': darkGreen30,
    'brandPrimary': darkGreen30,

    // 10% - Actions and highlights
    'primaryAction': darkOrange10,
    'secondaryAction': orange10Light,
    'emergencyAction': cta10Emergency,
    'warningHighlight': warningPrimary,

    // Text colors
    'primaryText': onDarkBackground60,
    'secondaryText': onDarkSurface60,
    'tertiaryText': onDarkSurface60,
  };
}

/// Extension methods for Color class
extension CropFreshColorExtensions on Color {
  /// Get a lighter shade of the color (useful for 60% backgrounds)
  Color lighter([double amount = 0.1]) {
    return Color.lerp(this, Colors.white, amount) ?? this;
  }

  /// Get a darker shade of the color (useful for 30% supporting elements)
  Color darker([double amount = 0.1]) {
    return Color.lerp(this, Colors.black, amount) ?? this;
  }

  /// Get a more vibrant version (useful for 10% action elements)
  Color vibrant([double amount = 0.2]) {
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl
        .withSaturation((hsl.saturation + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Check if color is light (useful for determining if it's a 60% background)
  bool get isLight => computeLuminance() > 0.5;

  /// Check if color is dark
  bool get isDark => computeLuminance() <= 0.5;

  /// Get appropriate text color for this background following 60-30-10 rule
  Color get appropriateTextColor {
    return CropFreshColors.getAccessibleTextColor(this);
  }

  /// Convert to agricultural context (adds slight green tint for 30% elements)
  Color get agriculturalTint {
    return Color.lerp(this, CropFreshColors.green30Light, 0.1) ?? this;
  }

  /// Convert to action context (adds slight orange tint for 10% elements)
  Color get actionTint {
    return Color.lerp(this, CropFreshColors.orange10Light, 0.1) ?? this;
  }
}
