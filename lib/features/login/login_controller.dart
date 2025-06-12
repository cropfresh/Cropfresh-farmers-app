// ===================================================================
// * LOGIN CONTROLLER MODULE
// * Purpose: Business logic and state management for user authentication
// * Features: Phone/MPIN validation, user session management, error handling
// * Security Level: HIGH - Handles authentication credentials
// ===================================================================

import 'package:flutter/material.dart';
import 'login_repository.dart';
import 'models/login_state.dart';
import 'models/user_profile.dart';

/// * LOGIN CONTROLLER CLASS
/// * Manages authentication state and business logic
/// * Follows ChangeNotifier pattern for reactive UI updates
class LoginController extends ChangeNotifier {
  final LoginRepository _repository;

  // ============================================================================
  // * STATE MANAGEMENT
  // ============================================================================

  LoginState _state = LoginState.initial();
  String _phoneNumber = '';
  String _mpin = '';
  UserProfile? _userProfile;
  Map<String, dynamic>? _lastUserData;

  LoginController(this._repository) {
    _loadLastUserData();
  }

  // ============================================================================
  // * GETTERS
  // ============================================================================

  LoginState get state => _state;
  String get phoneNumber => _phoneNumber;
  String get mpin => _mpin;
  UserProfile? get userProfile => _userProfile;
  Map<String, dynamic>? get lastUserData => _lastUserData;

  // ============================================================================
  // * PUBLIC METHODS
  // ============================================================================

  /// * Update phone number and validate format
  void updatePhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber.trim();
    _clearError();
    notifyListeners();
  }

  /// * Update MPIN and validate length
  void updateMpin(String mpin) {
    _mpin = mpin;
    _clearError();
    notifyListeners();
  }

  /// * Authenticate user with phone number and MPIN
  Future<void> login({
    required String phoneNumber,
    required String mpin,
  }) async {
    if (!_validateInput(phoneNumber, mpin)) return;

    _setState(LoginState.loading());

    try {
      // * Attempt authentication
      final authResult = await _repository.authenticateUser(
        phoneNumber: phoneNumber,
        mpin: mpin,
      );

      if (authResult.isSuccess) {
        _userProfile = authResult.userProfile;
        await _saveUserSession(authResult.userProfile!);
        _setState(LoginState.success(userProfile: authResult.userProfile!));
      } else {
        _setState(LoginState.error(message: authResult.errorMessage));
      }
    } catch (e) {
      _setState(
        LoginState.error(
          message: 'Login failed. Please check your connection and try again.',
        ),
      );
    }
  }

  /// * Quick login with stored user data
  Future<void> quickLogin(Map<String, dynamic> userData) async {
    _phoneNumber = userData['phoneNumber'];
    // Note: Still requires MPIN entry for security
    notifyListeners();
  }

  /// * Reset password/MPIN process
  Future<void> resetMpin(String phoneNumber) async {
    _setState(LoginState.loading());

    try {
      final success = await _repository.requestMpinReset(phoneNumber);

      if (success) {
        _setState(
          LoginState.success(
            message: 'Reset instructions sent to your registered phone number.',
          ),
        );
      } else {
        _setState(
          LoginState.error(
            message: 'Unable to process reset request. Please try again.',
          ),
        );
      }
    } catch (e) {
      _setState(
        LoginState.error(
          message: 'Reset failed. Please check your connection and try again.',
        ),
      );
    }
  }

  /// * Logout user and clear session
  Future<void> logout() async {
    try {
      await _repository.clearUserSession();
      _userProfile = null;
      _phoneNumber = '';
      _mpin = '';
      _setState(LoginState.initial());
    } catch (e) {
      // ! Silent failure for logout - user should still be logged out locally
      _userProfile = null;
      _setState(LoginState.initial());
    }
  }

  /// * Check if user has valid session
  Future<bool> checkUserSession() async {
    try {
      final userProfile = await _repository.getCurrentUser();
      if (userProfile != null) {
        _userProfile = userProfile;
        _setState(LoginState.success(userProfile: userProfile));
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // * PRIVATE METHODS
  // ============================================================================

  /// * Load last user data for quick login
  Future<void> _loadLastUserData() async {
    try {
      _lastUserData = await _repository.getLastUserData();
      notifyListeners();
    } catch (e) {
      // ! Silent failure - quick login feature will be unavailable
    }
  }

  /// * Validate input data before authentication
  bool _validateInput(String phoneNumber, String mpin) {
    // * Phone number validation
    if (phoneNumber.isEmpty) {
      _setState(LoginState.error(message: 'Please enter your phone number'));
      return false;
    }

    // * Remove country code and spaces for validation
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length < 10) {
      _setState(LoginState.error(message: 'Please enter a valid phone number'));
      return false;
    }

    // * MPIN validation
    if (mpin.isEmpty) {
      _setState(LoginState.error(message: 'Please enter your MPIN'));
      return false;
    }

    if (mpin.length != 4) {
      _setState(LoginState.error(message: 'MPIN must be 4 digits'));
      return false;
    }

    if (!RegExp(r'^\d{4}$').hasMatch(mpin)) {
      _setState(LoginState.error(message: 'MPIN must contain only numbers'));
      return false;
    }

    return true;
  }

  /// * Save user session after successful login
  Future<void> _saveUserSession(UserProfile userProfile) async {
    try {
      await _repository.saveUserSession(userProfile);
      await _repository.saveLastUserData({
        'phoneNumber': userProfile.phoneNumber,
        'fullName': userProfile.fullName,
        'farmerId': userProfile.farmerId,
        'lastLoginTime': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // ! Non-critical error - user is still logged in
      debugPrint('Failed to save user session: $e');
    }
  }

  /// * Update controller state and notify listeners
  void _setState(LoginState newState) {
    _state = newState;
    notifyListeners();
  }

  /// * Clear current error state
  void _clearError() {
    if (_state.hasError) {
      _setState(LoginState.initial());
    }
  }

  // ============================================================================
  // * CLEANUP
  // ============================================================================

  @override
  void dispose() {
    // * Clean up any pending operations
    super.dispose();
  }
}

// ============================================================================
// * AUTHENTICATION RESULT MODEL
// ============================================================================

/// * Result model for authentication operations
class AuthResult {
  final bool isSuccess;
  final UserProfile? userProfile;
  final String errorMessage;

  const AuthResult({
    required this.isSuccess,
    this.userProfile,
    this.errorMessage = '',
  });

  /// * Factory constructor for successful authentication
  factory AuthResult.success(UserProfile userProfile) {
    return AuthResult(isSuccess: true, userProfile: userProfile);
  }

  /// * Factory constructor for failed authentication
  factory AuthResult.failure(String errorMessage) {
    return AuthResult(isSuccess: false, errorMessage: errorMessage);
  }
}
