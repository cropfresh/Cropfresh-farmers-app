// ===================================================================
// * MAIN NAVIGATION WRAPPER
// * Purpose: Central navigation with bottom nav and floating action button
// * Features: Home, Marketplace, Sell FAB, My Orders, Profile, Services
// * State Management: StatefulWidget with PageController
// * Security Level: LOW - Navigation only
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/colors.dart';
import '../dashboard/dashboard_screen_v2.dart';
import '../login/models/user_profile.dart';
import 'screens/marketplace_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/services_screen.dart';
import 'screens/sell_screen.dart';

/// * MAIN NAVIGATION CONTROLLER
/// * Handles bottom navigation with floating action button
/// * Manages page state and navigation between main sections
class MainNavigationWrapper extends StatefulWidget {
  final UserProfile userProfile;

  const MainNavigationWrapper({super.key, required this.userProfile});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper>
    with TickerProviderStateMixin {
  // ============================================================================
  // * NAVIGATION STATE
  // ============================================================================

  /// * Current selected tab index
  int _currentIndex = 0;

  /// * Page controller for smooth navigation
  late PageController _pageController;

  /// * Animation controller for FAB
  late AnimationController _fabAnimationController;

  /// * FAB scale animation
  late Animation<double> _fabScaleAnimation;

  /// * Tab screens list
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
    _initializeAnimations();
    _setupScreens();
  }

  /// * Initialize navigation components
  void _initializeNavigation() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  /// * Initialize animations
  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _fabAnimationController.forward();
  }

  /// * Setup screens for navigation
  void _setupScreens() {
    _screens = [
      // * Home: Dashboard with market prices and buy orders
      DashboardScreenV2(
        userProfile: widget.userProfile,
        onNavigateToTab: _onTabSelected,
      ),

      // * Marketplace: Agri-inputs and nursery saplings
      MarketplaceScreen(userProfile: widget.userProfile),

      // * My Orders: Sales and purchases tracking
      MyOrdersScreen(userProfile: widget.userProfile),

      // * Profile: Account info and settings
      ProfileScreen(userProfile: widget.userProfile),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  // ============================================================================
  // * NAVIGATION METHODS
  // ============================================================================

  /// * Handle tab selection
  void _onTabSelected(int index) {
    if (index == 2) {
      // * Special handling for Sell tab (FAB)
      _showSellScreen();
      return;
    }

    // * Map navigation indices to screen indices
    int screenIndex;
    if (index < 2) {
      // * Home (0) and Marketplace (1) map directly
      screenIndex = index;
    } else {
      // * Orders (3) maps to screen index 2, Profile (4) maps to screen index 3
      screenIndex = index - 1;
    }

    if (_currentIndex != screenIndex) {
      setState(() {
        _currentIndex = screenIndex;
      });

      _pageController.animateToPage(
        screenIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// * Show sell screen as modal
  void _showSellScreen() {
    // * Haptic feedback for important action
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: CropFreshColors.background60Primary,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SellScreen(
            userProfile: widget.userProfile,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }

  // ============================================================================
  // * BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens, // All 4 screens: Home, Market, Orders, Profile
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  /// * Build custom bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: CropFreshColors.surface60Primary,
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.onBackground60Tertiary.withValues(
              alpha: 0.1,
            ),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // * Home Tab
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                isActive: _currentIndex == 0,
              ),

              // * Marketplace Tab
              _buildNavItem(
                icon: Icons.storefront_outlined,
                activeIcon: Icons.storefront,
                label: 'Market',
                index: 1,
                isActive: _currentIndex == 1,
              ),

              // * Spacer for FAB
              const SizedBox(width: 40),

              // * My Orders Tab
              _buildNavItem(
                icon: Icons.list_alt_outlined,
                activeIcon: Icons.list_alt,
                label: 'Orders',
                index: 3,
                isActive: _currentIndex == 2,
              ),

              // * Profile Tab
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                index: 4,
                isActive: _currentIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// * Build individual navigation item
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 55),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? CropFreshColors.green30Primary
                  : CropFreshColors.onBackground60Tertiary,
              size: 22,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? CropFreshColors.green30Primary
                      : CropFreshColors.onBackground60Tertiary,
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

  /// * Build floating action button for Sell
  Widget _buildFloatingActionButton() {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton(
        onPressed: _showSellScreen,
        backgroundColor: CropFreshColors.orange10Primary,
        foregroundColor: CropFreshColors.onOrange10,
        elevation: 8,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CropFreshColors.orange10Primary,
                CropFreshColors.orange10Vibrant,
              ],
            ),
          ),
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
