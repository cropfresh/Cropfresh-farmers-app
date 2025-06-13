// ===================================================================
// * MAIN DASHBOARD SCREEN V2
// * Purpose: Comprehensive farmer dashboard with weather, market, notifications
// * Features: Weather widget, market prices, quick actions, notifications
// * State Management: Riverpod
// * Security Level: MEDIUM - User-specific dashboard data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/colors.dart';
import '../login/models/user_profile.dart';
import 'controllers/dashboard_controller.dart';
import 'models/weather_data.dart';
import 'models/market_price.dart';
import 'models/notification_data.dart';
import 'models/quick_action.dart';

// * MAIN DASHBOARD SCREEN
// * Complete dashboard implementation with all features
class DashboardScreenV2 extends ConsumerStatefulWidget {
  final UserProfile userProfile;
  final Function(int)? onNavigateToTab;

  const DashboardScreenV2({
    super.key,
    required this.userProfile,
    this.onNavigateToTab,
  });

  @override
  ConsumerState<DashboardScreenV2> createState() => _DashboardScreenV2State();
}

class _DashboardScreenV2State extends ConsumerState<DashboardScreenV2> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // * Initialize dashboard data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dashboardControllerProvider.notifier)
          .initializeDashboard(widget.userProfile.farmerId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // * App bar with user greeting and sync status
            _buildSliverAppBar(isSmallScreen, dashboardState),

            // * Dashboard content
            SliverPadding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // * Weather widget
                  _buildWeatherCard(dashboardState, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // * Market prices widget
                  _buildMarketPricesCard(dashboardState, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // * Notifications panel
                  _buildNotificationsCard(dashboardState, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // * Quick actions grid
                  _buildQuickActionsSection(dashboardState, isSmallScreen),

                  SizedBox(height: isSmallScreen ? 16 : 20),

                  // * Active orders card (placeholder)
                  _buildActiveOrdersCard(isSmallScreen),

                  // * Bottom padding for safe scrolling with navigation bar
                  const SizedBox(height: 120),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * APP BAR WIDGETS
  // ============================================================================

  Widget _buildSliverAppBar(bool isSmallScreen, dashboardState) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 160 : 200,
      floating: false,
      pinned: true,
      backgroundColor: CropFreshColors.green30Primary,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CropFreshColors.green30Primary,
                CropFreshColors.green30Primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good ${_getGreeting()}! 👋',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                color: CropFreshColors.onGreen30.withValues(
                                  alpha: 0.9,
                                ),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.userProfile.displayName,
                              style: TextStyle(
                                fontSize: isSmallScreen ? 24 : 28,
                                color: CropFreshColors.onGreen30,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // * Sync status indicator
                      _buildSyncStatusIndicator(dashboardState, isSmallScreen),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // * Last sync time
                  if (dashboardState.lastSync != null)
                    Text(
                      'Last updated: ${_formatLastSync(dashboardState.lastSync!)}',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: CropFreshColors.onGreen30.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        // * Notification bell with badge
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: CropFreshColors.onGreen30,
              ),
              onPressed: () => _showNotificationPanel(),
            ),
            if (dashboardState.hasNotifications)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${dashboardState.notifications?.where((n) => !n.isRead).length ?? 0}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.logout, color: CropFreshColors.onGreen30),
          onPressed: _handleLogout,
        ),
      ],
    );
  }

  Widget _buildSyncStatusIndicator(dashboardState, bool isSmallScreen) {
    if (dashboardState.isInitialLoading) {
      return const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      );
    }

    if (dashboardState.isOffline) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 16, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              'Offline',
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 10 : 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_done, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Synced',
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // * WEATHER WIDGET
  // ============================================================================

  Widget _buildWeatherCard(dashboardState, bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Weather Today',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                const Spacer(),
                if (dashboardState.isWeatherLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (dashboardState.hasWeatherError)
              _buildErrorState(
                dashboardState.weatherError!,
                () => _retryWeatherLoad(),
                isSmallScreen,
              )
            else if (dashboardState.hasWeatherData)
              _buildWeatherContent(dashboardState.weather!, isSmallScreen)
            else
              _buildLoadingWeatherContent(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherContent(WeatherResponse weather, bool isSmallScreen) {
    return Column(
      children: [
        // * Current weather display
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${weather.current.temperature.toInt()}°C',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 36 : 42,
                      fontWeight: FontWeight.w700,
                      color: CropFreshColors.onBackground60,
                    ),
                  ),
                  Text(
                    weather.current.condition,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      color: CropFreshColors.onBackground60Secondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (weather.current.hasAlert)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.warning,
                            size: 16,
                            color: Colors.red,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Weather Alert',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                weather.current.icon,
                style: TextStyle(fontSize: isSmallScreen ? 48 : 56),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // * Weather details grid
        Row(
          children: [
            Expanded(
              child: _buildWeatherDetail(
                'Humidity',
                '${weather.current.humidity.toInt()}%',
                Icons.water_drop_outlined,
                isSmallScreen,
              ),
            ),
            Expanded(
              child: _buildWeatherDetail(
                'Wind',
                '${weather.current.windSpeed.toInt()} km/h',
                Icons.air,
                isSmallScreen,
              ),
            ),
            Expanded(
              child: _buildWeatherDetail(
                'UV Index',
                '${weather.current.uvIndex}',
                Icons.wb_sunny,
                isSmallScreen,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // * 5-day forecast
        SizedBox(
          height: isSmallScreen
              ? 85
              : 105, // ! FIX: Increased height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weather.forecast.length,
            physics: const BouncingScrollPhysics(), // * Better scroll physics
            itemBuilder: (context, index) {
              final forecast = weather.forecast[index];
              return _buildForecastItem(forecast, isSmallScreen);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Column(
      mainAxisSize:
          MainAxisSize.min, // ! FIX: Use minimum size to prevent overflow
      children: [
        Icon(
          icon,
          size: isSmallScreen ? 16 : 20,
          color: CropFreshColors.onBackground60Secondary,
        ),
        SizedBox(height: isSmallScreen ? 2 : 4), // ! FIX: Responsive spacing
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onBackground60,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: CropFreshColors.onBackground60Secondary,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastItem(WeatherForecast forecast, bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 60 : 70,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize:
            MainAxisSize.min, // ! FIX: Prevent overflow by using minimum size
        children: [
          Flexible(
            child: Text(
              DateFormat('E').format(forecast.date),
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                color: CropFreshColors.onBackground60Secondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2), // * Reduced spacing to prevent overflow
          Flexible(
            child: Text(
              forecast.icon,
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 22,
              ), // * Slightly smaller icons
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(height: 2), // * Reduced spacing
          Flexible(
            child: Text(
              '${forecast.maxTemp.toInt()}°',
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 13, // * Slightly smaller text
                fontWeight: FontWeight.w600,
                color: CropFreshColors.onBackground60,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              '${forecast.minTemp.toInt()}°',
              style: TextStyle(
                fontSize: isSmallScreen ? 9 : 11, // * Slightly smaller text
                color: CropFreshColors.onBackground60Secondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWeatherContent(bool isSmallScreen) {
    return SizedBox(
      height: isSmallScreen ? 120 : 150,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  // ============================================================================
  // * MARKET PRICES WIDGET
  // ============================================================================

  Widget _buildMarketPricesCard(dashboardState, bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Market Prices',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                const Spacer(),
                if (dashboardState.isMarketLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (dashboardState.hasMarketError)
              _buildErrorState(
                dashboardState.marketError!,
                () => _retryMarketLoad(),
                isSmallScreen,
              )
            else if (dashboardState.hasMarketData)
              _buildMarketContent(dashboardState.marketData!, isSmallScreen)
            else
              _buildLoadingMarketContent(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketContent(
    MarketPriceResponse marketData,
    bool isSmallScreen,
  ) {
    return Column(
      children: [
        ...marketData.prices
            .take(4)
            .map((price) => _buildPriceItem(price, isSmallScreen)),

        if (marketData.prices.length > 4)
          TextButton(
            onPressed: () => _showAllPrices(marketData.prices),
            child: Text(
              'View All Prices (${marketData.prices.length})',
              style: TextStyle(
                color: CropFreshColors.green30Primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceItem(MarketPrice price, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CropFreshColors.onBackground60.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.cropName,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                Text(
                  price.mandiName,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₹${price.currentPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                Text(
                  'per ${price.unit}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getTrendColor(price.trend).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              price.formattedChange,
              style: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
                fontWeight: FontWeight.w500,
                color: _getTrendColor(price.trend),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMarketContent(bool isSmallScreen) {
    return Column(
      children: List.generate(
        3,
        (index) => Container(
          height: isSmallScreen ? 40 : 50,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: CropFreshColors.onBackground60.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // * NOTIFICATIONS WIDGET
  // ============================================================================

  Widget _buildNotificationsCard(dashboardState, bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                const Spacer(),
                if (dashboardState.isNotificationsLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (dashboardState.hasNotificationError)
              _buildErrorState(
                dashboardState.notificationError!,
                () => _retryNotificationsLoad(),
                isSmallScreen,
              )
            else if (dashboardState.hasNotifications)
              _buildNotificationsContent(
                dashboardState.notifications!,
                isSmallScreen,
              )
            else
              _buildEmptyNotificationsContent(isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsContent(
    List<NotificationData> notifications,
    bool isSmallScreen,
  ) {
    final recentNotifications = notifications.take(3).toList();

    return Column(
      children: [
        ...recentNotifications.map(
          (notification) => _buildNotificationItem(notification, isSmallScreen),
        ),

        if (notifications.length > 3)
          TextButton(
            onPressed: () => _showAllNotifications(notifications),
            child: Text(
              'View All Notifications (${notifications.length})',
              style: TextStyle(
                color: CropFreshColors.green30Primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildNotificationItem(
    NotificationData notification,
    bool isSmallScreen,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CropFreshColors.onBackground60.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6, right: 12),
            decoration: BoxDecoration(
              color: notification.isRead
                  ? CropFreshColors.onBackground60.withValues(alpha: 0.3)
                  : _getPriorityColor(notification.priority),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: notification.isRead
                        ? FontWeight.w500
                        : FontWeight.w600,
                    color: notification.isRead
                        ? CropFreshColors.onBackground60Secondary
                        : CropFreshColors.onBackground60,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatNotificationTime(notification.timestamp),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color: CropFreshColors.onBackground60Secondary,
                  ),
                ),
              ],
            ),
          ),
          if (!notification.isRead)
            IconButton(
              icon: const Icon(Icons.mark_as_unread, size: 16),
              onPressed: () => _markNotificationAsRead(notification.id),
              color: CropFreshColors.onBackground60Secondary,
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyNotificationsContent(bool isSmallScreen) {
    return Container(
      height: isSmallScreen ? 80 : 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: isSmallScreen ? 32 : 40,
              color: CropFreshColors.onBackground60Secondary,
            ),
            const SizedBox(height: 8),
            Text(
              'No new notifications',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: CropFreshColors.onBackground60Secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * QUICK ACTIONS WIDGET
  // ============================================================================

  Widget _buildQuickActionsSection(dashboardState, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: CropFreshColors.onBackground60,
          ),
        ),
        const SizedBox(height: 16),
        if (dashboardState.quickActions != null)
          _buildQuickActionsGrid(dashboardState.quickActions!, isSmallScreen)
        else
          _buildLoadingQuickActions(isSmallScreen),
      ],
    );
  }

  Widget _buildQuickActionsGrid(List<QuickAction> actions, bool isSmallScreen) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildQuickActionCard(action, isSmallScreen);
      },
    );
  }

  Widget _buildQuickActionCard(QuickAction action, bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: action.isEnabled ? () => _handleQuickAction(action) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                size: isSmallScreen ? 28 : 32,
                color: action.isEnabled
                    ? CropFreshColors.green30Primary
                    : CropFreshColors.onBackground60Secondary,
              ),
              const SizedBox(height: 8),
              Text(
                action.title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: action.isEnabled
                      ? CropFreshColors.onBackground60
                      : CropFreshColors.onBackground60Secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                action.description,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: CropFreshColors.onBackground60Secondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (action.badge != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    action.badge!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingQuickActions(bool isSmallScreen) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: CropFreshColors.onBackground60.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  // ============================================================================
  // * ACTIVE ORDERS WIDGET (PLACEHOLDER)
  // ============================================================================

  Widget _buildActiveOrdersCard(bool isSmallScreen) {
    return Card(
      color: CropFreshColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: CropFreshColors.green30Primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: isSmallScreen ? 80 : 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: isSmallScreen ? 32 : 40,
                      color: CropFreshColors.onBackground60Secondary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No active orders',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        color: CropFreshColors.onBackground60Secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * ERROR STATE WIDGET
  // ============================================================================

  Widget _buildErrorState(
    String error,
    VoidCallback onRetry,
    bool isSmallScreen,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.red.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red.shade700,
              elevation: 0,
            ),
            child: Text(
              'Retry',
              style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // * HELPER METHODS
  // ============================================================================

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'morning';
    if (hour < 17) return 'afternoon';
    return 'evening';
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, HH:mm').format(lastSync);
    }
  }

  String _formatNotificationTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }

  Color _getTrendColor(PriceTrend trend) {
    switch (trend) {
      case PriceTrend.up:
        return Colors.green;
      case PriceTrend.down:
        return Colors.red;
      case PriceTrend.stable:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Colors.grey;
      case NotificationPriority.medium:
        return Colors.blue;
      case NotificationPriority.high:
        return Colors.orange;
      case NotificationPriority.urgent:
        return Colors.red;
    }
  }

  // ============================================================================
  // * ACTION HANDLERS
  // ============================================================================

  Future<void> _handleRefresh() async {
    await ref
        .read(dashboardControllerProvider.notifier)
        .refreshDashboard(widget.userProfile.farmerId);
  }

  void _retryWeatherLoad() {
    ref.read(dashboardControllerProvider.notifier).clearError('weather');
    // * Re-trigger weather load
    _handleRefresh();
  }

  void _retryMarketLoad() {
    ref.read(dashboardControllerProvider.notifier).clearError('market');
    // * Re-trigger market load
    _handleRefresh();
  }

  void _retryNotificationsLoad() {
    ref.read(dashboardControllerProvider.notifier).clearError('notification');
    // * Re-trigger notifications load
    _handleRefresh();
  }

  void _markNotificationAsRead(String notificationId) {
    ref
        .read(dashboardControllerProvider.notifier)
        .markNotificationAsRead(notificationId);
  }

  void _handleQuickAction(QuickAction action) {
    // * Handle specific quick actions with navigation
    switch (action.title) {
      case 'My Orders':
      case 'Orders':
        // * Navigate to My Orders tab (index 2 in adjusted navigation)
        _navigateToTab(2);
        break;
      case 'Profile':
      case 'Account':
        // * Navigate to Profile tab (index 3 in adjusted navigation)
        _navigateToTab(3);
        break;
      default:
        // * Show coming soon message for other actions
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${action.title} coming soon!'),
            backgroundColor: CropFreshColors.green30Primary,
          ),
        );
    }
  }

  /// * Navigate to specific tab in parent navigation
  void _navigateToTab(int tabIndex) {
    if (widget.onNavigateToTab != null) {
      // * Use callback to communicate with parent navigation
      widget.onNavigateToTab!(tabIndex);
    } else {
      // * Fallback: show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please use bottom navigation to access this feature'),
          backgroundColor: CropFreshColors.green30Primary,
        ),
      );
    }
  }

  void _showNotificationPanel() {
    // TODO: Implement notification panel or navigate to notifications screen
  }

  void _showAllPrices(List<MarketPrice> prices) {
    // TODO: Implement full market prices screen
  }

  void _showAllNotifications(List<NotificationData> notifications) {
    // TODO: Implement full notifications screen
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.surface,
        title: Text(
          'Logout',
          style: TextStyle(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: CropFreshColors.onBackground60Secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: CropFreshColors.onBackground60Secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: Text(
              'Logout',
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
