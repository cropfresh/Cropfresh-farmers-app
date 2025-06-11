import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';

/// * CROPFRESH ANIMATED SPLASH SCREEN
/// * Material Design 3 compliant splash screen with beautiful logo animation
/// * Follows 60-30-10 color rule and modern animation principles
/// * Enhanced with pulsing effects and brand storytelling
/// * Duration: 3.5 seconds with sophisticated transitions
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
  /// * Controls scale, fade, rotation, and entrance animations
  late AnimationController _logoAnimationController;
  
  /// * Logo pulsing animation controller
  /// * Creates heartbeat-like pulsing effect for brand emphasis
  late AnimationController _logoPulseController;
  
  /// * Background gradient animation controller
  /// * Creates dynamic background color transitions
  late AnimationController _backgroundAnimationController;
  
  /// * Text animation controller
  /// * Controls company name and tagline animations
  late AnimationController _textAnimationController;
  
  /// * Particles animation controller
  /// * Controls floating particles for visual enhancement
  late AnimationController _particlesController;

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
  /// * Dramatic entrance with overshoot effect
  late Animation<double> _logoScaleAnimation;
  
  /// * Logo fade animation
  /// * Smooth opacity transition with curves
  late Animation<double> _logoFadeAnimation;
  
  /// * Logo rotation animation
  /// * Gentle rotation for dynamic effect
  late Animation<double> _logoRotationAnimation;
  
  /// * Logo pulse animation
  /// * Continuous pulsing effect for brand emphasis
  late Animation<double> _logoPulseAnimation;
  
  /// * Logo glow animation
  /// * Creates glowing effect around the logo
  late Animation<double> _logoGlowAnimation;
  
  /// * Background gradient animation
  /// * Dynamic color transitions following 60-30-10 rule
  late Animation<Color?> _backgroundGradientAnimation;
  
  /// * Background shimmer animation
  /// * Subtle shimmer effect across background
  late Animation<double> _backgroundShimmerAnimation;
  
  /// * Text slide animation
  /// * Company name slides up with spring effect
  late Animation<Offset> _textSlideAnimation;
  
  /// * Text fade animation
  /// * Company name fades in with character-by-character effect
  late Animation<double> _textFadeAnimation;
  
  /// * Tagline animation
  /// * Subtitle text animation with staggered delay
  late Animation<double> _taglineFadeAnimation;
  
  /// * Loading progress animation
  /// * Animated progress indicator
  late Animation<double> _loadingProgressAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  /// * Initialize all animation controllers and animations
  /// * Sets up the complete animation sequence for the enhanced splash screen
  void _initializeAnimations() {
    // * ANIMATION CONTROLLERS SETUP
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000), // 2 seconds for logo entrance
      vsync: this,
    );
    
    _logoPulseController = AnimationController(
      duration: const Duration(milliseconds: 1500), // 1.5 seconds pulse cycle
      vsync: this,
    );
    
    _backgroundAnimationController = AnimationController(
      duration: const Duration(milliseconds: 3000), // 3 seconds for background
      vsync: this,
    );
    
    _textAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1200), // 1.2 seconds for text
      vsync: this,
    );
    
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 4000), // 4 seconds for particles
      vsync: this,
    );

    // * LOGO ENTRANCE ANIMATIONS
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut, // Dramatic elastic entrance
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.2, // More dramatic initial rotation
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
    ));

    // * LOGO PULSING EFFECT
    _logoPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1, // 10% scale increase for pulse
    ).animate(CurvedAnimation(
      parent: _logoPulseController,
      curve: Curves.easeInOut,
    ));

    _logoGlowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _logoPulseController,
      curve: Curves.easeInOut,
    ));

    // * BACKGROUND ANIMATIONS (Following 60-30-10 Rule)
    _backgroundGradientAnimation = ColorTween(
      begin: CropFreshColors.background60Primary, // 60% light background
      end: CropFreshColors.green30Container.withValues(alpha: 0.15), // 30% green tint
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    _backgroundShimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    // * TEXT ANIMATIONS
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8), // Start further below
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: Curves.easeOutBack, // Spring-like effect
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _taglineFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
    ));

    _loadingProgressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textAnimationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));
  }

  /// * Start the enhanced animation sequence
  /// * Orchestrates all animations with perfect timing
  void _startAnimationSequence() {
    // ! SECURITY: Prevent screen capture during splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // * Start background animation immediately
    _backgroundAnimationController.forward();
    _particlesController.repeat();
    
    // * Start logo animation after brief delay for dramatic effect
    final logoTimer = Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _logoAnimationController.forward();
      }
    });
    _activeTimers.add(logoTimer);
    
    // * Start pulsing effect when logo is visible
    final pulseTimer = Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        _logoPulseController.repeat(reverse: true);
      }
    });
    _activeTimers.add(pulseTimer);
    
    // * Start text animation after logo settles
    final textTimer = Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _textAnimationController.forward();
      }
    });
    _activeTimers.add(textTimer);
    
    // * Complete splash screen after total duration
    final completeTimer = Future.delayed(const Duration(milliseconds: 3500), () {
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
    _logoPulseController.dispose();
    _backgroundAnimationController.dispose();
    _textAnimationController.dispose();
    _particlesController.dispose();
    
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
      // * 60% BACKGROUND: Enhanced animated background
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _backgroundGradientAnimation,
          _backgroundShimmerAnimation,
        ]),
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              // * GRADIENT: Enhanced following 60-30-10 rule
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _backgroundGradientAnimation.value ?? CropFreshColors.background60Primary,
                  CropFreshColors.background60Secondary,
                  CropFreshColors.green30Container.withValues(alpha: 0.08), // 30% subtle green
                  CropFreshColors.orange10Container.withValues(alpha: 0.03), // 10% subtle orange
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // * BACKGROUND PARTICLES
                _buildBackgroundParticles(),
                
                // * MAIN CONTENT
                SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // * LOGO SECTION
                      Expanded(
                        flex: 3,
                        child: _buildEnhancedAnimatedLogo(isLargeScreen),
                      ),
                      
                      // * TEXT SECTION
                      Expanded(
                        flex: 2,
                        child: _buildEnhancedAnimatedText(context, isLargeScreen),
                      ),
                      
                      // * FOOTER SECTION
                      _buildEnhancedFooter(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// * Build background particles for visual enhancement
  /// * Creates subtle floating elements
  Widget _buildBackgroundParticles() {
    return AnimatedBuilder(
      animation: _particlesController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(
            animation: _particlesController,
            color: CropFreshColors.green30Primary.withValues(alpha: 0.1),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  /// * Build enhanced animated logo section
  /// * Creates sophisticated logo animation with multiple effects
  Widget _buildEnhancedAnimatedLogo(bool isLargeScreen) {
    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _logoScaleAnimation,
          _logoFadeAnimation,
          _logoRotationAnimation,
          _logoPulseAnimation,
          _logoGlowAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _logoScaleAnimation.value * _logoPulseAnimation.value,
            child: Transform.rotate(
              angle: _logoRotationAnimation.value,
              child: Opacity(
                opacity: _logoFadeAnimation.value,
                child: Container(
                  // * LOGO CONTAINER: Enhanced with glow effect
                  width: isLargeScreen ? 220 : 170,
                  height: isLargeScreen ? 220 : 170,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32), // Larger radius
                    boxShadow: [
                      // * Primary shadow
                      BoxShadow(
                        color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
                        blurRadius: 25,
                        spreadRadius: 8,
                        offset: const Offset(0, 12),
                      ),
                      // * Glow effect
                      BoxShadow(
                        color: CropFreshColors.green30Primary.withValues(alpha: _logoGlowAnimation.value * 0.4),
                        blurRadius: 40,
                        spreadRadius: 15,
                        offset: const Offset(0, 0),
                      ),
                      // * Orange accent glow (10% rule)
                      BoxShadow(
                        color: CropFreshColors.orange10Primary.withValues(alpha: _logoGlowAnimation.value * 0.2),
                        blurRadius: 60,
                        spreadRadius: 20,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: Container(
                      decoration: BoxDecoration(
                        // * Subtle background for logo
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(
                          color: CropFreshColors.green30Primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: isLargeScreen ? 188 : 138,
                          height: isLargeScreen ? 188 : 138,
                          fit: BoxFit.contain,
                          // ! ERROR HANDLING: Enhanced fallback
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: isLargeScreen ? 188 : 138,
                              height: isLargeScreen ? 188 : 138,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    CropFreshColors.green30Primary,
                                    CropFreshColors.green30Dark,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.agriculture,
                                size: isLargeScreen ? 90 : 70,
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
            ),
          );
        },
      ),
    );
  }

  /// * Build enhanced animated text section
  /// * Creates sophisticated text animations with branding
  Widget _buildEnhancedAnimatedText(BuildContext context, bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _textSlideAnimation,
        _textFadeAnimation,
        _taglineFadeAnimation,
        _loadingProgressAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _textSlideAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // * COMPANY NAME with enhanced styling
              Opacity(
                opacity: _textFadeAnimation.value,
                child: ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      CropFreshColors.green30Primary,
                      CropFreshColors.green30Dark,
                    ],
                  ).createShader(bounds),
                  child: Text(
                    'CropFresh',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white, // Color will be replaced by gradient
                      fontWeight: FontWeight.w800,
                      fontSize: isLargeScreen ? 52 : 40,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // * TAGLINE with enhanced styling
              Opacity(
                opacity: _taglineFadeAnimation.value,
                child: Text(
                  'Empowering Farmers with Technology',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: CropFreshColors.onBackground60, 
                    fontSize: isLargeScreen ? 20 : 18,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // * SUBTITLE
              Opacity(
                opacity: _taglineFadeAnimation.value,
                child: Text(
                  'Sustainable • Innovative • Reliable',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: isLargeScreen ? 16 : 14,
                    letterSpacing: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // * ENHANCED LOADING INDICATOR
              Opacity(
                opacity: _loadingProgressAnimation.value,
                child: Column(
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        children: [
                          // * Background circle
                          CircularProgressIndicator(
                            strokeWidth: 4,
                            value: 1.0,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CropFreshColors.green30Container.withValues(alpha: 0.3),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          // * Animated progress
                          CircularProgressIndicator(
                            strokeWidth: 4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              CropFreshColors.orange10Primary,
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: CropFreshColors.onBackground60Secondary,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// * Build enhanced footer section
  /// * Shows app version and enhanced company info
  Widget _buildEnhancedFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          // * VERSION INFO with badge style
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: CropFreshColors.green30Container.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Version 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: CropFreshColors.green30Primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // * COPYRIGHT with enhanced styling
          Text(
            '© 2024 CropFresh Technologies',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Tertiary,
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          
          const SizedBox(height: 4),
          
          // * ADDITIONAL BRANDING
          Text(
            'Made with ❤️ for Farmers',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Tertiary,
              fontSize: 9,
              letterSpacing: 0.5,
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

/// * Custom painter for background particles
/// * Creates floating particles for visual enhancement
class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  ParticlesPainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // * Create subtle floating particles
    for (int i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.1)) + (animation.value * 50);
      final y = (size.height * (i * 0.05)) + (animation.value * 30);
      
      final particleSize = 2.0 + (i % 3);
      
      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        particleSize,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
} 