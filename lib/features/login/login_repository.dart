// ===================================================================
// * LOGIN REPOSITORY MODULE
// * Purpose: Data layer for authentication operations
// * Features: API calls, local storage, session management, offline support
// * Security Level: HIGH - Handles authentication credentials and storage
// ===================================================================

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_controller.dart';
import 'models/user_profile.dart';

/// * LOGIN REPOSITORY CLASS
/// * Handles authentication data operations and API calls
class LoginRepository {
  // ============================================================================
  // * STORAGE KEYS
  // ============================================================================

  static const String _keyUserSession = 'user_session';
  static const String _keyLastUserData = 'last_user_data';
  static const String _keyRegisteredUsers = 'registered_users';
  static const String _keyMpinAttempts = 'mpin_attempts';

  // ============================================================================
  // * AUTHENTICATION METHODS
  // ============================================================================

  /// * Authenticate user with phone number and MPIN
  /// * Returns AuthResult with success/failure status
  Future<AuthResult> authenticateUser({
    required String phoneNumber,
    required String mpin,
  }) async {
    try {
      // ! SECURITY: Check for too many failed attempts
      if (await _isAccountLocked(phoneNumber)) {
        return AuthResult.failure(
          'Account temporarily locked due to multiple failed attempts. Please try again later.',
        );
      }

      // * Clean phone number for comparison
      final cleanPhone = _cleanPhoneNumber(phoneNumber);

      // * Try API authentication first
      final apiResult = await _authenticateWithApi(cleanPhone, mpin);
      if (apiResult.isSuccess) {
        await _clearFailedAttempts(phoneNumber);
        return apiResult;
      }

      // * Fallback to local authentication (offline mode)
      final localResult = await _authenticateLocally(cleanPhone, mpin);
      if (localResult.isSuccess) {
        await _clearFailedAttempts(phoneNumber);
        return localResult;
      }

      // * Record failed attempt
      await _recordFailedAttempt(phoneNumber);
      return AuthResult.failure('Invalid phone number or MPIN');
    } catch (e) {
      debugPrint('Authentication error: $e');
      return AuthResult.failure(
        'Authentication failed. Please check your connection and try again.',
      );
    }
  }

