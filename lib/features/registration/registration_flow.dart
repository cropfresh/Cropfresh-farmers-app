// ===================================================================
// * REGISTRATION FLOW MODULE - MATERIAL 3 DESIGN
// * Purpose: Multi-step user registration for CropFresh Farmers App
// * Steps: Phone/OTP, MPIN, Farmer Profile (Farmer-friendly UI)
// * Security Level: HIGH - Handles sensitive user data
// * Design: Material 3 with accessibility and simplicity for farmers
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import 'farm_details/farm_details_screen.dart';
// TODO: Add imports for OTP, location, and offline support services

/// * REGISTRATION FLOW ROOT WIDGET
/// * Manages the 3-step registration process with Material 3 design
class RegistrationFlow extends StatefulWidget {
  const RegistrationFlow({super.key});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow>
    with TickerProviderStateMixin {
  // * ANIMATION CONTROLLERS
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // * STATE MANAGEMENT
  int _currentStep = 0;
  bool _isLoading = false;
  String? _errorMessage;
  bool _canProceed = false;
  bool _otpVerified = false;
  bool _mpinEntered = false;

  // * FORM KEYS
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _mpinFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();

  // * REGISTRATION DATA
  String? _phoneNumber;
  String? _fullName;
  String? _experienceLevel;

  // * OTP CONTROLLERS
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  bool _otpSent = false;

  // * MPIN CONTROLLERS
  final List<TextEditingController> _mpinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _confirmMpinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _mpinFocusNodes = List.generate(4, (_) => FocusNode());
  final List<FocusNode> _confirmMpinFocusNodes = List.generate(
    4,
    (_) => FocusNode(),
  );

  // * PROFILE CONTROLLERS
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _validateCurrentStep();
  }

