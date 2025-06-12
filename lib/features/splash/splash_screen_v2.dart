import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../core/theme/colors.dart';

/// * CROPFRESH STUNNING 4K SPLASH SCREEN V2
/// * Ultra-modern design with advanced animations and visual effects
/// * Features: 3D logo animation, particle system, gradient waves, shimmer effects
/// * Optimized for 4K displays with smooth 60fps animations
class CropFreshSplashScreenV2 extends StatefulWidget {
  final VoidCallback? onSplashComplete;

  const CropFreshSplashScreenV2({
    super.key,
    this.onSplashComplete,
  });

  @override
  State<CropFreshSplashScreenV2> createState() => _CropFreshSplashScreenV2State();
}

class _CropFreshSplashScreenV2State extends State<CropFreshSplashScreenV2>
    with TickerProviderStateMixin {
  // ============================================================================
  // * ANIMATION CONTROLLERS
  // ============================================================================
  
  /// Master animation controller for orchestrating the entire sequence
  late AnimationController _masterController;
  
  /// Logo entrance animation controller
  late AnimationController _logoController;
  
  /// Particle system animation controller
  late AnimationController _particleController;
  
  /// Wave animation controller for background effects
  late AnimationController _waveController;
  
  /// Shimmer effect controller
  late AnimationController _shimmerController;
  
  /// Text reveal controller
  late AnimationController _textRevealController;
  
  /// Glow pulse controller
  late AnimationController _glowController;

  // ============================================================================
  // * ANIMATIONS
  // ============================================================================
  
  // Logo animations
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _logoElevationAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoBlurAnimation;
  
  // Text animations
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textLetterSpacingAnimation;
  late Animation<double> _textScaleAnimation;
  late Animation<Offset> _textSlideAnimation;
  
  // Effect animations
  late Animation<double> _glowAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _particleAnimation;
  
  // Transition animations
  late Animation<double> _fadeOutAnimation;
  late Animation<double> _scaleOutAnimation;

  // Particle system
  final List<Particle> _particles = [];
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _initializeParticles();
    _startAnimationSequence();
  }

  void _initializeControllers() {
    // Master controller - 5 seconds total duration
    _masterController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );
    
    // Logo controller - 3 seconds
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    
    // Particle system - continuous
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 20000),
      vsync: this,
    )..repeat();
    
    // Wave animation - continuous
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 8000),
      vsync: this,
    )..repeat();
    
    // Shimmer effect - continuous
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
    
    // Text reveal - 2 seconds
    _textRevealController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Glow pulse - continuous
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
  }

  void _initializeAnimations() {
    // Logo scale - elastic entrance
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 70,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInOutSine)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutSine)),
        weight: 10,
      ),
    ]).animate(_logoController);

    // Logo rotation - 3D effect
    _logoRotationAnimation = Tween<double>(
      begin: -math.pi * 2,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
    ));

    // Logo elevation - depth effect
    _logoElevationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 20.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 20.0, end: 10.0),
        weight: 50,
      ),
    ]).animate(_logoController);

    // Logo opacity
    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));

    // Logo blur - focus effect
    _logoBlurAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 10.0, end: 0.0),
        weight: 80,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.0),
        weight: 20,
      ),
    ]).animate(_logoController);

    // Text opacity with stagger
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
    ));

    // Text letter spacing - expand effect
    _textLetterSpacingAnimation = Tween<double>(
      begin: -5.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // Text scale
    _textScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    ));

    // Text slide
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textRevealController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // Glow animation
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Shimmer animation
    _shimmerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_shimmerController);

    // Wave animation
    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(_waveController);

    // Particle animation
    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    // Fade out
    _fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
    ));

    // Scale out
    _scaleOutAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _masterController,
      curve: const Interval(0.9, 1.0, curve: Curves.easeInOut),
    ));
  }

  void _initializeParticles() {
    // Create particle system with agricultural theme
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle(
        position: Offset(
          math.Random().nextDouble() * 400 - 200,
          math.Random().nextDouble() * 800 - 400,
        ),
        velocity: Offset(
          (math.Random().nextDouble() - 0.5) * 0.5,
          (math.Random().nextDouble() - 0.5) * 0.5,
        ),
        size: math.Random().nextDouble() * 3 + 1,
        opacity: math.Random().nextDouble() * 0.5 + 0.5,
        type: i % 3 == 0 ? ParticleType.leaf : ParticleType.sparkle,
      ));
    }
  }

  void _startAnimationSequence() async {
    // Set system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    // Start animation sequence
    _masterController.forward();
    _logoController.forward();
    
    // Delay text reveal for dramatic effect
    await Future.delayed(const Duration(milliseconds: 1200));
    _textRevealController.forward();
    
    // Wait for master animation to complete
    await _masterController.forward().orCancel;
    
    // Complete splash
    _completeSplash();
  }

  void _completeSplash() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    if (mounted && widget.onSplashComplete != null) {
      widget.onSplashComplete!();
    }
  }

  @override
  void dispose() {
    _masterController.dispose();
    _logoController.dispose();
    _particleController.dispose();
    _waveController.dispose();
    _shimmerController.dispose();
    _textRevealController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: CropFreshColors.green30Dark,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _masterController,
          _logoController,
          _textRevealController,
          _glowController,
          _shimmerController,
          _waveController,
          _particleController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Background gradient with wave effect
              _buildAnimatedBackground(size),
              
              // Particle system
              _buildParticleSystem(size),
              
              // Main content
              FadeTransition(
                opacity: _fadeOutAnimation,
                child: Transform.scale(
                  scale: _scaleOutAnimation.value,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 3D animated logo
                        _build3DLogo(context),
                        
                        const SizedBox(height: 80),
                        
                        // Animated text
                        _buildAnimatedText(context),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Shimmer overlay
              _buildShimmerOverlay(size),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    return CustomPaint(
      size: size,
      painter: WaveBackgroundPainter(
        waveAnimation: _waveAnimation.value,
        colors: [
          CropFreshColors.green30Dark,
          CropFreshColors.green30Primary,
          CropFreshColors.green30Forest,
        ],
      ),
    );
  }

  Widget _buildParticleSystem(Size size) {
    return CustomPaint(
      size: size,
      painter: ParticleSystemPainter(
        particles: _particles,
        animation: _particleAnimation.value,
      ),
    );
  }

  Widget _build3DLogo(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateY(_logoRotationAnimation.value * 0.3)
        ..rotateZ(_logoRotationAnimation.value * 0.1),
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                // Glow effect
                BoxShadow(
                  color: CropFreshColors.green30Light.withOpacity(
                    0.3 * _glowAnimation.value * _logoOpacityAnimation.value,
                  ),
                  blurRadius: 50 * _glowAnimation.value,
                  spreadRadius: 20 * _glowAnimation.value,
                ),
                // Elevation shadow
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: _logoElevationAnimation.value,
                  offset: Offset(0, _logoElevationAnimation.value * 0.5),
                ),
              ],
            ),
            child: Transform.scale(
              scale: _logoScaleAnimation.value,
              child: Opacity(
                opacity: _logoOpacityAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _logoBlurAnimation.value,
                      sigmaY: _logoBlurAnimation.value,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.eco,
                              size: 80,
                              color: Colors.white.withOpacity(0.9),
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

  Widget _buildAnimatedText(BuildContext context) {
    return SlideTransition(
      position: _textSlideAnimation,
      child: FadeTransition(
        opacity: _textOpacityAnimation,
        child: Transform.scale(
          scale: _textScaleAnimation.value,
          child: Column(
            children: [
              // App name with letter spacing animation
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: _textLetterSpacingAnimation.value,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text('CropFresh'),
              ),
              
              const SizedBox(height: 16),
              
              // Tagline with shimmer effect
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.9),
                      CropFreshColors.green30Light,
                      Colors.white.withOpacity(0.9),
                    ],
                    stops: [
                      _shimmerAnimation.value - 0.3,
                      _shimmerAnimation.value,
                      _shimmerAnimation.value + 0.3,
                    ].map((e) => e.clamp(0.0, 1.0)).toList(),
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  'Empowering Farmers, Growing Future',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerOverlay(Size size) {
    return Positioned.fill(
      child: IgnorePointer(
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.05),
                Colors.transparent,
              ],
              stops: [
                _shimmerAnimation.value - 0.3,
                _shimmerAnimation.value,
                _shimmerAnimation.value + 0.3,
              ].map((e) => e.clamp(0.0, 1.0)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: const GradientRotation(math.pi / 4),
            ).createShader(bounds);
          },
          child: Container(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// Particle class for particle system
class Particle {
  Offset position;
  final Offset velocity;
  final double size;
  final double opacity;
  final ParticleType type;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
    required this.type,
  });

  void update() {
    position += velocity;
  }
}

enum ParticleType { sparkle, leaf }

// Particle system painter
class ParticleSystemPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;

  ParticleSystemPainter({
    required this.particles,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      particle.update();
      
      // Wrap particles around screen
      if (particle.position.dx < -size.width / 2) {
        particle.position = Offset(size.width / 2, particle.position.dy);
      } else if (particle.position.dx > size.width / 2) {
        particle.position = Offset(-size.width / 2, particle.position.dy);
      }
      
      if (particle.position.dy < -size.height / 2) {
        particle.position = Offset(particle.position.dx, size.height / 2);
      } else if (particle.position.dy > size.height / 2) {
        particle.position = Offset(particle.position.dx, -size.height / 2);
      }
      
      final paint = Paint()
        ..color = CropFreshColors.green30Light.withOpacity(
          particle.opacity * (0.5 + 0.5 * math.sin(animation * 2 * math.pi + particle.position.dx)),
        )
        ..style = PaintingStyle.fill;
      
      if (particle.type == ParticleType.sparkle) {
        // Draw sparkle
        canvas.drawCircle(
          Offset(
            size.width / 2 + particle.position.dx,
            size.height / 2 + particle.position.dy,
          ),
          particle.size,
          paint,
        );
      } else {
        // Draw leaf shape
        final path = Path();
        final center = Offset(
          size.width / 2 + particle.position.dx,
          size.height / 2 + particle.position.dy,
        );
        
        path.moveTo(center.dx, center.dy - particle.size * 2);
        path.quadraticBezierTo(
          center.dx + particle.size,
          center.dy - particle.size,
          center.dx,
          center.dy,
        );
        path.quadraticBezierTo(
          center.dx - particle.size,
          center.dy - particle.size,
          center.dx,
          center.dy - particle.size * 2,
        );
        
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Wave background painter
class WaveBackgroundPainter extends CustomPainter {
  final double waveAnimation;
  final List<Color> colors;

  WaveBackgroundPainter({
    required this.waveAnimation,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    
    // Base gradient
    final baseGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: const [0.0, 0.5, 1.0],
    );
    
    final basePaint = Paint()
      ..shader = baseGradient.createShader(rect);
    
    canvas.drawRect(rect, basePaint);
    
    // Wave layers
    for (int i = 0; i < 3; i++) {
      final wavePaint = Paint()
        ..color = colors[1].withOpacity(0.1 - i * 0.03)
        ..style = PaintingStyle.fill;
      
      final path = Path();
      path.moveTo(0, size.height * (0.6 + i * 0.1));
      
      for (double x = 0; x <= size.width; x += 10) {
        final y = size.height * (0.6 + i * 0.1) +
            math.sin((x / size.width * 2 * math.pi) + waveAnimation + i * math.pi / 3) *
            (30 - i * 10);
        path.lineTo(x, y);
      }
      
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      
      canvas.drawPath(path, wavePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
