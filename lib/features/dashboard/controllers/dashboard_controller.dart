// ===================================================================
// * DASHBOARD CONTROLLER
// * Purpose: Business logic and state management for dashboard
// * Features: Weather data, market prices, notifications, quick actions
// * State Management: Riverpod StateNotifier
// * Security Level: MEDIUM - Handles user-specific dashboard data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dashboard_state.dart';
import '../models/weather_data.dart';
import '../models/market_price.dart';
import '../models/notification_data.dart';
import '../models/quick_action.dart';
import '../repositories/dashboard_repository.dart';
import '../services/weather_service.dart';
import '../services/market_service.dart';
import '../services/notification_service.dart';

// * DASHBOARD STATE NOTIFIER
// * Manages complete dashboard state using Riverpod
class DashboardController extends StateNotifier<DashboardState> {
  final DashboardRepository _repository;
  final WeatherService _weatherService;
  final MarketService _marketService;
  final NotificationService _notificationService;

  DashboardController(
    this._repository,
    this._weatherService,
    this._marketService,
    this._notificationService,
  ) : super(const DashboardState());

  // ============================================================================
  // * INITIALIZATION METHODS
  // ============================================================================

  /// * Initialize dashboard with all required data
  Future<void> initializeDashboard(String farmerId) async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);

      // * Load quick actions first (fastest)
      await _loadQuickActions();

      // * Load data in parallel for better performance
      await Future.wait([
        _loadWeatherData(),
        _loadMarketData(farmerId),
        _loadNotifications(farmerId),
      ]);

      state = state.copyWith(isLoading: false, lastSync: DateTime.now());
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load dashboard: ${error.toString()}',
      );
    }
  }

  /// * Refresh all dashboard data
  Future<void> refreshDashboard(String farmerId) async {
    try {
      // * Show loading indicators for each section
      state = state.copyWith(
        isWeatherLoading: true,
        isMarketLoading: true,
        isNotificationsLoading: true,
      );

      // * Clear previous errors
      state = state.copyWith(
        weatherError: null,
        marketError: null,
        notificationError: null,
      );

      // * Load data in parallel
      await Future.wait([
        _loadWeatherData(),
        _loadMarketData(farmerId),
        _loadNotifications(farmerId),
      ]);

      state = state.copyWith(lastSync: DateTime.now());
    } catch (error) {
      // ! ERROR: General dashboard refresh failed
      state = state.copyWith(
        errorMessage: 'Failed to refresh dashboard: ${error.toString()}',
      );
    }
  }

  // ============================================================================
  // * INDIVIDUAL DATA LOADING METHODS
  // ============================================================================

  /// * Load weather data for farmer's location
  Future<void> _loadWeatherData() async {
    try {
      state = state.copyWith(isWeatherLoading: true, weatherError: null);

      final weatherData = await _weatherService.getCurrentWeather();

      state = state.copyWith(weather: weatherData, isWeatherLoading: false);
    } catch (error) {
      // ! ERROR: Weather data loading failed
      state = state.copyWith(
        isWeatherLoading: false,
        weatherError: 'Failed to load weather: ${error.toString()}',
      );
    }
  }

  /// * Load market prices for farmer's crops
  Future<void> _loadMarketData(String farmerId) async {
    try {
      state = state.copyWith(isMarketLoading: true, marketError: null);

      final marketData = await _marketService.getMarketPrices(farmerId);

      state = state.copyWith(marketData: marketData, isMarketLoading: false);
    } catch (error) {
      // ! ERROR: Market data loading failed
      state = state.copyWith(
        isMarketLoading: false,
        marketError: 'Failed to load market prices: ${error.toString()}',
      );
    }
  }

  /// * Load notifications for farmer
  Future<void> _loadNotifications(String farmerId) async {
    try {
      state = state.copyWith(
        isNotificationsLoading: true,
        notificationError: null,
      );

      final notifications = await _notificationService.getNotifications(
        farmerId,
      );

      state = state.copyWith(
        notifications: notifications,
        isNotificationsLoading: false,
      );
    } catch (error) {
      // ! ERROR: Notifications loading failed
      state = state.copyWith(
        isNotificationsLoading: false,
        notificationError: 'Failed to load notifications: ${error.toString()}',
      );
    }
  }

  /// * Load quick actions configuration
  Future<void> _loadQuickActions() async {
    try {
      final quickActions = await _repository.getQuickActions();
      state = state.copyWith(quickActions: quickActions);
    } catch (error) {
      // NOTE: Quick actions failure is not critical, use defaults
      state = state.copyWith(quickActions: _getDefaultQuickActions());
    }
  }

  // ============================================================================
  // * ACTION METHODS
  // ============================================================================

  /// * Mark notification as read
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);

      // * Update local state
      final updatedNotifications = state.notifications?.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (error) {
      // NOTE: Non-critical error, continue silently
    }
  }

  /// * Toggle offline mode
  void setOfflineMode(bool isOffline) {
    state = state.copyWith(isOffline: isOffline);
  }

  /// * Clear specific error
  void clearError(String errorType) {
    switch (errorType) {
      case 'weather':
        state = state.copyWith(weatherError: null);
        break;
      case 'market':
        state = state.copyWith(marketError: null);
        break;
      case 'notification':
        state = state.copyWith(notificationError: null);
        break;
      default:
        state = state.copyWith(errorMessage: null);
    }
  }

  // ============================================================================
  // * HELPER METHODS
  // ============================================================================

  /// * Get default quick actions when API fails
  List<QuickAction> _getDefaultQuickActions() {
    return [
      const QuickAction(
        id: 'sell_produce',
        title: 'Sell Produce',
        description: 'Direct marketplace',
        icon: Icons.store,
        route: '/marketplace',
      ),
      const QuickAction(
        id: 'buy_inputs',
        title: 'Buy Inputs',
        description: 'Seeds & fertilizers',
        icon: Icons.shopping_cart,
        route: '/inputs',
      ),
      const QuickAction(
        id: 'book_logistics',
        title: 'Book Logistics',
        description: 'Transportation',
        icon: Icons.local_shipping,
        route: '/logistics',
      ),
      const QuickAction(
        id: 'soil_test',
        title: 'Soil Test',
        description: 'Get soil tested',
        icon: Icons.science,
        route: '/soil-test',
      ),
      const QuickAction(
        id: 'veterinarian',
        title: 'Call Veterinarian',
        description: 'Animal healthcare',
        icon: Icons.pets,
        route: '/veterinarian',
      ),
      const QuickAction(
        id: 'knowledge_hub',
        title: 'Knowledge Hub',
        description: 'Farming tips',
        icon: Icons.menu_book,
        route: '/knowledge',
      ),
    ];
  }
}

// ============================================================================
// * RIVERPOD PROVIDERS
// ============================================================================

// * Dashboard controller provider
final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, DashboardState>((ref) {
      // TODO: Implement actual service dependencies
      return DashboardController(
        DashboardRepository(),
        WeatherService(),
        MarketService(),
        NotificationService(),
      );
    });

// * Quick access to dashboard state
final dashboardStateProvider = Provider<DashboardState>((ref) {
  return ref.watch(dashboardControllerProvider);
});

// * Weather data provider (for isolated weather widget)
final weatherDataProvider = Provider<WeatherResponse?>((ref) {
  return ref.watch(dashboardControllerProvider).weather;
});

// * Market data provider (for isolated market widget)
final marketDataProvider = Provider<MarketPriceResponse?>((ref) {
  return ref.watch(dashboardControllerProvider).marketData;
});

// * Notifications provider (for isolated notification widget)
final notificationsProvider = Provider<List<NotificationData>?>((ref) {
  return ref.watch(dashboardControllerProvider).notifications;
});
