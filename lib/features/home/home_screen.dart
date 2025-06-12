import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import '../registration/registration_flow.dart';
import '../login/login_screen.dart';

/// * CROPFRESH ULTRA-MINIMAL HOME SCREEN
/// * Material 3 design with essential elements only
/// * Logo, text logo, slogan, register and login buttons
/// * Follows Material 3 design system and color specifications
class CropFreshHomeScreen extends StatefulWidget {
  const CropFreshHomeScreen({super.key});

  @override
  State<CropFreshHomeScreen> createState() => _CropFreshHomeScreenState();
}

class _CropFreshHomeScreenState extends State<CropFreshHomeScreen>
    with TickerProviderStateMixin {
  // ============================================================================
  // * MATERIAL 3 ANIMATION CONTROLLER
  // ============================================================================

  /// * Single animation controller for Material 3 entrance
  late AnimationController _animationController;

  /// * Material 3 fade animation
  late Animation<double> _fadeAnimation;

  /// * Material 3 slide animation
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeMaterial3Animations();
    _setMaterial3StatusBar();
    _startAnimations();
  }

  /// * Initialize Material 3 animations
  void _initializeMaterial3Animations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  /// * Set Material 3 status bar
  void _setMaterial3StatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: CropFreshColors.surface60Primary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  /// * Start Material 3 entrance animation
  void _startAnimations() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.surface60Primary,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: isSmallScreen ? 24.0 : 32.0,
                  ),
                  child: Column(
                    children: [
                      // * SPACER: Top breathing room
                      Spacer(flex: isSmallScreen ? 2 : 3),

                      // * LOGO SECTION: Brand identity
                      _buildLogoSection(context, isSmallScreen),

                      // * SPACER: Between logo and slogan
                      SizedBox(height: isSmallScreen ? 48 : 64),

                      // * SLOGAN SECTION: Simple messaging
                      _buildSloganSection(context, isSmallScreen),

                      // * SPACER: Flexible space
                      Spacer(flex: isSmallScreen ? 3 : 4),

                      // * BUTTON SECTION: Register and Login
                      _buildButtonSection(context, isSmallScreen),

                      // * SPACER: Bottom breathing room
                      SizedBox(height: isSmallScreen ? 24 : 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// * Build logo section with Material 3 design
  Widget _buildLogoSection(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        // * LOGO: Clean brand icon
        Container(
          width: isSmallScreen ? 96 : 120,
          height: isSmallScreen ? 96 : 120,
          decoration: BoxDecoration(
            color: CropFreshColors.green30Container.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: isSmallScreen ? 64 : 80,
              height: isSmallScreen ? 64 : 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.agriculture_outlined,
                  size: isSmallScreen ? 48 : 60,
                  color: CropFreshColors.green30Primary,
                );
              },
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 24 : 32),

        // * TEXT LOGO: App name in Material 3 style
        Text(
          'CropFresh',
          style: TextStyle(
            fontSize: isSmallScreen ? 36 : 48,
            fontWeight: FontWeight.w400,
            color: CropFreshColors.onBackground60,
            letterSpacing: -0.5,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  /// * Build slogan section with Material 3 typography
  Widget _buildSloganSection(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        // * SLOGAN: Simple and focused message
        Text(
          'Smart farming for everyone',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 22,
            fontWeight: FontWeight.w400,
            color: CropFreshColors.onBackground60Secondary,
            letterSpacing: 0.1,
            height: 1.4,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// * Build button section with Material 3 buttons
  Widget _buildButtonSection(BuildContext context, bool isSmallScreen) {
    return Column(
      children: [
        // * REGISTER BUTTON: Primary Material 3 filled button
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 56,
          child: FilledButton(
            onPressed: () => _handleRegister(context),
            style: FilledButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
              foregroundColor: CropFreshColors.onGreen30,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),

        SizedBox(height: isSmallScreen ? 12 : 16),

        // * LOGIN BUTTON: Secondary Material 3 outlined button
        SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 56,
          child: OutlinedButton(
            onPressed: () => _handleLogin(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: CropFreshColors.green30Primary,
              side: BorderSide(color: CropFreshColors.green30Primary, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// * Handle register button press with Material 3 feedback
  void _handleRegister(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const RegistrationFlow()));
  }

  /// * Handle login button press with Material 3 feedback
  void _handleLogin(BuildContext context) {
    HapticFeedback.lightImpact();

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
