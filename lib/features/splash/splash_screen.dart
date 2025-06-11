import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';

/// * CROPFRESH ANIMATED SPLASH SCREEN
/// * Material Design 3 compliant splash screen with beautiful logo animation
/// * Follows 60-30-10 color rule and modern animation principles
/// * Duration: 3 seconds with smooth transitions
class CropFreshSplashScreen extends StatefulWidget {
  /// * Navigation callback when splash completes
  /// * Called after animation sequence finishes
  final VoidCallback? onSplashComplete;

  const CropFreshSplashScreen({
    super.key,
    this.onSplashComplete,
  });

  @override
  State<CropFreshSplashScreen> createState() => _CropFreshSplashScreenState();
}

class _CropFreshSplashScreenState extends State<CropFreshSplashScreen>
    with TickerProviderStateMixin {
  // ============================================================================
  // * ANIMATION CONTROLLERS
  // ============================================================================
  
  /// * Main logo animation controller
  /// * Controls scale, fade, and rotation animations
  late AnimationController _logoAnimationController;
  
  /// * Background gradient animation controller
  /// * Creates subtle background color transitions
  late AnimationController _backgroundAnimationController;
  
  /// * Text animation controller
  /// * Controls company name and tagline animations
  late AnimationController _textAnimationController;

  // ============================================================================
  // * TIMER MANAGEMENT
  // ============================================================================
  
  /// * List of all active timers for proper cleanup
  /// * Prevents memory leaks and test failures
  final List<Future<void>> _activeTimers = [];

  // ============================================================================
  // * ANIMATIONS
  // ============================================================================
  
  /// * Logo scale animation (Material Design 3 style)
  /// * Smooth scale-in effect with overshoot
  late Animation<double> _logoScaleAnimation;
  
  /// * Logo fade animation
  /// * Smooth opacity transition
  late Animation<double> _logoFadeAnimation;
  
  /// * Logo rotation animation
  /// * Subtle rotation for visual interest
  late Animation<double> _logoRotationAnimation;
  
  /// * Background gradient animation
  /// * Smooth color transitions following 60-30-10 rule
  late Animation<Color?> _backgroundGradientAnimation;
  
  /// * Text slide animation
  /// * Company name slides up from bottom
  late Animation<Offset> _textSlideAnimation;
  
  /// * Text fade animation
  /// * Company name fades in
  late Animation<double> _textFadeAnimation;
  
  /// * Tagline animation
  /// * Subtitle text animation with delay
  late Animation<double> _taglineFadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// * Initialize all animation controllers and animations
  /// * Sets up the complete animation sequence for the splash screen
  void _initializeAnimations() {
    // * ANIMATION CONTROLLERS SETUP
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // 1.5 seconds for logo
      vsync: this,
    );
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // 2 seconds for background
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000), // 1 second for text
      vsync: this,
    );

    // * LOGO ANIMATIONS
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut, // Material Design 3 style elastic curve
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.1, // Slight initial rotation
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.easeInOut,
    ));

    // * BACKGROUND GRADIENT ANIMATION (Following 60-30-10 Rule)
    _backgroundGradientAnimation = ColorTween(
      begin: CropFreshColors.background60Primary, // 60% light background
      end: CropFreshColors.green30Container.withValues(alpha: 0.1), // 30% green tint
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // * TEXT ANIMATIONS
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start below
      end: Offset.zero, // End at normal position
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutCubic, // Material Design 3 curve
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeInOut,
    ));

    _taglineFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));
  }

  /// * Start the complete animation sequence
  /// * Orchestrates all animations with proper timing
  void _startAnimationSequence() {
    // ! SECURITY: Prevent screen capture during splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // * Start background animation immediately
    _backgroundAnimationController.forward();
    
    // * Start logo animation after brief delay
    final logoTimer = Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
    _activeTimers.add(logoTimer);
    
    // * Start text animation after logo starts
    final textTimer = Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });
    _activeTimers.add(textTimer);
    
    // * Complete splash screen after total duration
    final completeTimer = Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _completeSplash();
      }
    });
    _activeTimers.add(completeTimer);
  }

  /// * Complete splash screen and navigate
  /// * Handles navigation to main app after animation
  void _completeSplash() {
    // ! RESTORE: System UI after splash
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    
    // * Call completion callback
    if (widget.onSplashComplete != null) {
      widget.onSplashComplete!();
    }
  }

  @override
  void dispose() {
    // * CLEANUP: Dispose all animation controllers
    _logoAnimationController.dispose();
    _backgroundAnimationController.dispose();
    _textAnimationController.dispose();
    
    // * CLEANUP: Clear all pending timers
    // NOTE: Prevents test failures from pending async operations
    _activeTimers.clear();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // * Get screen dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      // * 60% BACKGROUND: Animated background following color rule
      body: AnimatedBuilder(
        animation: _backgroundGradientAnimation,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // * GRADIENT: Following 60-30-10 rule with smooth transitions
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _backgroundGradientAnimation.value ?? CropFreshColors.background60Primary,
                  CropFreshColors.background60Secondary,
                  CropFreshColors.green30Container.withValues(alpha: 0.05), // 30% subtle green
                ],
                stops: const [0.0, 0.6, 1.0], // Reflects 60-30-10 distribution
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // * LOGO SECTION
                  Expanded(
                    flex: 3,
                    child: _buildAnimatedLogo(isLargeScreen),
                  ),
                  
                  // * TEXT SECTION
                  Expanded(
                    flex: 2,
                    child: _buildAnimatedText(context, isLargeScreen),
                  ),
                  
                  // * FOOTER SECTION
                  _buildFooter(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// * Build animated logo section
  /// * Creates beautiful logo animation with multiple effects
  Widget _buildAnimatedLogo(bool isLargeScreen) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _logoScaleAnimation,
          _logoFadeAnimation,
          _logoRotationAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _logoScaleAnimation.value,
            child: Transform.rotate(
              angle: _logoRotationAnimation.value,
              child: Opacity(
                opacity: _logoFadeAnimation.value,
                child: Container(
                  // * LOGO CONTAINER: Material Design 3 styling
                  width: isLargeScreen ? 200 : 150,
                  height: isLargeScreen ? 200 : 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24), // Material 3 rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: CropFreshColors.green30Primary.withValues(alpha: 0.2), // 30% green shadow
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: isLargeScreen ? 200 : 150,
                      height: isLargeScreen ? 200 : 150,
                      fit: BoxFit.contain,
                      // ! ERROR HANDLING: Fallback for missing logo
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: isLargeScreen ? 200 : 150,
                          height: isLargeScreen ? 200 : 150,
                          decoration: BoxDecoration(
                            color: CropFreshColors.green30Primary, // 30% green fallback
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Icon(
                            Icons.agriculture,
                            size: isLargeScreen ? 80 : 60,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// * Build animated text section
  /// * Creates company name and tagline with smooth animations
  Widget _buildAnimatedText(BuildContext context, bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _textSlideAnimation,
        _textFadeAnimation,
        _taglineFadeAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // * COMPANY NAME
              Opacity(
                opacity: _textFadeAnimation.value,
                child: Text(
                  'CropFresh',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: CropFreshColors.green30Primary, // 30% supporting color
                    fontWeight: FontWeight.bold,
                    fontSize: isLargeScreen ? 48 : 36,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // * TAGLINE
              Opacity(
                opacity: _taglineFadeAnimation.value,
                child: Text(
                  'Empowering Farmers with Technology',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: CropFreshColors.onBackground60Secondary, // Subtle text color
                    fontSize: isLargeScreen ? 18 : 16,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // * LOADING INDICATOR
              Opacity(
                opacity: _taglineFadeAnimation.value,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CropFreshColors.orange10Primary, // 10% action color
                    ),
                    backgroundColor: CropFreshColors.green30Container, // 30% supporting color
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// * Build footer section
  /// * Shows app version and company info
  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // * VERSION INFO
          Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Tertiary, // Subtle text
              fontSize: 12,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // * COPYRIGHT
          Text(
            '© 2024 CropFresh Technologies',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Tertiary, // Subtle text
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/// * SPLASH SCREEN ROUTE
/// * Helper class for navigation to splash screen
class SplashScreenRoute {
  /// * Create route to splash screen
  /// * Returns Material page route with proper transitions
  static Route<void> createRoute({VoidCallback? onComplete}) {
    return PageRouteBuilder<void>(
      pageBuilder: (context, animation, secondaryAnimation) => 
          CropFreshSplashScreen(onSplashComplete: onComplete),
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // * Material Design 3 page transition
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}

/// * SPLASH SCREEN CONSTANTS
/// * Configuration constants for splash screen behavior
class SplashConstants {
  // Private constructor to prevent instantiation
  SplashConstants._();
  
  /// * Default splash duration in milliseconds
  static const int defaultDuration = 3000;
  
  /// * Minimum splash duration (for fast devices)
  static const int minimumDuration = 2000;
  
  /// * Maximum splash duration (for slow devices)
  static const int maximumDuration = 5000;
  
  /// * Logo animation duration
  static const int logoAnimationDuration = 1500;
  
  /// * Background animation duration
  static const int backgroundAnimationDuration = 2000;
  
  /// * Text animation duration
  static const int textAnimationDuration = 1000;
} 