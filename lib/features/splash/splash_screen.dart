import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';

/// * CROPFRESH MODERN SPLASH SCREEN
/// * Material Design 3 with glassmorphism and advanced micro-interactions
/// * Optimized performance with component-based architecture
/// * Features: Glassmorphism, mesh gradients, advanced particles, ripple effects
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
  
  /// * Master controller for entire splash sequence
  late AnimationController _masterController;
  
  /// * Logo animation controller
  late AnimationController _logoController;
  
  /// * Background effects controller
  late AnimationController _backgroundController;
  
  /// * Content reveal controller
  late AnimationController _contentController;
  
  /// * Exit transition controller
  late AnimationController _exitController;

  // ============================================================================
  // * CORE ANIMATIONS
  // ============================================================================
  
  /// * Logo animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoPulseAnimation;
  
  /// * Background gradient animation
  late Animation<double> _backgroundAnimation;
  
  /// * Content fade and scale animation
  late Animation<double> _contentFadeAnimation;
  late Animation<double> _contentScaleAnimation;
  
  /// * Brand text animations
  late Animation<double> _brandTextFadeAnimation;
  late Animation<Offset> _brandTextSlideAnimation;
  
  /// * Metadata animations
  late Animation<double> _metadataFadeAnimation;
  late Animation<Offset> _metadataSlideAnimation;
  
  /// * Exit transition animations
  late Animation<double> _exitFadeAnimation;
  late Animation<double> _exitScaleAnimation;

  /// * Particle animation
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startSplashSequence();
  }

  /// * Initialize animation controllers with optimized timing
  void _initializeControllers() {
    // * Master sequence controller (6 seconds total)
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 6000),
      vsync: this,
    );
    
    // * Logo controller (3 seconds)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // * Background effects (continuous)
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    );
    
    // * Content animation (3 seconds)
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // * Exit transition (1 second)
    _exitController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  /// * Initialize all animations with smooth curves
  void _initializeAnimations() {
    // * Logo animations
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.1, 0.7, curve: Curves.easeOutBack),
    ));

    _logoPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    ));

    // * Background animation
    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    // * Content animations
    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    _contentScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.9, curve: Curves.elasticOut),
    ));

    // * Brand text animations
    _brandTextFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeInOut),
    ));

    _brandTextSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
    ));

    // * Metadata animations
    _metadataFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
    ));

    _metadataSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
    ));

    // * Exit animations
    _exitFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInCubic,
    ));

    _exitScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInOut,
    ));

    // * Particle animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
    ));
  }

  /// * Start the optimized splash sequence
  void _startSplashSequence() {
    // ! SECURITY: Immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // * Start background effects immediately
    _backgroundController.repeat();
    
    // * Logo appears after brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoController.forward();
      }
    });
    
    // * Content appears after logo
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _contentController.forward();
      }
    });
    
    // * Start master timer
    _masterController.forward();
    
    // * Exit sequence
    Future.delayed(const Duration(milliseconds: 5000), () {
      if (mounted) _exitController.forward();
    });
    
    // * Complete splash
    Future.delayed(const Duration(milliseconds: 6000), () {
      if (mounted) _completeSplash();
    });
  }

  /// * Complete splash and navigate
  void _completeSplash() {
    // ! RESTORE: System UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    
    if (widget.onSplashComplete != null) {
      widget.onSplashComplete!();
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _logoController.dispose();
    _backgroundController.dispose();
    _contentController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isLargeScreen = screenSize.width > 600;
    
    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _exitController,
          _backgroundController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _exitScaleAnimation.value,
            child: Opacity(
              opacity: _exitFadeAnimation.value,
              child: Stack(
                children: [
                  // * MODERN GRADIENT BACKGROUND
                  _buildModernBackground(),
                  
                  // * PARTICLE BACKGROUND
                  _buildParticleBackground(),
                  
                  // * MAIN CONTENT
                  SafeArea(
                    child: _buildMainContent(isLargeScreen),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// * Build modern gradient background with mesh effect
  Widget _buildModernBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topLeft,
              radius: 1.5 + (_backgroundAnimation.value * 0.5),
              colors: [
                CropFreshColors.green30Primary.withValues(alpha: 0.15),
                CropFreshColors.background60Primary,
                CropFreshColors.green30Container.withValues(alpha: 0.08),
                CropFreshColors.orange10Container.withValues(alpha: 0.05),
              ],
              stops: const [0.0, 0.4, 0.7, 1.0],
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.transparent,
                  CropFreshColors.green30Primary.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                transform: GradientRotation(_backgroundAnimation.value * 6.28),
              ),
            ),
          ),
        );
      },
    );
  }

  /// * Build particle background effect
  Widget _buildParticleBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticleBackgroundPainter(
            animation: _particleAnimation,
            primaryColor: CropFreshColors.green30Primary.withValues(alpha: 0.1),
            secondaryColor: CropFreshColors.orange10Primary.withValues(alpha: 0.08),
          ),
          size: Size.infinite,
        );
      },
    );
  }

  /// * Build main content with glassmorphic effects
  Widget _buildMainContent(bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _contentFadeAnimation,
        _contentScaleAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _contentScaleAnimation.value,
          child: Opacity(
            opacity: _contentFadeAnimation.value,
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // * LOGO SECTION
                Expanded(
                  flex: 6,
                  child: Center(
                    child: _buildLogoSection(isLargeScreen),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // * BRAND TEXT SECTION
                Expanded(
                  flex: 4,
                  child: _buildBrandTextSection(isLargeScreen),
                ),
                
                // * METADATA SECTION
                Expanded(
                  flex: 4,
                  child: _buildMetadataSection(isLargeScreen),
                ),
                
                const Spacer(flex: 2),
              ],
            ),
          ),
        );
      },
    );
  }

  /// * Build glassmorphic logo container
  Widget _buildLogoSection(bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _logoScaleAnimation,
        _logoFadeAnimation,
        _logoRotationAnimation,
        _logoPulseAnimation,
      ]),
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value * _logoPulseAnimation.value,
          child: Transform.rotate(
            angle: _logoRotationAnimation.value,
            child: Opacity(
              opacity: _logoFadeAnimation.value,
              child: Container(
                width: isLargeScreen ? 280 : 220,
                height: isLargeScreen ? 280 : 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(45),
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CropFreshColors.green30Primary.withValues(alpha: 0.25),
                      blurRadius: 30,
                      spreadRadius: 10,
                      offset: const Offset(0, 10),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: _buildLogoWidget(isLargeScreen),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// * Build logo widget with fallback
  Widget _buildLogoWidget(bool isLargeScreen) {
    return Image.asset(
      'assets/images/logo.png',
      width: isLargeScreen ? 200 : 140,
      height: isLargeScreen ? 200 : 140,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: isLargeScreen ? 200 : 140,
          height: isLargeScreen ? 200 : 140,
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
            size: isLargeScreen ? 100 : 80,
            color: Colors.white,
          ),
        );
      },
    );
  }

  /// * Build brand text section
  Widget _buildBrandTextSection(bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _brandTextFadeAnimation,
        _brandTextSlideAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _brandTextSlideAnimation,
          child: Opacity(
            opacity: _brandTextFadeAnimation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * BRAND LOGO TEXT
                _buildBrandText(isLargeScreen),
                
                const SizedBox(height: 16),
                
                // * ANIMATED UNDERLINE
                Container(
                  height: 3,
                  width: (isLargeScreen ? 150 : 100) * _brandTextFadeAnimation.value,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        CropFreshColors.orange10Primary,
                        CropFreshColors.green30Primary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// * Build brand text with fallback
  Widget _buildBrandText(bool isLargeScreen) {
    return Image.asset(
      'assets/images/logo-text.png',
      height: isLargeScreen ? 80 : 60,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [
              CropFreshColors.green30Primary,
              CropFreshColors.green30Dark,
            ],
          ).createShader(bounds),
          child: Text(
            'CropFresh',
            style: TextStyle(
              color: Colors.white,
              fontSize: isLargeScreen ? 48 : 36,
              fontWeight: FontWeight.w800,
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
        );
      },
    );
  }

  /// * Build metadata section
  Widget _buildMetadataSection(bool isLargeScreen) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _metadataFadeAnimation,
        _metadataSlideAnimation,
      ]),
      builder: (context, child) {
        return SlideTransition(
          position: _metadataSlideAnimation,
          child: Opacity(
            opacity: _metadataFadeAnimation.value,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * MAIN TAGLINE
                Text(
                  'Empowering Farmers with Technology',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: CropFreshColors.onBackground60,
                    fontSize: isLargeScreen ? 24 : 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                // * BRAND VALUES
                Text(
                  'Sustainable • Innovative • Reliable',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: CropFreshColors.onBackground60Secondary,
                    fontSize: isLargeScreen ? 18 : 16,
                    letterSpacing: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // * LOADING INDICATOR
                _buildLoadingIndicator(),
                
                const SizedBox(height: 32),
                
                // * VERSION INFO
                _buildVersionInfo(),
              ],
            ),
          ),
        );
      },
    );
  }

  /// * Build loading indicator
  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: Stack(
            children: [
              CircularProgressIndicator(
                strokeWidth: 4,
                value: 1.0,
                valueColor: AlwaysStoppedAnimation<Color>(
                  CropFreshColors.green30Container.withValues(alpha: 0.3),
                ),
                backgroundColor: Colors.transparent,
              ),
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
        const SizedBox(height: 20),
        Text(
          'Loading...',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: CropFreshColors.onBackground60Secondary,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  /// * Build version information
  Widget _buildVersionInfo() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                CropFreshColors.green30Container.withValues(alpha: 0.2),
                CropFreshColors.green30Container.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: CropFreshColors.green30Primary.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            'Version 1.0.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.green30Primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '© 2024 CropFresh Technologies',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.onBackground60Tertiary,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Made with ❤️ for Farmers',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CropFreshColors.onBackground60Tertiary,
            fontSize: 9,
            letterSpacing: 0.5,
          ),
        ),
      ],
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