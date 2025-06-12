// ===================================================================
// * DASHBOARD STATE MODEL
// * Purpose: Immutable dashboard state model for complete dashboard state
// * Features: Loading states, data, errors, offline status
// * Security Level: MEDIUM - Contains user-specific dashboard data
// ===================================================================

import 'weather_data.dart';
import 'market_price.dart';
import 'notification_data.dart';
import 'quick_action.dart';

// * DASHBOARD STATE MODEL
class DashboardState {
  final bool isLoading;
  final bool isWeatherLoading;
  final bool isMarketLoading;
  final bool isNotificationsLoading;
  final bool isOffline;
  final WeatherResponse? weather;
  final MarketPriceResponse? marketData;
  final List<NotificationData>? notifications;
  final List<QuickAction>? quickActions;
  final DateTime? lastSync;
  final String? errorMessage;
  final String? weatherError;
  final String? marketError;
  final String? notificationError;

  const DashboardState({
    this.isLoading = false,
    this.isWeatherLoading = false,
    this.isMarketLoading = false,
    this.isNotificationsLoading = false,
    this.isOffline = false,
    this.weather,
    this.marketData,
    this.notifications,
    this.quickActions,
    this.lastSync,
    this.errorMessage,
    this.weatherError,
    this.marketError,
    this.notificationError,
  });

  // * Helper methods for state checking
  bool get hasWeatherData => weather != null;
  bool get hasMarketData => marketData != null;
  bool get hasNotifications =>
      notifications != null && notifications!.isNotEmpty;
  bool get hasError => errorMessage != null;
  bool get hasWeatherError => weatherError != null;
  bool get hasMarketError => marketError != null;
  bool get hasNotificationError => notificationError != null;
  bool get isInitialLoading => isLoading && !hasWeatherData && !hasMarketData;

  DashboardState copyWith({
    bool? isLoading,
    bool? isWeatherLoading,
    bool? isMarketLoading,
    bool? isNotificationsLoading,
    bool? isOffline,
    WeatherResponse? weather,
    MarketPriceResponse? marketData,
    List<NotificationData>? notifications,
    List<QuickAction>? quickActions,
    DateTime? lastSync,
    String? errorMessage,
    String? weatherError,
    String? marketError,
    String? notificationError,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      isWeatherLoading: isWeatherLoading ?? this.isWeatherLoading,
      isMarketLoading: isMarketLoading ?? this.isMarketLoading,
      isNotificationsLoading:
          isNotificationsLoading ?? this.isNotificationsLoading,
      isOffline: isOffline ?? this.isOffline,
      weather: weather ?? this.weather,
      marketData: marketData ?? this.marketData,
      notifications: notifications ?? this.notifications,
      quickActions: quickActions ?? this.quickActions,
      lastSync: lastSync ?? this.lastSync,
      errorMessage: errorMessage ?? this.errorMessage,
      weatherError: weatherError ?? this.weatherError,
      marketError: marketError ?? this.marketError,
      notificationError: notificationError ?? this.notificationError,
    );
  }
}
