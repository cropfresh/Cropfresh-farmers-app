// ===================================================================
// * REGISTRATION FLOW MODULE
// * Purpose: Multi-step user registration for CropFresh Farmers App
// * Steps: Phone/OTP, MPIN, Farmer Profile (with GPS, map, and offline support)
// * Security Level: HIGH - Handles sensitive user data
// ===================================================================

import 'package:flutter/material.dart';
import 'farm_details/farm_details_screen.dart';
// TODO: Add imports for OTP, location, and offline support services

/// * REGISTRATION FLOW ROOT WIDGET
/// * Manages the 3-step registration process
class RegistrationFlow extends StatefulWidget {
  const RegistrationFlow({super.key});

  @override
  State<RegistrationFlow> createState() => _RegistrationFlowState();
}

class _RegistrationFlowState extends State<RegistrationFlow> {
  int _currentStep = 0;
  String? _phoneNumber;
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _mpinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<TextEditingController> _reMpinControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  bool _otpSent = false;
  String? _mpin;
  String? _reMpin;
  String? _fullName;
  String? _farmerId;
  String? _experienceLevel;
  // TODO: Use LatLng from google_maps_flutter when available
  String? _farmLocation;
  String? _manualAddress;
  double? _landArea;
  String? _ownershipType;
  List<String> _primaryCrops = [];
  String? _irrigationType;
  String? _irrigationSource;

  // TODO: Add controllers and services for OTP, location, and offline caching

  String get _enteredOtp => _otpControllers.map((c) => c.text).join();
  String get _enteredMpin => _mpinControllers.map((c) => c.text).join();
  String get _enteredReMpin => _reMpinControllers.map((c) => c.text).join();

  void _goToNextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // * Navigate to Farm Details Screen after completing profile step
      _navigateToFarmDetails();
    }
  }

  void _goToPreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // * NAVIGATION TO FARM DETAILS SCREEN
  void _navigateToFarmDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FarmDetailsScreen(
          phoneNumber: _phoneNumber ?? '',
          fullName: _fullName ?? '',
          farmerId: _farmerId ?? '',
          experienceLevel: _experienceLevel ?? '',
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final c in _mpinControllers) {
      c.dispose();
    }
    for (final c in _reMpinControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _goToNextStep,
        onStepCancel: _goToPreviousStep,
        controlsBuilder: (context, details) {
          return Row(
            children: [
              if (details.stepIndex < 2)
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Continue'),
                )
              else
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: const Text('Next: Farm Details'),
                ),
              const SizedBox(width: 8),
              if (details.stepIndex > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Phone & OTP'),
            content: _buildPhoneOtpStep(),
            isActive: _currentStep == 0,
          ),
          Step(
            title: const Text('Set MPIN'),
            content: _buildMpinStep(),
            isActive: _currentStep == 1,
          ),
          Step(
            title: const Text('Farmer Profile'),
            content: _buildProfileStep(),
            isActive: _currentStep == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          decoration: const InputDecoration(labelText: 'Phone Number'),
          keyboardType: TextInputType.phone,
          onChanged: (value) => _phoneNumber = value,
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // TODO: Send OTP
            setState(() {
              _otpSent = true;
            });
            // * Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('OTP sent successfully!')),
            );
          },
          child: const Text('Send OTP'),
        ),
        if (_otpSent) ...[
          const SizedBox(height: 16),
          const Text('Enter OTP:'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (i) {
              return SizedBox(
                width: 40,
                child: TextField(
                  controller: _otpControllers[i],
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(counterText: ''),
                  onChanged: (value) {
                    if (value.length == 1 && i < 5) {
                      FocusScope.of(context).nextFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Verify OTP using _enteredOtp
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('OTP verified successfully!')),
              );
            },
            child: const Text('Verify OTP'),
          ),
        ],
      ],
    );
  }

  Widget _buildMpinStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter MPIN (4 digits):'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (i) {
            return SizedBox(
              width: 40,
              child: TextField(
                controller: _mpinControllers[i],
                keyboardType: TextInputType.number,
                maxLength: 1,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(counterText: ''),
                onChanged: (value) {
                  if (value.length == 1 && i < 3) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
        const Text('Re-enter MPIN:'),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (i) {
            return SizedBox(
              width: 40,
              child: TextField(
                controller: _reMpinControllers[i],
                keyboardType: TextInputType.number,
                maxLength: 1,
                textAlign: TextAlign.center,
                obscureText: true,
                decoration: const InputDecoration(counterText: ''),
                onChanged: (value) {
                  if (value.length == 1 && i < 3) {
                    FocusScope.of(context).nextFocus();
                  }
                },
              ),
            );
          }),
        ),
        // TODO: Add MPIN validation and confirmation
      ],
    );
  }

  Widget _buildProfileStep() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Full Name'),
            onChanged: (value) => _fullName = value,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.green.shade700, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Farmer ID will be auto-generated',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Your unique Farmer ID will be automatically created based on your farm location and registration details.',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Experience Level'),
            value: _experienceLevel,
            items: const [
              DropdownMenuItem(value: 'Beginner', child: Text('Beginner')),
              DropdownMenuItem(
                value: 'Intermediate',
                child: Text('Intermediate'),
              ),
              DropdownMenuItem(value: 'Advanced', child: Text('Advanced')),
            ],
            onChanged: (value) => setState(() => _experienceLevel = value),
          ),
          // TODO: Add GPS location picker, map integration, address autocomplete
          // TODO: Add land area input, ownership type, crop selection, irrigation
        ],
      ),
    );
  }
}

// TODO: Add documentation and tests for the registration flow