  void _initAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();

    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _otpFocusNodes) {
      node.dispose();
    }
    for (final controller in _mpinControllers) {
      controller.dispose();
    }
    for (final controller in _confirmMpinControllers) {
      controller.dispose();
    }
    for (final node in _mpinFocusNodes) {
      node.dispose();
    }
    for (final node in _confirmMpinFocusNodes) {
      node.dispose();
    }

    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _validateCurrentStep() {
    setState(() {
      switch (_currentStep) {
        case 0:
          _canProceed =
              _phoneNumber != null &&
              _phoneNumber!.length >= 10 &&
              _otpSent &&
              _otpVerified;
          break;
        case 1:
          final mpin = _mpinControllers.map((c) => c.text).join();
          final confirmMpin = _confirmMpinControllers.map((c) => c.text).join();
          _canProceed =
              _mpinEntered &&
              mpin.length == 4 &&
              confirmMpin.length == 4 &&
              mpin == confirmMpin;
          break;
        case 2:
          _canProceed =
              _fullName != null &&
              _fullName!.isNotEmpty &&
              _experienceLevel != null;
          break;
        default:
          _canProceed = false;
      }
    });
  }

  Future<void> _goToNextStep() async {
    if (!_canProceed) return;

    if (_currentStep < 2) {
      await _slideController.reverse();
      setState(() {
        _currentStep++;
      });
      await _slideController.forward();
      _validateCurrentStep();
    } else {
      _navigateToFarmDetails();
    }
  }

  Future<void> _goToPreviousStep() async {
    if (_currentStep > 0) {
      await _slideController.reverse();
      setState(() {
        _currentStep--;
      });
      await _slideController.forward();
      _validateCurrentStep();
    }
  }

  void _navigateToFarmDetails() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            FarmDetailsScreen(
              phoneNumber: _phoneNumber ?? '',
              fullName: _fullName ?? '',
              experienceLevel: _experienceLevel ?? '',
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildCurrentStep(),
                  ),
                ),
              ),
            ),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CropFreshColors.green30Primary,
            CropFreshColors.green30Fresh,
          ],
        ),
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            IconButton(
              onPressed: _goToPreviousStep,
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
              ),
            ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CropFresh Registration',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _getStepTitle(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentStep + 1}/3',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Verify your phone number';
      case 1:
        return 'Set your secure PIN';
      case 2:
        return 'Tell us about yourself';
      default:
        return '';
    }
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? CropFreshColors.green30Primary
                          : CropFreshColors.background60Container,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 2)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? CropFreshColors.green30Primary
                          : isActive
                          ? CropFreshColors.orange10Primary
                          : CropFreshColors.background60Container,
                      shape: BoxShape.circle,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildPhoneOtpStep();
      case 1:
        return _buildMpinStep();
      case 2:
        return _buildProfileStep();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPhoneOtpStep() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * PHONE NUMBER SECTION
          _buildSectionCard(
            icon: Icons.phone_android,
            title: 'Enter your phone number',
            subtitle: 'We\'ll send you a verification code',
            child: Column(
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 10,
                  style: Theme.of(context).textTheme.headlineSmall,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '9876543210',
                    prefixIcon: Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CropFreshColors.green30Container,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '+91',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: CropFreshColors.green30Light,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: CropFreshColors.green30Primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: CropFreshColors.background60Secondary,
                  ),
                  onChanged: (value) {
                    _phoneNumber = value;
                    _validateCurrentStep();
                  },
                  validator: (value) {
                    if (value == null || value.length < 10) {
                      return 'Please enter a valid 10-digit phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed:
                        _phoneNumber != null && _phoneNumber!.length == 10
                        ? _sendOtp
                        : null,
                    icon: const Icon(Icons.sms),
                    label: Text(_otpSent ? 'Resend OTP' : 'Send OTP'),
                    style: FilledButton.styleFrom(
                      backgroundColor: CropFreshColors.orange10Primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // * OTP SECTION
          if (_otpSent) ...[
            const SizedBox(height: 24),
            _buildSectionCard(
              icon: Icons.security,
              title: 'Enter verification code',
              subtitle: 'Check your SMS for the 6-digit code',
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 45,
                        height: 60,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _otpFocusNodes[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CropFreshColors.green30Primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: CropFreshColors.background60Secondary,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              _otpFocusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _otpFocusNodes[index - 1].requestFocus();
                            }
                            _validateCurrentStep();
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // * VERIFY OTP BUTTON
                  if (!_otpVerified &&
                      _otpControllers.every((c) => c.text.isNotEmpty))
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: _verifyOtp,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.verified_user),
                        label: Text(_isLoading ? 'Verifying...' : 'Verify OTP'),
                        style: FilledButton.styleFrom(
                          backgroundColor: CropFreshColors.green30Primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                  // * OTP VERIFIED SUCCESS MESSAGE
                  if (_otpVerified)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CropFreshColors.successContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CropFreshColors.successPrimary.withOpacity(
                            0.3,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: CropFreshColors.successPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Phone Verified Successfully!',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: CropFreshColors.onSuccessContainer,
                                  ),
                                ),
                                Text(
                                  'Your phone number +91 $_phoneNumber has been verified',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: CropFreshColors.onSuccessContainer
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: _sendOtp,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Didn\'t receive? Resend'),
                    style: TextButton.styleFrom(
                      foregroundColor: CropFreshColors.green30Primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMpinStep() {
    return Form(
      key: _mpinFormKey,
      child: Column(
        children: [
          _buildSectionCard(
            icon: Icons.lock,
            title: 'Create your secure PIN',
            subtitle: 'This PIN will be used to access your account',
            child: Column(
              children: [
                const Text(
                  'Enter 4-digit PIN',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      height: 60,
                      child: TextFormField(
                        controller: _mpinControllers[index],
                        focusNode: _mpinFocusNodes[index],
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(1),
                        ],
                        obscureText: true,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: CropFreshColors.green30Primary,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: CropFreshColors.background60Secondary,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 3) {
                            _mpinFocusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            _mpinFocusNodes[index - 1].requestFocus();
                          }

                          // * Check if MPIN is complete and show confirmation step
                          final mpin = _mpinControllers
                              .map((c) => c.text)
                              .join();
                          if (mpin.length == 4 && !_mpinEntered) {
                            setState(() {
                              _mpinEntered = true;
                            });
                            // * Show success message briefly
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 12),
                                    const Text(
                                      'PIN entered successfully! Now confirm it.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: CropFreshColors.successPrimary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                          _validateCurrentStep();
                        },
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // * MPIN ENTERED SUCCESS INDICATOR
                if (_mpinEntered)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CropFreshColors.successContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CropFreshColors.successPrimary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: CropFreshColors.successPrimary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'PIN created successfully! Please confirm below.',
                            style: TextStyle(
                              color: CropFreshColors.onSuccessContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // * SHOW CONFIRMATION SECTION ONLY AFTER MPIN IS ENTERED
          if (_mpinEntered) ...[
            const SizedBox(height: 24),
            _buildSectionCard(
              icon: Icons.verified_user,
              title: 'Confirm your PIN',
              subtitle: 'Enter the same PIN again to confirm',
              child: Column(
                children: [
                  const Text(
                    'Re-enter 4-digit PIN',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextFormField(
                          controller: _confirmMpinControllers[index],
                          focusNode: _confirmMpinFocusNodes[index],
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(1),
                          ],
                          obscureText: true,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CropFreshColors.green30Primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: CropFreshColors.background60Secondary,
                          ),
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 3) {
                              _confirmMpinFocusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              _confirmMpinFocusNodes[index - 1].requestFocus();
                            }
                            _validateCurrentStep();
                          },
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  if (_getMpinValidationMessage() != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isPinMatching()
                            ? CropFreshColors.successContainer
                            : CropFreshColors.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isPinMatching() ? Icons.check_circle : Icons.error,
                            color: _isPinMatching()
                                ? CropFreshColors.successPrimary
                                : CropFreshColors.errorPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _getMpinValidationMessage()!,
                              style: TextStyle(
                                color: _isPinMatching()
                                    ? CropFreshColors.onSuccessContainer
                                    : CropFreshColors.onErrorContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileStep() {
    return Form(
      key: _profileFormKey,
      child: Column(
        children: [
          _buildSectionCard(
            icon: Icons.person,
            title: 'Personal Information',
            subtitle: 'Tell us about yourself',
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your full name',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: CropFreshColors.green30Primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: CropFreshColors.background60Secondary,
                  ),
                  onChanged: (value) {
                    _fullName = value;
                    _validateCurrentStep();
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // * REDESIGNED DROPDOWN: Simplified structure to prevent overflow
                DropdownButtonFormField<String>(
                  value: _experienceLevel,
                  decoration: InputDecoration(
                    labelText: 'Farming Experience',
                    hintText: 'Select your experience level',
                    prefixIcon: const Icon(Icons.agriculture),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: CropFreshColors.green30Primary,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: CropFreshColors.background60Secondary,
                  ),
                  isExpanded: true,
                  // * SIMPLE DROPDOWN ITEMS: Single line text to prevent overflow
                  items: const [
                    DropdownMenuItem(
                      value: 'new',
                      child: Text('🌱 New to Farming - Just starting out'),
                    ),
                    DropdownMenuItem(
                      value: 'beginner',
                      child: Text('🌿 Beginner - 1-2 years experience'),
                    ),
                    DropdownMenuItem(
                      value: 'intermediate',
                      child: Text('🌳 Intermediate - 3-5 years experience'),
                    ),
                    DropdownMenuItem(
                      value: 'experienced',
                      child: Text('🌲 Experienced - 5+ years experience'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _experienceLevel = value;
                    });
                    _validateCurrentStep();
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select your experience level';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // * NEXT STEP INFO
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Next: Farm Details',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          Text(
                            'Your Farmer ID will be generated based on your farm location',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.agriculture,
                        color: Theme.of(context).colorScheme.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Complete your farm details including location, crops, and land information',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: CropFreshColors.green30Primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CropFreshColors.green30Container,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: CropFreshColors.green30Primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: CropFreshColors.onBackground60,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: CropFreshColors.onBackground60Secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _goToPreviousStep,
                  icon: const Icon(Icons.arrow_back_ios),
                  label: const Text('Previous'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: CropFreshColors.green30Primary),
                    foregroundColor: CropFreshColors.green30Primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              flex: _currentStep == 0 ? 1 : 2,
              child: FilledButton.icon(
                onPressed: _canProceed ? _goToNextStep : null,
                icon: Icon(
                  _currentStep == 2 ? Icons.check : Icons.arrow_forward_ios,
                ),
                label: Text(
                  _currentStep == 2 ? 'Complete Registration' : 'Continue',
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: _canProceed
                      ? CropFreshColors.orange10Primary
                      : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendOtp() {
    if (_phoneNumber != null && _phoneNumber!.length == 10) {
      setState(() {
        _otpSent = true;
        _isLoading = true;
      });

      // TODO: Implement actual OTP sending
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'OTP sent successfully to +91 $_phoneNumber',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: CropFreshColors.successPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
    }
  }

  void _verifyOtp() {
    final enteredOtp = _otpControllers.map((c) => c.text).join();

    if (enteredOtp.length == 6) {
      setState(() {
        _isLoading = true;
      });

      // TODO: Implement actual OTP verification
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          _isLoading = false;
          _otpVerified = true;
        });
        _validateCurrentStep();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'OTP verified successfully! You can now proceed.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: CropFreshColors.successPrimary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      });
    }
  }

  String? _getMpinValidationMessage() {
    final mpin = _mpinControllers.map((c) => c.text).join();
    final confirmMpin = _confirmMpinControllers.map((c) => c.text).join();

    if (mpin.isEmpty || confirmMpin.isEmpty) return null;

    if (mpin.length < 4 || confirmMpin.length < 4) {
      return 'PIN must be 4 digits';
    }

    if (mpin == confirmMpin) {
      return 'PIN confirmed successfully!';
    } else {
      return 'PINs do not match. Please try again.';
    }
  }

  bool _isPinMatching() {
    final mpin = _mpinControllers.map((c) => c.text).join();
    final confirmMpin = _confirmMpinControllers.map((c) => c.text).join();
    return mpin.length == 4 && confirmMpin.length == 4 && mpin == confirmMpin;
  }
}

// TODO: Add documentation and tests for the registration flow
