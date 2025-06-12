// ===================================================================
// * DASHBOARD CONTROLLER TESTS
// * Purpose: Unit tests for dashboard state management
// * Features: State transitions, error handling, data loading
// * Security Level: TESTING - No sensitive data
// ===================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../lib/features/dashboard/controllers/dashboard_controller.dart';
import '../../../lib/features/dashboard/models/dashboard_state.dart';
import '../../../lib/features/dashboard/models/weather_data.dart';
import '../../../lib/features/dashboard/models/market_price.dart';
import '../../../lib/features/dashboard/models/notification_data.dart';
import '../../../lib/features/dashboard/services/weather_service.dart';
import '../../../lib/features/dashboard/services/market_service.dart';
import '../../../lib/features/dashboard/services/notification_service.dart';
import '../../../lib/features/dashboard/repositories/dashboard_repository.dart';

// * MOCK SERVICES FOR TESTING
class MockWeatherService extends WeatherService {
  bool shouldFail = false;

  @override
  Future<WeatherResponse> getCurrentWeather() async {
    if (shouldFail) {
      throw Exception('Weather service failed');
    }
    await Future.delayed(const Duration(milliseconds: 100));
    return WeatherResponse(
      current: WeatherData(
        temperature: 25.0,
        humidity: 60.0,
        windSpeed: 10.0,
        uvIndex: 5,
        condition: 'Sunny',
        description: 'Clear sunny day',
        icon: '☀️',
        timestamp: DateTime.now(),
      ),
      forecast: [],
      location: 'Test Location',
      lastUpdated: DateTime.now(),
    );
  }
}

class MockMarketService extends MarketService {
  bool shouldFail = false;

  @override
  Future<MarketPriceResponse> getMarketPrices(String farmerId) async {
    if (shouldFail) {
      throw Exception('Market service failed');
    }
    await Future.delayed(const Duration(milliseconds: 100));
    return MarketPriceResponse(
      prices: [
        MarketPrice(
          cropName: 'Test Crop',
          cropId: 'test_001',
          currentPrice: 100.0,
          previousPrice: 95.0,
          trend: PriceTrend.up,
          unit: 'kg',
          mandiName: 'Test Mandi',
          district: 'Test District',
          lastUpdated: DateTime.now(),
        ),
      ],
      lastSync: DateTime.now(),
      location: 'Test Location',
    );
  }
}

class MockNotificationService extends NotificationService {
  bool shouldFail = false;

  @override
  Future<List<NotificationData>> getNotifications(String farmerId) async {
    if (shouldFail) {
      throw Exception('Notification service failed');
    }
    await Future.delayed(const Duration(milliseconds: 100));
    return [
      NotificationData(
        id: 'test_001',
        title: 'Test Notification',
        message: 'This is a test notification',
        type: NotificationType.system,
        priority: NotificationPriority.medium,
        timestamp: DateTime.now(),
      ),
    ];
  }
}

class MockDashboardRepository extends DashboardRepository {
  @override
  Future<List<QuickAction>> getQuickActions() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return [
      QuickAction(
        id: 'test_action',
        title: 'Test Action',
        description: 'Test Description',
        icon: Icons.test_tube,
        route: '/test',
      ),
    ];
  }
}

