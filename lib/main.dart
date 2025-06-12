import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen_v2.dart';
import 'features/home/home_screen.dart';

/// * CROPFRESH FARMERS APP
/// * Main application entry point following Material Design 3 principles
/// * Implements splash screen with animated logo and proper navigation
/// * Uses 60-30-10 color rule throughout the application
void main() {
  // * INITIALIZE APP
  WidgetsFlutterBinding.ensureInitialized();

  // ! SECURITY: Set preferred device orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // * RUN APP
  runApp(const CropFreshApp());
}

/// * CROPFRESH APPLICATION ROOT
/// * Root application widget that sets up theme and navigation
/// * Follows Material Design 3 specifications with custom CropFresh theme
class CropFreshApp extends StatelessWidget {
  const CropFreshApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // * APP METADATA
      title: 'CropFresh - Empowering Farmers',
      debugShowCheckedModeBanner: false, // Remove debug banner for clean UI
      // * MATERIAL DESIGN 3 THEME CONFIGURATION
      theme: CropFreshTheme.lightTheme, // Light theme following 60-30-10 rule
      darkTheme: CropFreshTheme.darkTheme, // Dark theme adaptation
      themeMode: ThemeMode.system, // Respect system theme preference
      // * INITIAL SCREEN: Start with splash screen
      home: const CropFreshSplashWrapper(),

      // * MATERIAL APP CONFIGURATION
      builder: (context, child) {
        // * RESPONSIVE DESIGN: Handle different screen sizes
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
              minScaleFactor: 0.8, // Minimum text scale
              maxScaleFactor: 1.2, // Maximum text scale
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// * SPLASH SCREEN WRAPPER
/// * Handles splash screen display and navigation to main app
/// * Manages the transition from splash to home screen
class CropFreshSplashWrapper extends StatefulWidget {
  const CropFreshSplashWrapper({super.key});

  @override
  State<CropFreshSplashWrapper> createState() => _CropFreshSplashWrapperState();
}

class _CropFreshSplashWrapperState extends State<CropFreshSplashWrapper> {
  /// * Current screen state
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// * Initialize application
  /// * Performs any necessary app initialization tasks
  Future<void> _initializeApp() async {
    try {
      // * INITIALIZATION TASKS
      // TODO: Initialize database
      // TODO: Load user preferences
      // TODO: Check authentication status
      // TODO: Fetch initial data

      // * Simulate initialization time (minimum 2 seconds for UX)
      await Future.delayed(const Duration(milliseconds: 2000));

      // NOTE: Additional initialization can be added here
    } catch (error) {
      // ! ERROR HANDLING: Log initialization errors
      debugPrint('App initialization error: $error');

      // FIXME: Implement proper error handling and user notification
    }
  }

  /// * Handle splash completion
  /// * Called when splash screen animation completes
  void _onSplashComplete() {
    if (mounted) {
      setState(() {
        _showSplash = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // * CONDITIONAL RENDERING: Show splash or main app
    if (_showSplash) {
      // * SPLASH SCREEN: Animated logo and branding
      return CropFreshSplashScreenV2(onSplashComplete: _onSplashComplete);
    } else {
      // * MAIN APP: Navigate to home screen
      return const CropFreshHomeScreen();
    }
  }
}
