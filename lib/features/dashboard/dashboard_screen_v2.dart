// ===================================================================
// * MAIN DASHBOARD SCREEN V2 - MATERIAL 3 DESIGN
// * Purpose: Comprehensive farmer dashboard with Material 3 components
// * Features: Dynamic colors, modern cards, FAB, Navigation Rail
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

// * MAIN DASHBOARD SCREEN WITH MATERIAL 3 DESIGN
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

class _DashboardScreenV2State extends ConsumerState<DashboardScreenV2>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();

    // * Initialize animations for smooth Material 3 experience
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // * Listen to scroll for dynamic app bar changes
    _scrollController.addListener(() {
      if (_scrollController.offset > 80 && !_isScrolled) {
        setState(() => _isScrolled = true);
      } else if (_scrollController.offset <= 80 && _isScrolled) {
        setState(() => _isScrolled = false);
      }
    });

    // * Initialize dashboard data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(dashboardControllerProvider.notifier)
          .initializeDashboard(widget.userProfile.farmerId);
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControllerProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(),
        color: colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // * Material 3 Large App Bar with dynamic title
            _buildMaterial3AppBar(dashboardState, colorScheme),

            // * Dashboard content with Material 3 spacing
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 8),

                  // * Hero stats section with Material 3 cards
                  _buildHeroStatsSection(dashboardState, colorScheme),

                  const SizedBox(height: 24),

                  // * Weather card with elevated Material 3 design
                  _buildMaterial3WeatherCard(dashboardState, colorScheme),

                  const SizedBox(height: 20),

                  // * Market prices with segmented display
                  _buildMaterial3MarketCard(dashboardState, colorScheme),

                  const SizedBox(height: 20),

                  // * Notifications with modern list tiles
                  _buildMaterial3NotificationsCard(dashboardState, colorScheme),

                  const SizedBox(height: 20),

                  // * Quick actions with Material 3 buttons
                  _buildMaterial3QuickActions(dashboardState, colorScheme),

                  const SizedBox(height: 20),

                  // * Recent activity timeline
                  _buildRecentActivityCard(colorScheme),

                  const SizedBox(height: 100), // * Safe area for FAB
                ]),
              ),
            ),
          ],
        ),
      ),

      // * Material 3 Floating Action Button
      floatingActionButton: _buildMaterial3FAB(colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ============================================================================
  // * MATERIAL 3 APP BAR
  // ============================================================================

  Widget _buildMaterial3AppBar(dashboardState, ColorScheme colorScheme) {
    return SliverAppBar.large(
      pinned: true,
      floating: false,
      snap: false,
      expandedHeight: 180,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      shadowColor: Colors.transparent,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: colorScheme.primaryContainer,
          child: Text(
            widget.userProfile.displayName.isNotEmpty
                ? widget.userProfile.displayName[0].toUpperCase()
                : 'F',
            style: TextStyle(
              color: colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _isScrolled
            ? Text(
                'Hi, ${widget.userProfile.displayName.split(' ').first}!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              )
            : null,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [colorScheme.surface, colorScheme.surfaceContainerLow],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(72, 40, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Good ${_getGreeting()}! 👋',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.userProfile.displayName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (dashboardState.lastSync != null)
                    Row(
                      children: [
                        Icon(
                          Icons.sync,
                          size: 16,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Updated ${_formatLastSync(dashboardState.lastSync!)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                              ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        // * Material 3 Notification Badge
        IconButton.filledTonal(
          onPressed: () => _showNotificationPanel(),
          icon: Badge.count(
            count:
                dashboardState.notifications?.where((n) => !n.isRead).length ??
                0,
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
        const SizedBox(width: 8),
        // * Settings menu
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: ListTile(
                leading: Icon(Icons.person_outline),
                title: Text('Profile'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: ListTile(
                leading: Icon(Icons.settings_outlined),
                title: Text('Settings'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ============================================================================
  // * MATERIAL 3 HERO STATS SECTION
  // ============================================================================

  Widget _buildHeroStatsSection(dashboardState, ColorScheme colorScheme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Orders',
              '24',
              Icons.shopping_bag_outlined,
              colorScheme.primaryContainer,
              colorScheme.onPrimaryContainer,
              '+12%',
              true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Revenue',
              '₹45.2K',
              Icons.trending_up,
              colorScheme.secondaryContainer,
              colorScheme.onSecondaryContainer,
              '+8.5%',
              true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Active Crops',
              '7',
              Icons.agriculture,
              colorScheme.tertiaryContainer,
              colorScheme.onTertiaryContainer,
              '+2',
              true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    String change,
    bool isPositive,
  ) {
    return Card.filled(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: textColor, size: 18),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isPositive
                          ? Colors.green.withValues(alpha: 0.2)
                          : Colors.red.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      change,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: isPositive
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  color: textColor.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * MATERIAL 3 WEATHER CARD
  // ============================================================================

  Widget _buildMaterial3WeatherCard(dashboardState, ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.wb_sunny_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Weather Today',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (dashboardState.isWeatherLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (dashboardState.hasWeatherError)
              _buildMaterial3ErrorState(
                dashboardState.weatherError!,
                () => _retryWeatherLoad(),
                colorScheme,
              )
            else if (dashboardState.hasWeatherData)
              _buildMaterial3WeatherContent(
                dashboardState.weather!,
                colorScheme,
              )
            else
              _buildMaterial3LoadingContent(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial3WeatherContent(
    WeatherResponse weather,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        // * Current weather with Material 3 styling
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.current.temperature.toInt()}°C',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                    ),
                    Text(
                      weather.current.condition,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                    if (weather.current.hasAlert)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.warning_amber,
                              size: 16,
                              color: colorScheme.onErrorContainer,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Weather Alert',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorScheme.onErrorContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Text(weather.current.icon, style: const TextStyle(fontSize: 64)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // * Weather details with Material 3 chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildWeatherChip(
                'Humidity',
                '${weather.current.humidity.toInt()}%',
                Icons.water_drop_outlined,
                colorScheme,
              ),
              const SizedBox(width: 8),
              _buildWeatherChip(
                'Wind',
                '${weather.current.windSpeed.toInt()} km/h',
                Icons.air,
                colorScheme,
              ),
              const SizedBox(width: 8),
              _buildWeatherChip(
                'UV Index',
                '${weather.current.uvIndex}',
                Icons.wb_sunny,
                colorScheme,
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // * 5-day forecast with horizontal scroll
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: weather.forecast.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final forecast = weather.forecast[index];
              return _buildMaterial3ForecastItem(forecast, colorScheme);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherChip(
    String label,
    String value,
    IconData icon,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMaterial3ForecastItem(
    WeatherForecast forecast,
    ColorScheme colorScheme,
  ) {
    return Container(
      width: 75,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('E').format(forecast.date),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(forecast.icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            '${forecast.maxTemp.toInt()}°',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${forecast.minTemp.toInt()}°',
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // * MATERIAL 3 MARKET PRICES CARD
  // ============================================================================

  Widget _buildMaterial3MarketCard(dashboardState, ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Market Prices',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (dashboardState.isMarketLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (dashboardState.hasMarketError)
              _buildMaterial3ErrorState(
                dashboardState.marketError!,
                () => _retryMarketLoad(),
                colorScheme,
              )
            else if (dashboardState.hasMarketData)
              _buildMaterial3MarketContent(
                dashboardState.marketData!,
                colorScheme,
              )
            else
              _buildMaterial3LoadingContent(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial3MarketContent(
    MarketPriceResponse marketData,
    ColorScheme colorScheme,
  ) {
    return Column(
      children: [
        ...marketData.prices
            .take(4)
            .map(
              (price) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.agriculture,
                        size: 20,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price.cropName,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            price.mandiName,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.7,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${price.currentPrice.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTrendColor(
                              price.trend,
                            ).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            price.formattedChange,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _getTrendColor(price.trend),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

        if (marketData.prices.length > 4)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () => _showAllPrices(marketData.prices),
              icon: const Icon(Icons.arrow_forward),
              label: Text('View All Prices (${marketData.prices.length})'),
            ),
          ),
      ],
    );
  }

  // ============================================================================
  // * MATERIAL 3 NOTIFICATIONS CARD
  // ============================================================================

  Widget _buildMaterial3NotificationsCard(
    dashboardState,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Recent Notifications',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                if (dashboardState.isNotificationsLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (dashboardState.hasNotificationError)
              _buildMaterial3ErrorState(
                dashboardState.notificationError!,
                () => _retryNotificationsLoad(),
                colorScheme,
              )
            else if (dashboardState.hasNotifications)
              _buildMaterial3NotificationsContent(
                dashboardState.notifications!,
                colorScheme,
              )
            else
              _buildMaterial3EmptyNotifications(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterial3NotificationsContent(
    List<NotificationData> notifications,
    ColorScheme colorScheme,
  ) {
    final recentNotifications = notifications.take(3).toList();

    return Column(
      children: [
        ...recentNotifications.map(
          (notification) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              tileColor: notification.isRead
                  ? colorScheme.surfaceContainerLow
                  : colorScheme.primaryContainer.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getPriorityColor(
                    notification.priority,
                  ).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getNotificationIcon(notification.priority),
                  color: _getPriorityColor(notification.priority),
                  size: 20,
                ),
              ),
              title: Text(
                notification.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: notification.isRead
                      ? FontWeight.w500
                      : FontWeight.w600,
                ),
              ),
              subtitle: Text(
                notification.message,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                _formatNotificationTime(notification.timestamp),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              onTap: () => _markNotificationAsRead(notification.id),
            ),
          ),
        ),

        if (notifications.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextButton.icon(
              onPressed: () => _showAllNotifications(notifications),
              icon: const Icon(Icons.arrow_forward),
              label: Text('View All Notifications (${notifications.length})'),
            ),
          ),
      ],
    );
  }

  Widget _buildMaterial3EmptyNotifications(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 48,
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No new notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // * MATERIAL 3 QUICK ACTIONS
  // ============================================================================

  Widget _buildMaterial3QuickActions(dashboardState, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        if (dashboardState.quickActions != null)
          _buildMaterial3QuickActionsGrid(
            dashboardState.quickActions!,
            colorScheme,
          )
        else
          _buildMaterial3LoadingContent(colorScheme),
      ],
    );
  }

  Widget _buildMaterial3QuickActionsGrid(
    List<QuickAction> actions,
    ColorScheme colorScheme,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.2,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildMaterial3ActionCard(action, colorScheme);
      },
    );
  }

  Widget _buildMaterial3ActionCard(
    QuickAction action,
    ColorScheme colorScheme,
  ) {
    return Card(
      elevation: action.isEnabled ? 1 : 0,
      child: InkWell(
        onTap: action.isEnabled ? () => _handleQuickAction(action) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: action.isEnabled
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.3),
                      colorScheme.primaryContainer.withValues(alpha: 0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: action.isEnabled
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  action.icon,
                  size: 20,
                  color: action.isEnabled
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  action.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: action.isEnabled
                        ? colorScheme.onSurface
                        : colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  action.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (action.badge != null)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    action.badge!,
                    style: TextStyle(
                      color: colorScheme.onError,
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // * RECENT ACTIVITY CARD
  // ============================================================================

  Widget _buildRecentActivityCard(ColorScheme colorScheme) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Recent Activity',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActivityItem(
              'Order #1234 delivered',
              'Your tomatoes were successfully delivered',
              Icons.check_circle,
              colorScheme.primary,
              '2 hours ago',
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'New order received',
              'Order #1235 for 50kg potatoes',
              Icons.shopping_cart,
              colorScheme.secondary,
              '5 hours ago',
              colorScheme,
            ),
            const SizedBox(height: 12),
            _buildActivityItem(
              'Weather alert',
              'Heavy rain expected tomorrow',
              Icons.warning_amber,
              colorScheme.error,
              '1 day ago',
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String description,
    IconData icon,
    Color iconColor,
    String time,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // * MATERIAL 3 FAB
  // ============================================================================

  Widget _buildMaterial3FAB(ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: () => _handleCreateOrder(),
      icon: const Icon(Icons.add),
      label: const Text('New Order'),
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
    );
  }

  // ============================================================================
  // * UTILITY WIDGETS AND METHODS
  // ============================================================================

  Widget _buildMaterial3ErrorState(
    String error,
    VoidCallback onRetry,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error_outline, color: colorScheme.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }

  Widget _buildMaterial3LoadingContent(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation(colorScheme.primary),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.low:
        return Icons.info_outline;
      case NotificationPriority.medium:
        return Icons.notifications_outlined;
      case NotificationPriority.high:
        return Icons.priority_high;
      case NotificationPriority.urgent:
        return Icons.warning_amber;
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'profile':
        _navigateToTab(3);
        break;
      case 'settings':
        // TODO: Navigate to settings
        break;
      case 'logout':
        _handleLogout();
        break;
    }
  }

  void _handleCreateOrder() {
    // TODO: Navigate to create order screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create order feature coming soon!')),
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
