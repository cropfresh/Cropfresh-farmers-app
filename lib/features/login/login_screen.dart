// ===================================================================
// * LOGIN SCREEN MODULE
// * Purpose: Secure user authentication for CropFresh Farmers App
// * Features: Phone number verification, MPIN authentication, offline support
// * Security Level: HIGH - Handles authentication credentials
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import 'login_controller.dart';
import 'login_repository.dart';
import '../navigation/main_navigation.dart';

/// * LOGIN SCREEN WIDGET
/// * Handles phone number and MPIN authentication
/// * Material 3 design with enhanced security features
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  // ============================================================================
  // * CONTROLLERS AND SERVICES
  // ============================================================================

  late LoginController _loginController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // * Form controllers
  final TextEditingController _phoneController = TextEditingController();
  final List<TextEditingController> _mpinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _mpinFocusNodes = List.generate(4, (_) => FocusNode());

  // * Form keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _setStatusBar();
    _startAnimations();
  }

  void _initializeControllers() {
    _loginController = LoginController(LoginRepository());
    _loginController.addListener(_handleStateChanges);
  }

  void _initializeAnimations() {
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

  void _setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: CropFreshColors.surface60Primary,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void _startAnimations() {
    _animationController.forward();
  }

  void _handleStateChanges() {
    final state = _loginController.state;

    if (state.isSuccess) {
      _navigateToDashboard();
    } else if (state.hasError) {
      _showErrorMessage(state.errorMessage);
    }
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            MainNavigationWrapper(userProfile: _loginController.userProfile!),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: CropFreshColors.onError,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: CropFreshColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String get _enteredMpin => _mpinControllers.map((c) => c.text).join();

  @override
  void dispose() {
    _animationController.dispose();
    _loginController.removeListener(_handleStateChanges);
    _loginController.dispose();
    _phoneController.dispose();
    for (final controller in _mpinControllers) {
      controller.dispose();
    }
    for (final focusNode in _mpinFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.surface60Primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CropFreshColors.onBackground60),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Login',
          style: TextStyle(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: isSmallScreen ? 16.0 : 24.0,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // * Welcome message
                        SizedBox(height: isSmallScreen ? 24 : 32),
                        _buildWelcomeSection(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 32 : 48),

                        // * Phone number section
                        _buildPhoneNumberSection(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 24 : 32),

                        // * MPIN section
                        _buildMpinSection(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 32 : 48),

                        // * Login button
                        _buildLoginButton(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 16 : 24),

                        // * Forgot MPIN option
                        _buildForgotMpinSection(isSmallScreen),

                        SizedBox(height: isSmallScreen ? 24 : 32),

                        // * Quick login section (if user data exists)
                        _buildQuickLoginSection(isSmallScreen),
                      ],
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

  Widget _buildWelcomeSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back! 👋',
          style: TextStyle(
            fontSize: isSmallScreen ? 28 : 32,
            fontWeight: FontWeight.w600,
            color: CropFreshColors.onBackground60,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Sign in to access your farm dashboard',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            fontWeight: FontWeight.w400,
            color: CropFreshColors.onBackground60Secondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: CropFreshColors.onBackground60,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '+91 9876543210',
            prefixIcon: Icon(
              Icons.phone_outlined,
              color: CropFreshColors.green30Primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: CropFreshColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CropFreshColors.green30Primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: CropFreshColors.surface,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
          onChanged: (value) {
            _loginController.updatePhoneNumber(value);
          },
        ),
      ],
    );
  }

  Widget _buildMpinSection(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'MPIN',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: CropFreshColors.onBackground60,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.security,
              size: 16,
              color: CropFreshColors.green30Primary,
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Enter your 4-digit security PIN',
          style: TextStyle(
            fontSize: 12,
            color: CropFreshColors.onBackground60Secondary,
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _mpinControllers[index].text.isNotEmpty
                      ? CropFreshColors.green30Primary
                      : CropFreshColors.outline,
                  width: _mpinControllers[index].text.isNotEmpty ? 2 : 1,
                ),
                color: CropFreshColors.surface,
              ),
              child: TextField(
                controller: _mpinControllers[index],
                focusNode: _mpinFocusNodes[index],
                keyboardType: TextInputType.number,
                maxLength: 1,
                textAlign: TextAlign.center,
                obscureText: true,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onBackground60,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  counterText: '',
                ),
                onChanged: (value) {
                  if (value.length == 1 && index < 3) {
                    _mpinFocusNodes[index + 1].requestFocus();
                  } else if (value.isEmpty && index > 0) {
                    _mpinFocusNodes[index - 1].requestFocus();
                  }

                  // Update MPIN in controller
                  _loginController.updateMpin(_enteredMpin);
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isSmallScreen) {
    return ListenableBuilder(
      listenable: _loginController,
      builder: (context, child) {
        final state = _loginController.state;
        final isLoading = state.isLoading;
        final canLogin =
            _phoneController.text.isNotEmpty && _enteredMpin.length == 4;

        return SizedBox(
          width: double.infinity,
          height: isSmallScreen ? 48 : 56,
          child: FilledButton(
            onPressed: canLogin && !isLoading ? _handleLogin : null,
            style: FilledButton.styleFrom(
              backgroundColor: CropFreshColors.green30Primary,
              foregroundColor: CropFreshColors.onGreen30,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              disabledBackgroundColor: CropFreshColors.outline,
            ),
            child: isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CropFreshColors.onGreen30,
                      ),
                    ),
                  )
                : Text(
                    'Login',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildForgotMpinSection(bool isSmallScreen) {
    return Center(
      child: TextButton(
        onPressed: () => _handleForgotMpin(),
        style: TextButton.styleFrom(
          foregroundColor: CropFreshColors.green30Primary,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Forgot MPIN?',
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickLoginSection(bool isSmallScreen) {
    return ListenableBuilder(
      listenable: _loginController,
      builder: (context, child) {
        final lastUser = _loginController.lastUserData;

        if (lastUser == null) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CropFreshColors.green30Container.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CropFreshColors.green30Container.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: CropFreshColors.green30Primary,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Quick Login',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.w600,
                      color: CropFreshColors.green30Primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Welcome back, ${lastUser['fullName']}',
                style: TextStyle(
                  fontSize: 14,
                  color: CropFreshColors.onBackground60,
                ),
              ),
              Text(
                'Phone: ${lastUser['phoneNumber']}',
                style: TextStyle(
                  fontSize: 12,
                  color: CropFreshColors.onBackground60Secondary,
                ),
              ),
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () => _handleQuickLogin(lastUser),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: CropFreshColors.green30Primary,
                    side: BorderSide(
                      color: CropFreshColors.green30Primary,
                      width: 1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    'Continue as ${lastUser['fullName']}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.lightImpact();
      _loginController.login(
        phoneNumber: _phoneController.text,
        mpin: _enteredMpin,
      );
    }
  }

  void _handleQuickLogin(Map<String, dynamic> userData) {
    _phoneController.text = userData['phoneNumber'];
    _loginController.updatePhoneNumber(userData['phoneNumber']);

    // Focus on MPIN field
    _mpinFocusNodes[0].requestFocus();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please enter your MPIN to continue',
          style: TextStyle(
            color: CropFreshColors.onGreen30,
            fontWeight: FontWeight.w400,
          ),
        ),
        backgroundColor: CropFreshColors.green30Primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleForgotMpin() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.surface,
        title: Text(
          'Reset MPIN',
          style: TextStyle(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'To reset your MPIN, please contact customer support or visit your nearest CropFresh center.',
          style: TextStyle(color: CropFreshColors.onBackground60Secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(
                color: CropFreshColors.green30Primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
