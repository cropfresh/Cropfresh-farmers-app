import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';

/// * CROPFRESH HOME SCREEN
/// * Main dashboard screen following Material Design 3 principles
/// * Temporary placeholder for the main app functionality
/// * Uses 60-30-10 color rule throughout the interface
class CropFreshHomeScreen extends StatelessWidget {
  const CropFreshHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // * 60% BACKGROUND: Primary background color
      backgroundColor: CropFreshColors.background60Primary,
      
      // * APP BAR: Material Design 3 style
      appBar: AppBar(
        title: const Text('CropFresh Dashboard'),
        backgroundColor: CropFreshColors.background60Primary, // 60% background
        foregroundColor: CropFreshColors.onBackground60,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
            color: CropFreshColors.green30Primary, // 30% supporting color
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // TODO: Implement profile
            },
            color: CropFreshColors.green30Primary, // 30% supporting color
          ),
        ],
      ),
      
      // * BODY: Main content area
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * WELCOME SECTION
              _buildWelcomeSection(context),
              
              const SizedBox(height: 24),
              
              // * QUICK ACTIONS
              _buildQuickActions(context),
              
              const SizedBox(height: 24),
              
              // * DASHBOARD CARDS
              Expanded(
                child: _buildDashboardCards(context),
              ),
            ],
          ),
        ),
      ),
      
      // * FLOATING ACTION BUTTON: Primary action
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implement add crop functionality
        },
        backgroundColor: CropFreshColors.orange10Primary, // 10% action color
        foregroundColor: CropFreshColors.onOrange10,
        icon: const Icon(Icons.add),
        label: const Text('Add Crop'),
      ),
      
      // * BOTTOM NAVIGATION: Material Design 3 style
      bottomNavigationBar: NavigationBar(
        backgroundColor: CropFreshColors.background60Primary, // 60% background
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: CropFreshColors.green30Primary, // 30% supporting color
            ),
            selectedIcon: Icon(
              Icons.dashboard,
              color: CropFreshColors.green30Primary, // 30% supporting color
            ),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.agriculture_outlined,
              color: CropFreshColors.onBackground60Secondary,
            ),
            selectedIcon: Icon(
              Icons.agriculture,
              color: CropFreshColors.green30Primary, // 30% supporting color
            ),
            label: 'Crops',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.analytics_outlined,
              color: CropFreshColors.onBackground60Secondary,
            ),
            selectedIcon: Icon(
              Icons.analytics,
              color: CropFreshColors.green30Primary, // 30% supporting color
            ),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.store_outlined,
              color: CropFreshColors.onBackground60Secondary,
            ),
            selectedIcon: Icon(
              Icons.store,
              color: CropFreshColors.green30Primary, // 30% supporting color
            ),
            label: 'Market',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }

  /// * Build welcome section
  /// * Shows greeting and user status
  Widget _buildWelcomeSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // * 60% BACKGROUND: Card background
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(16), // Material 3 rounded corners
        boxShadow: [
          BoxShadow(
                         color: CropFreshColors.green30Primary.withValues(alpha: 0.1), // 30% supporting shadow
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Farmer! 👋',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: CropFreshColors.onBackground60,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your crops are growing healthy. Check your dashboard for updates.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
        ],
      ),
    );
  }

  /// * Build quick actions section
  /// * Shows common farmer actions
  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: CropFreshColors.onBackground60,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                context,
                'Weather',
                Icons.wb_sunny_outlined,
                CropFreshColors.waterBlue, // Weather color
                onTap: () {
                  // TODO: Implement weather
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Market',
                Icons.trending_up_outlined,
                CropFreshColors.orange10Primary, // 10% action color
                onTap: () {
                  // TODO: Implement market
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                context,
                'Tips',
                Icons.lightbulb_outlined,
                CropFreshColors.green30Primary, // 30% supporting color
                onTap: () {
                  // TODO: Implement tips
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// * Build action button
  /// * Reusable action button component
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12), // Material 3 rounded corners
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// * Build dashboard cards
  /// * Shows crop status and other information
  Widget _buildDashboardCards(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildDashboardCard(
          context,
          'Active Crops',
          '12',
          Icons.agriculture,
          CropFreshColors.green30Primary, // 30% supporting color
        ),
        _buildDashboardCard(
          context,
          'Harvest Ready',
          '3',
          Icons.eco,
          CropFreshColors.cropHealthy, // Agricultural color
        ),
        _buildDashboardCard(
          context,
          'Total Revenue',
          '₹25,000',
          Icons.account_balance_wallet,
          CropFreshColors.profit, // Financial color
        ),
        _buildDashboardCard(
          context,
          'Market Alerts',
          '5',
          Icons.notifications_active,
          CropFreshColors.orange10Primary, // 10% action color
        ),
      ],
    );
  }

  /// * Build dashboard card
  /// * Reusable card component for dashboard metrics
  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // * 60% BACKGROUND: Card background
        color: CropFreshColors.background60Card,
        borderRadius: BorderRadius.circular(16), // Material 3 rounded corners
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.arrow_upward,
                  color: color,
                  size: 16,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: CropFreshColors.onBackground60Secondary,
            ),
          ),
        ],
      ),
    );
  }
} 