void main() {
  group('DashboardController Tests', () {
    late ProviderContainer container;
    late MockWeatherService mockWeatherService;
    late MockMarketService mockMarketService;
    late MockNotificationService mockNotificationService;
    late MockDashboardRepository mockRepository;

    setUp(() {
      mockWeatherService = MockWeatherService();
      mockMarketService = MockMarketService();
      mockNotificationService = MockNotificationService();
      mockRepository = MockDashboardRepository();

      container = ProviderContainer(
        overrides: [
          dashboardControllerProvider.overrideWith(
            (ref) => DashboardController(
              mockRepository,
              mockWeatherService,
              mockMarketService,
              mockNotificationService,
            ),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default state', () {
      final state = container.read(dashboardControllerProvider);

      expect(state.isLoading, false);
      expect(state.isWeatherLoading, false);
      expect(state.isMarketLoading, false);
      expect(state.isNotificationsLoading, false);
      expect(state.isOffline, false);
      expect(state.weather, null);
      expect(state.marketData, null);
      expect(state.notifications, null);
      expect(state.quickActions, null);
      expect(state.errorMessage, null);
    });

    test('should load dashboard data successfully', () async {
      final controller = container.read(dashboardControllerProvider.notifier);

      // * Act
      await controller.initializeDashboard('test_farmer_123');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      expect(state.isLoading, false);
      expect(state.hasWeatherData, true);
      expect(state.hasMarketData, true);
      expect(state.hasNotifications, true);
      expect(state.quickActions, isNotNull);
      expect(state.lastSync, isNotNull);
      expect(state.errorMessage, null);
    });

    test('should handle weather service failure gracefully', () async {
      // * Arrange
      mockWeatherService.shouldFail = true;
      final controller = container.read(dashboardControllerProvider.notifier);

      // * Act
      await controller.initializeDashboard('test_farmer_123');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      expect(state.isLoading, false);
      expect(state.isWeatherLoading, false);
      expect(state.hasWeatherError, true);
      expect(state.weatherError, contains('Weather service failed'));
      // * Other services should still work
      expect(state.hasMarketData, true);
      expect(state.hasNotifications, true);
    });

    test('should handle market service failure gracefully', () async {
      // * Arrange
      mockMarketService.shouldFail = true;
      final controller = container.read(dashboardControllerProvider.notifier);

      // * Act
      await controller.initializeDashboard('test_farmer_123');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      expect(state.isLoading, false);
      expect(state.isMarketLoading, false);
      expect(state.hasMarketError, true);
      expect(state.marketError, contains('Market service failed'));
      // * Other services should still work
      expect(state.hasWeatherData, true);
      expect(state.hasNotifications, true);
    });

    test('should handle notification service failure gracefully', () async {
      // * Arrange
      mockNotificationService.shouldFail = true;
      final controller = container.read(dashboardControllerProvider.notifier);

      // * Act
      await controller.initializeDashboard('test_farmer_123');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      expect(state.isLoading, false);
      expect(state.isNotificationsLoading, false);
      expect(state.hasNotificationError, true);
      expect(state.notificationError, contains('Notification service failed'));
      // * Other services should still work
      expect(state.hasWeatherData, true);
      expect(state.hasMarketData, true);
    });

    test('should refresh dashboard data', () async {
      // * Arrange
      final controller = container.read(dashboardControllerProvider.notifier);
      await controller.initializeDashboard('test_farmer_123');
      final initialLastSync = container
          .read(dashboardControllerProvider)
          .lastSync;

      // * Wait a bit to ensure different timestamp
      await Future.delayed(const Duration(milliseconds: 10));

      // * Act
      await controller.refreshDashboard('test_farmer_123');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      expect(state.lastSync, isNot(equals(initialLastSync)));
      expect(state.hasWeatherData, true);
      expect(state.hasMarketData, true);
      expect(state.hasNotifications, true);
    });

    test('should mark notification as read', () async {
      // * Arrange
      final controller = container.read(dashboardControllerProvider.notifier);
      await controller.initializeDashboard('test_farmer_123');

      // * Act
      await controller.markNotificationAsRead('test_001');

      // * Assert
      final state = container.read(dashboardControllerProvider);
      final notification = state.notifications?.firstWhere(
        (n) => n.id == 'test_001',
        orElse: () => throw Exception('Notification not found'),
      );
      expect(notification?.isRead, true);
    });

    test('should toggle offline mode', () {
      // * Arrange
      final controller = container.read(dashboardControllerProvider.notifier);

      // * Act
      controller.setOfflineMode(true);

      // * Assert
      expect(container.read(dashboardControllerProvider).isOffline, true);

      // * Act
      controller.setOfflineMode(false);

      // * Assert
      expect(container.read(dashboardControllerProvider).isOffline, false);
    });

    test('should clear specific errors', () async {
      // * Arrange
      mockWeatherService.shouldFail = true;
      mockMarketService.shouldFail = true;
      final controller = container.read(dashboardControllerProvider.notifier);
      await controller.initializeDashboard('test_farmer_123');

      // * Verify errors exist
      expect(container.read(dashboardControllerProvider).hasWeatherError, true);
      expect(container.read(dashboardControllerProvider).hasMarketError, true);

      // * Act - Clear weather error
      controller.clearError('weather');

      // * Assert
      expect(
        container.read(dashboardControllerProvider).hasWeatherError,
        false,
      );
      expect(container.read(dashboardControllerProvider).hasMarketError, true);

      // * Act - Clear market error
      controller.clearError('market');

      // * Assert
      expect(container.read(dashboardControllerProvider).hasMarketError, false);
    });

    group('Dashboard State Helper Methods', () {
      test('isInitialLoading should return true when loading and no data', () {
        final state = DashboardState(isLoading: true);
        expect(state.isInitialLoading, true);
      });

      test('isInitialLoading should return false when has data', () {
        final state = DashboardState(
          isLoading: true,
          weather: WeatherResponse(
            current: WeatherData(
              temperature: 25.0,
              humidity: 60.0,
              windSpeed: 10.0,
              uvIndex: 5,
              condition: 'Sunny',
              description: 'Clear',
              icon: '☀️',
              timestamp: DateTime.now(),
            ),
            forecast: [],
          ),
        );
        expect(state.isInitialLoading, false);
      });

      test('hasError should return true when errorMessage is set', () {
        final state = DashboardState(errorMessage: 'Test error');
        expect(state.hasError, true);
      });

      test('hasNotifications should return true when notifications exist', () {
        final state = DashboardState(
          notifications: [
            NotificationData(
              id: 'test',
              title: 'Test',
              message: 'Test message',
              type: NotificationType.system,
              priority: NotificationPriority.medium,
              timestamp: DateTime.now(),
            ),
          ],
        );
        expect(state.hasNotifications, true);
      });
    });
  });

  group('Market Price Model Tests', () {
    test('should calculate percentage change correctly', () {
      final price = MarketPrice(
        cropName: 'Wheat',
        cropId: 'wheat_001',
        currentPrice: 110.0,
        previousPrice: 100.0,
        trend: PriceTrend.up,
        unit: 'kg',
        mandiName: 'Test Mandi',
        district: 'Test District',
        lastUpdated: DateTime.now(),
      );

      expect(price.percentageChange, 10.0);
    });

    test('should return correct formatted change', () {
      final priceUp = MarketPrice(
        cropName: 'Wheat',
        cropId: 'wheat_001',
        currentPrice: 110.0,
        previousPrice: 100.0,
        trend: PriceTrend.up,
        unit: 'kg',
        mandiName: 'Test Mandi',
        district: 'Test District',
        lastUpdated: DateTime.now(),
      );

      expect(priceUp.formattedChange, '↗ 10.0%');

      final priceDown = MarketPrice(
        cropName: 'Rice',
        cropId: 'rice_001',
        currentPrice: 90.0,
        previousPrice: 100.0,
        trend: PriceTrend.down,
        unit: 'kg',
        mandiName: 'Test Mandi',
        district: 'Test District',
        lastUpdated: DateTime.now(),
      );

      expect(priceDown.formattedChange, '↘ 10.0%');
    });

    test('should return correct trend color', () {
      final priceUp = MarketPrice(
        cropName: 'Wheat',
        cropId: 'wheat_001',
        currentPrice: 110.0,
        previousPrice: 100.0,
        trend: PriceTrend.up,
        unit: 'kg',
        mandiName: 'Test Mandi',
        district: 'Test District',
        lastUpdated: DateTime.now(),
      );

      expect(priceUp.trendColor, 'green');

      final priceDown = priceUp.copyWith(trend: PriceTrend.down);
      expect(priceDown.trendColor, 'red');

      final priceStable = priceUp.copyWith(trend: PriceTrend.stable);
      expect(priceStable.trendColor, 'gray');
    });
  });
}

// * EXTENSION FOR TESTING
extension MarketPriceTesting on MarketPrice {
  MarketPrice copyWith({
    String? cropName,
    String? cropId,
    double? currentPrice,
    double? previousPrice,
    PriceTrend? trend,
    String? unit,
    String? mandiName,
    String? district,
    DateTime? lastUpdated,
  }) {
    return MarketPrice(
      cropName: cropName ?? this.cropName,
      cropId: cropId ?? this.cropId,
      currentPrice: currentPrice ?? this.currentPrice,
      previousPrice: previousPrice ?? this.previousPrice,
      trend: trend ?? this.trend,
      unit: unit ?? this.unit,
      mandiName: mandiName ?? this.mandiName,
      district: district ?? this.district,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
