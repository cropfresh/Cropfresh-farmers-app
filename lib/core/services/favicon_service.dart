// ===================================================================
// * FAVICON SERVICE
// * Purpose: Manage favicon assets and provide different sizes/formats
// * Features: Access to ICO, PNG, and SVG favicons in various sizes
// * Security Level: LOW - Asset management only
// ===================================================================

/// * FAVICON ASSET PATHS
/// * Contains static paths to all favicon assets
class FaviconAssets {
  // * Private constructor to prevent instantiation
  FaviconAssets._();

  // ============================================================================
  // * FAVICON PATHS
  // ============================================================================

  /// * ICO favicon for browser compatibility
  static const String faviconIco = 'assets/favicon/favicon.ico';

  /// * SVG favicon for scalable vector graphics
  static const String faviconSvg = 'assets/favicon/favicon.svg';

  /// * Apple touch icon for iOS home screen
  static const String appleTouchIcon = 'assets/favicon/apple-touch-icon.png';

  /// * 96x96 PNG favicon for high-DPI displays
  static const String favicon96 = 'assets/favicon/favicon-96x96.png';

  /// * 192x192 PNG for web app manifest
  static const String webApp192 = 'assets/favicon/web-app-manifest-192x192.png';

  /// * 512x512 PNG for web app manifest and splash screens
  static const String webApp512 = 'assets/favicon/web-app-manifest-512x512.png';

  /// * Web manifest file
  static const String siteWebmanifest = 'assets/favicon/site.webmanifest';

  // ============================================================================
  // * FAVICON SIZE VARIANTS
  // ============================================================================

  /// * Get favicon path by size
  static String getFaviconBySize(int size) {
    switch (size) {
      case 96:
        return favicon96;
      case 192:
        return webApp192;
      case 512:
        return webApp512;
      case 180: // Apple touch icon size
        return appleTouchIcon;
      default:
        return favicon96; // Default to 96x96
    }
  }

  /// * Get all favicon sizes available
  static List<int> get availableSizes => [96, 180, 192, 512];

  /// * Get vector favicon (SVG)
  static String get vectorFavicon => faviconSvg;

  /// * Get default favicon (ICO)
  static String get defaultFavicon => faviconIco;
}

/// * FAVICON SERVICE
/// * Provides methods to work with favicon assets
class FaviconService {
  // * Private constructor to prevent instantiation
  FaviconService._();

  // ============================================================================
  // * FAVICON UTILITIES
  // ============================================================================

  /// * Get the best favicon for the given size
  static String getBestFavicon(int requestedSize) {
    // * Find the closest available size
    final availableSizes = FaviconAssets.availableSizes;
    availableSizes.sort(
      (a, b) => (a - requestedSize).abs().compareTo((b - requestedSize).abs()),
    );

    return FaviconAssets.getFaviconBySize(availableSizes.first);
  }

  /// * Get favicon for app icons (512x512 for high quality)
  static String getAppIcon() => FaviconAssets.webApp512;

  /// * Get favicon for notifications (192x192 standard)
  static String getNotificationIcon() => FaviconAssets.webApp192;

  /// * Get favicon for splash screen (512x512 for high quality)
  static String getSplashIcon() => FaviconAssets.webApp512;

  /// * Get favicon for sharing (512x512 for social media)
  static String getSharingIcon() => FaviconAssets.webApp512;

  /// * Check if favicon size is available
  static bool isSizeAvailable(int size) {
    return FaviconAssets.availableSizes.contains(size);
  }

  /// * Get all favicon metadata
  static Map<String, dynamic> getFaviconMetadata() {
    return {
      'name': 'CropFresh',
      'fullName': 'CropFresh - Farmers App',
      'description': 'Empowering Farmers with Technology',
      'themeColor': '#228B22',
      'backgroundColor': '#FFFBFF',
      'availableSizes': FaviconAssets.availableSizes,
      'defaultIcon': FaviconAssets.defaultFavicon,
      'vectorIcon': FaviconAssets.vectorFavicon,
    };
  }
}
