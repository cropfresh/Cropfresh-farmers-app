// ===================================================================
// * LOGIN STATE MODEL
// * Purpose: Immutable state management for login process
// * States: initial, loading, success, error
// * Security Level: MEDIUM - Contains user session data
// ===================================================================

import 'user_profile.dart';

/// * LOGIN STATE ENUMERATION
/// * Represents different states during authentication
enum LoginStatus { initial, loading, success, error }

/// * LOGIN STATE MODEL
/// * Immutable state object for login process
class LoginState {
  final LoginStatus status;
  final UserProfile? userProfile;
  final String message;
  final String errorMessage;

  const LoginState({
    required this.status,
    this.userProfile,
    this.message = '',
    this.errorMessage = '',
  });

  // ============================================================================
  // * FACTORY CONSTRUCTORS
  // ============================================================================

  /// * Initial state - no authentication attempted
  factory LoginState.initial() {
    return const LoginState(status: LoginStatus.initial);
  }

  /// * Loading state - authentication in progress
  factory LoginState.loading() {
    return const LoginState(status: LoginStatus.loading);
  }

  /// * Success state - authentication completed successfully
  factory LoginState.success({UserProfile? userProfile, String message = ''}) {
    return LoginState(
      status: LoginStatus.success,
      userProfile: userProfile,
      message: message,
    );
  }

  /// * Error state - authentication failed
  factory LoginState.error({required String message}) {
    return LoginState(status: LoginStatus.error, errorMessage: message);
  }

  // ============================================================================
  // * COMPUTED PROPERTIES
  // ============================================================================

  /// * Check if current state is initial
  bool get isInitial => status == LoginStatus.initial;

  /// * Check if authentication is in progress
  bool get isLoading => status == LoginStatus.loading;

  /// * Check if authentication was successful
  bool get isSuccess => status == LoginStatus.success;

  /// * Check if authentication failed
  bool get hasError => status == LoginStatus.error;

  /// * Check if user is authenticated (has valid session)
  bool get isAuthenticated => isSuccess && userProfile != null;

  // ============================================================================
  // * STATE COMPARISON AND COPYING
  // ============================================================================

  /// * Create a copy of current state with new values
  LoginState copyWith({
    LoginStatus? status,
    UserProfile? userProfile,
    String? message,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// * Equality comparison for state objects
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LoginState &&
        other.status == status &&
        other.userProfile == userProfile &&
        other.message == message &&
        other.errorMessage == errorMessage;
  }

  /// * Hash code for state objects
  @override
  int get hashCode {
    return Object.hash(status, userProfile, message, errorMessage);
  }

  /// * String representation for debugging
  @override
  String toString() {
    return 'LoginState(status: $status, userProfile: $userProfile, message: $message, errorMessage: $errorMessage)';
  }
}
