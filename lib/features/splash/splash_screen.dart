import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';

/// * CROPFRESH IMPROVED ANDROID SPLASH SCREEN
/// * Optimized for Android devices with Material Design 3 principles
/// * Features: Clean animations, proper scaling, performance optimized
/// * Android-first design with responsive layout and smooth transitions
class CropFreshSplashScreen extends StatefulWidget {
  /// * Navigation callback when splash completes
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
  
  /// * Primary animation controller for the entire splash sequence
  late AnimationController _primaryController;
  
  /// * Logo animation controller with optimized timing
  late AnimationController _logoController;
  
  /// * Text animation controller for brand text
  late AnimationController _textController;

  // ============================================================================
  // * OPTIMIZED ANIMATIONS
  // ============================================================================
  
  /// * Logo animations with smooth curves
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotationAnimation;
  
  /// * Brand text animations
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  /// * Background gradient animation
  late Animation<double> _backgroundAnimation;
  
  /// * Exit transition animation
  late Animation<double> _exitFadeAnimation;

  /// * Progress indicator animation
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startSplashSequence();
  }

  /// * Initialize animation controllers with Android-optimized timing
  void _initializeControllers() {
    // * Primary controller for main sequence (4 seconds total)
    _primaryController = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    
    // * Logo animation controller (2.5 seconds)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    // * Text animation controller (2 seconds, starts after logo)
    _textController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  /// * Initialize animations with optimized curves for Android
  void _initializeAnimations() {
    // * Logo scale animation with bounce effect
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
    ));

    // * Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
    ));

    // * Logo rotation animation
    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));

    // * Text fade animation
    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // * Text slide animation
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // * Background animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: Curves.easeInOut,
    ));

    // * Progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));

    // * Exit fade animation
    _exitFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _primaryController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
    ));
  }

  /// * Start the splash animation sequence
  void _startSplashSequence() async {
    try {
      // ! ANDROID OPTIMIZATION: Set status bar for splash
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ));

      // * Start primary controller
      _primaryController.forward();
      
      // * Start logo animation
      _logoController.forward();
      
      // * Wait for logo animation to progress, then start text
      await Future.delayed(const Duration(milliseconds: 800));
      _textController.forward();
      
      // * Wait for all animations to complete
      await _primaryController.forward().orCancel;
      
      // * Complete splash sequence
      _completeSplash();
      
    } catch (error) {
      // ! ERROR HANDLING: Handle animation errors gracefully
      debugPrint('Splash animation error: $error');
      _completeSplash();
    }
  }

  /// * Complete splash and navigate to main app
  void _completeSplash() {
    if (mounted && widget.onSplashComplete != null) {
      widget.onSplashComplete!();
    }
  }

  @override
  void dispose() {
    _primaryController.dispose();
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 600;
    
    return Scaffold(
      backgroundColor: CropFreshColors.green30Primary,
      body: AnimatedBuilder(
        animation: _primaryController,
        builder: (context, child) {
          return Container(
            // * ANDROID-OPTIMIZED GRADIENT BACKGROUND
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  CropFreshColors.green30Primary,
                  CropFreshColors.green30Dark,
                  CropFreshColors.green30Primary.withValues(alpha: 0.9),
                ],
                stops: [
                  0.0,
                  0.5 + (_backgroundAnimation.value * 0.3),
                  1.0,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // * TOP SPACER: Responsive spacing
                  SizedBox(height: isSmallScreen ? 60 : 80),
                  
                  // * LOGO SECTION: Main brand logo
                  Expanded(
                    flex: 3,
                    child: _buildLogoSection(context, isSmallScreen),
                  ),
                  
                  // * BRAND TEXT SECTION: App name and tagline
                  Expanded(
                    flex: 2,
                    child: _buildBrandTextSection(context, isSmallScreen),
                  ),
                  
                  // * PROGRESS SECTION: Loading indicator
                  Expanded(
                    flex: 1,
                    child: _buildProgressSection(context, isSmallScreen),
                  ),
                  
                  // * BOTTOM SPACER: Footer spacing
                  SizedBox(height: isSmallScreen ? 40 : 60),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// * Build animated logo section
  Widget _buildLogoSection(BuildContext context, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Center(
          child: Transform.rotate(
            angle: _logoRotationAnimation.value,
            child: Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                opacity: _logoFadeAnimation.value,
                child: Container(
                  width: isSmallScreen ? 120 : 150,
                  height: isSmallScreen ? 120 : 150,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: isSmallScreen ? 80 : 100,
                      height: isSmallScreen ? 80 : 100,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.3),
                                Colors.white.withValues(alpha: 0.1),
                              ],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.agriculture_outlined,
                            size: isSmallScreen ? 60 : 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// * Build animated brand text section
  Widget _buildBrandTextSection(BuildContext context, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _textController,
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * MAIN BRAND NAME
                Text(
                  'CropFresh',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 32 : 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 8 : 12),
                
                // * TAGLINE
                Text(
                  'Empowering Farmers',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.9),
                    letterSpacing: 1.0,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// * Build progress indicator section
  Widget _buildProgressSection(BuildContext context, bool isSmallScreen) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // * PROGRESS BAR
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Stack(
                children: [
                  Container(
                    width: 200 * _progressAnimation.value,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: isSmallScreen ? 16 : 20),
            
            // * LOADING TEXT
            FadeTransition(
              opacity: _progressAnimation,
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// * Particle background painter for sophisticated visual effects
/// * Creates agricultural themed floating elements
class ParticleBackgroundPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color secondaryColor;

  ParticleBackgroundPainter({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final primaryPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;

    final secondaryPaint = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.fill;

    // * Create sophisticated particle system
    for (int i = 0; i < 30; i++) {
      final isSecondary = i % 4 == 0;
      final paint = isSecondary ? secondaryPaint : primaryPaint;
      
      final x = (size.width * (i * 0.08)) + (animation.value * 60);
      final y = (size.height * (i * 0.06)) + (animation.value * 40);
      
      final particleSize = 1.5 + (i % 4) + (isSecondary ? 1 : 0);
      
      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        particleSize,
        paint,
      );
    }

    // * Add larger accent particles
    for (int i = 0; i < 8; i++) {
      final x = (size.width * (i * 0.15)) + (animation.value * -30);
      final y = (size.height * (i * 0.12)) + (animation.value * 20);
      
      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        3.0 + (i % 2),
        secondaryPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
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
  static const int defaultDuration = 6000;
  
  /// * Minimum splash duration (for fast devices)
  static const int minimumDuration = 2000;
  
  /// * Maximum splash duration (for slow devices)
  static const int maximumDuration = 8000;
  
  /// * Logo animation duration
  static const int logoAnimationDuration = 3000;
  
  /// * Background animation duration
  static const int backgroundAnimationDuration = 8000;
  
  /// * Content animation duration
  static const int contentAnimationDuration = 3000;
} 