  /// * Authenticate with API (production implementation)
  Future<AuthResult> _authenticateWithApi(
    String phoneNumber,
    String mpin,
  ) async {
    try {
      // * Mock API call - replace with actual HTTP request
      await Future.delayed(const Duration(milliseconds: 1500));

      // * Mock API response - in production, call actual authentication endpoint
      // TODO: Replace with actual API call to /api/auth/login
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'mpin': mpin,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userProfile = UserProfile.fromJson(data['user']);
        return AuthResult.success(userProfile);
      }
      */

      // * Check against mock registered users (for demo)
      final registeredUsers = await _getRegisteredUsers();
      final user = registeredUsers.firstWhere(
        (user) =>
            _cleanPhoneNumber(user['phoneNumber']) == phoneNumber &&
            user['mpin'] == mpin,
        orElse: () => <String, dynamic>{},
      );

      if (user.isNotEmpty) {
        final userProfile = UserProfile.fromJson(user);
        return AuthResult.success(
          userProfile.copyWith(lastLoginTime: DateTime.now()),
        );
      }

      return AuthResult.failure('Invalid credentials');
    } catch (e) {
      throw Exception('API authentication failed: $e');
    }
  }

  /// * Authenticate locally (offline mode)
  Future<AuthResult> _authenticateLocally(
    String phoneNumber,
    String mpin,
  ) async {
    try {
      final registeredUsers = await _getRegisteredUsers();

      final user = registeredUsers.firstWhere(
        (user) =>
            _cleanPhoneNumber(user['phoneNumber']) == phoneNumber &&
            user['mpin'] == mpin,
        orElse: () => <String, dynamic>{},
      );

      if (user.isNotEmpty) {
        final userProfile = UserProfile.fromJson(user);
        return AuthResult.success(
          userProfile.copyWith(lastLoginTime: DateTime.now()),
        );
      }

      return AuthResult.failure('Invalid phone number or MPIN');
    } catch (e) {
      throw Exception('Local authentication failed: $e');
    }
  }

  // ============================================================================
  // * SESSION MANAGEMENT
  // ============================================================================

  /// * Save user session after successful login
  Future<void> saveUserSession(UserProfile userProfile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = userProfile.toJson();
      await prefs.setString(_keyUserSession, jsonEncode(sessionData));
    } catch (e) {
      throw Exception('Failed to save user session: $e');
    }
  }

  /// * Get current authenticated user
  Future<UserProfile?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionData = prefs.getString(_keyUserSession);

      if (sessionData != null) {
        final userData = jsonDecode(sessionData) as Map<String, dynamic>;
        return UserProfile.fromJson(userData);
      }

      return null;
    } catch (e) {
      debugPrint('Failed to get current user: $e');
      return null;
    }
  }

  /// * Clear user session (logout)
  Future<void> clearUserSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUserSession);
    } catch (e) {
      throw Exception('Failed to clear user session: $e');
    }
  }

  /// * Check if user has valid session
  Future<bool> hasValidSession() async {
    final user = await getCurrentUser();
    return user != null && user.isActive;
  }

  // ============================================================================
  // * QUICK LOGIN SUPPORT
  // ============================================================================

  /// * Save last user data for quick login
  Future<void> saveLastUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyLastUserData, jsonEncode(userData));
    } catch (e) {
      throw Exception('Failed to save last user data: $e');
    }
  }

  /// * Get last user data for quick login
  Future<Map<String, dynamic>?> getLastUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUserData = prefs.getString(_keyLastUserData);

      if (lastUserData != null) {
        return jsonDecode(lastUserData) as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      debugPrint('Failed to get last user data: $e');
      return null;
    }
  }

  // ============================================================================
  // * MPIN RESET FUNCTIONALITY
  // ============================================================================

  /// * Request MPIN reset (sends OTP or reset instructions)
  Future<bool> requestMpinReset(String phoneNumber) async {
    try {
      // * Mock API call for MPIN reset
      await Future.delayed(const Duration(milliseconds: 1000));

      // TODO: Replace with actual API call to /api/auth/reset-mpin
      /*
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-mpin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': phoneNumber}),
      );
      
      return response.statusCode == 200;
      */

      // * Check if phone number exists in registered users
      final registeredUsers = await _getRegisteredUsers();
      final userExists = registeredUsers.any(
        (user) =>
            _cleanPhoneNumber(user['phoneNumber']) ==
            _cleanPhoneNumber(phoneNumber),
      );

      return userExists;
    } catch (e) {
      debugPrint('MPIN reset request failed: $e');
      return false;
    }
  }

  // ============================================================================
  // * REGISTERED USERS MANAGEMENT (FOR DEMO)
  // ============================================================================

  /// * Add a new registered user (called during registration)
  Future<void> addRegisteredUser(Map<String, dynamic> userData) async {
    try {
      final registeredUsers = await _getRegisteredUsers();

      // * Check if user already exists
      final existingUserIndex = registeredUsers.indexWhere(
        (user) =>
            _cleanPhoneNumber(user['phoneNumber']) ==
            _cleanPhoneNumber(userData['phoneNumber']),
      );

      if (existingUserIndex != -1) {
        // * Update existing user
        registeredUsers[existingUserIndex] = userData;
      } else {
        // * Add new user
        registeredUsers.add(userData);
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyRegisteredUsers, jsonEncode(registeredUsers));
    } catch (e) {
      throw Exception('Failed to add registered user: $e');
    }
  }

  /// * Get all registered users (for demo/offline purposes)
  Future<List<Map<String, dynamic>>> _getRegisteredUsers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usersData = prefs.getString(_keyRegisteredUsers);

      if (usersData != null) {
        final usersList = jsonDecode(usersData) as List;
        return usersList.cast<Map<String, dynamic>>();
      }

      // * Return demo users if no registered users exist
      return _getDemoUsers();
    } catch (e) {
      debugPrint('Failed to get registered users: $e');
      return _getDemoUsers();
    }
  }

  /// * Get demo users for testing (when no registered users exist)
  List<Map<String, dynamic>> _getDemoUsers() {
    return [
      {
        'phoneNumber': '9876543210',
        'fullName': 'Demo Farmer',
        'farmerId': 'MH-PUN-HAV-202506-1234',
        'experienceLevel': 'Intermediate',
        'mpin': '1234',
        'isActive': true,
        'latitude': 18.5204,
        'longitude': 73.8567,
        'address': 'Demo Farm Location',
        'village': 'Pirangut',
        'district': 'Pune',
        'addressState': 'Maharashtra',
        'pincode': '412115',
        'landArea': 2.5,
        'landAreaUnit': 'hectares',
        'ownershipType': 'Owner',
        'primaryCrops': ['rice', 'wheat', 'tomato'],
        'irrigationType': 'Drip Irrigation',
        'irrigationSource': 'Borewell',
      },
    ];
  }

  // ============================================================================
  // * SECURITY HELPERS
  // ============================================================================

  /// * Check if account is locked due to failed attempts
  Future<bool> _isAccountLocked(String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsData = prefs.getString(_keyMpinAttempts);

      if (attemptsData != null) {
        final attempts = jsonDecode(attemptsData) as Map<String, dynamic>;
        final userAttempts =
            attempts[_cleanPhoneNumber(phoneNumber)] as Map<String, dynamic>?;

        if (userAttempts != null) {
          final count = userAttempts['count'] as int;
          final lastAttempt = DateTime.parse(
            userAttempts['lastAttempt'] as String,
          );

          // * Account locked for 15 minutes after 5 failed attempts
          if (count >= 5) {
            final timeSinceLastAttempt = DateTime.now().difference(lastAttempt);
            return timeSinceLastAttempt.inMinutes < 15;
          }
        }
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// * Record a failed login attempt
  Future<void> _recordFailedAttempt(String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsData = prefs.getString(_keyMpinAttempts);

      Map<String, dynamic> attempts = {};
      if (attemptsData != null) {
        attempts = jsonDecode(attemptsData) as Map<String, dynamic>;
      }

      final cleanPhone = _cleanPhoneNumber(phoneNumber);
      final userAttempts = attempts[cleanPhone] as Map<String, dynamic>? ?? {};

      userAttempts['count'] = (userAttempts['count'] as int? ?? 0) + 1;
      userAttempts['lastAttempt'] = DateTime.now().toIso8601String();

      attempts[cleanPhone] = userAttempts;

      await prefs.setString(_keyMpinAttempts, jsonEncode(attempts));
    } catch (e) {
      debugPrint('Failed to record attempt: $e');
    }
  }

  /// * Clear failed attempts after successful login
  Future<void> _clearFailedAttempts(String phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final attemptsData = prefs.getString(_keyMpinAttempts);

      if (attemptsData != null) {
        final attempts = jsonDecode(attemptsData) as Map<String, dynamic>;
        attempts.remove(_cleanPhoneNumber(phoneNumber));
        await prefs.setString(_keyMpinAttempts, jsonEncode(attempts));
      }
    } catch (e) {
      debugPrint('Failed to clear attempts: $e');
    }
  }

  // ============================================================================
  // * UTILITY METHODS
  // ============================================================================

  /// * Clean phone number for consistent comparison
  String _cleanPhoneNumber(String phoneNumber) {
    // * Remove all non-digit characters
    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // * Return last 10 digits for consistent comparison
    if (cleaned.length >= 10) {
      return cleaned.substring(cleaned.length - 10);
    }

    return cleaned;
  }
}
