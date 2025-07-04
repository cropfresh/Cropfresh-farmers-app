// ===================================================================
// * MAIN NAVIGATION WRAPPER - MATERIAL 3 EDITION
// * Purpose: Central navigation with Material 3 NavigationBar design
// * Features: Home, Marketplace, Cart, Orders, Profile, Sell FAB
// * State Management: StatefulWidget with Navigation 3 principles
// * Security Level: LOW - Navigation only
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard_screen_v2.dart';
import '../login/models/user_profile.dart';
import 'screens/marketplace_screen.dart';
import 'screens/my_orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/sell_screen.dart';
import 'screens/cart_screen.dart'; // * NEW: Cart screen

/// * MAIN NAVIGATION CONTROLLER - MATERIAL 3
/// * Implements Material 3 NavigationBar with cart and enhanced UX
/// * Features: Dynamic badges, haptic feedback, smooth animations
class MainNavigationWrapper extends StatefulWidget {
  final UserProfile userProfile;

  const MainNavigationWrapper({super.key, required this.userProfile});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper>
    with TickerProviderStateMixin {
  // ============================================================================
  // * NAVIGATION STATE - MATERIAL 3
  // ============================================================================

  /// * Current selected destination index
  int _currentIndex = 0;

  /// * Page controller for smooth navigation transitions
  late PageController _pageController;

  /// * Animation controller for FAB entrance
  late AnimationController _fabAnimationController;

  /// * FAB scale animation with Material 3 curves
  late Animation<double> _fabScaleAnimation;

  /// * Navigation destination screens
  late List<Widget> _screens;

  /// * Cart item count for badge display
  int _cartItemCount = 3; // * TODO: Connect to cart state management

  /// * Orders notification count
  final int _ordersNotificationCount = 2; // * TODO: Connect to orders state

  @override
  void initState() {
    super.initState();
    _initializeNavigation();
    _initializeAnimations();
    _setupScreens();
  }

  /// * Initialize navigation components with Material 3 patterns
  void _initializeNavigation() {
    _pageController = PageController(initialPage: _currentIndex);
  }

  /// * Initialize animations with Material 3 motion curves
  void _initializeAnimations() {
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400), // * Extended for smoothness
      vsync: this,
    );

    _fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fabAnimationController,
        curve: Curves.easeOutBack, // * Material 3 motion curve
      ),
    );

    // * Delayed FAB entrance for better UX
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _fabAnimationController.forward();
    });
  }

  /// * Setup screens for Material 3 navigation
  void _setupScreens() {
    _screens = [
      // * Home: Enhanced dashboard with Material 3 design
      DashboardScreenV2(
        userProfile: widget.userProfile,
        onNavigateToTab: _onTabSelected,
      ),

      // * Marketplace: Agri-inputs with Material 3 styling
      MarketplaceScreen(userProfile: widget.userProfile),

      // * Cart: NEW - Shopping cart with Material 3 design
      CartScreen(
        userProfile: widget.userProfile,
        onItemCountChanged: _updateCartCount,
      ),

      // * Orders: Enhanced order tracking
      MyOrdersScreen(userProfile: widget.userProfile),

      // * Profile: Account with Material 3 components
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
  // * NAVIGATION METHODS - MATERIAL 3 ENHANCED
  // ============================================================================

  /// * Handle destination selection with Material 3 navigation patterns
  void _onTabSelected(int index) {
    // * Special handling for FAB (index 5 represents Sell action)
    if (index == 5) {
      _showSellScreen();
      return;
    }

    // * Material 3 haptic feedback for navigation
    HapticFeedback.selectionClick();

    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });

      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 350), // * Material 3 timing
        curve: Curves.easeInOutCubicEmphasized, // * Material 3 curve
      );
    }
  }

  /// * Show sell screen with Material 3 modal presentation
  void _showSellScreen() {
    // * Enhanced haptic feedback for primary action
    HapticFeedback.mediumImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true, // * Material 3 safe area handling
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28), // * Material 3 corner radius
            ),
          ),
          child: SellScreen(
            userProfile: widget.userProfile,
            scrollController: scrollController,
          ),
        ),
      ),
    );
  }

  /// * Update cart item count for badge
  void _updateCartCount(int newCount) {
    if (mounted) {
      setState(() {
        _cartItemCount = newCount;
      });
    }
  }

  // ============================================================================
  // * BUILD METHODS - MATERIAL 3 DESIGN
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: _buildMaterial3NavigationBar(colorScheme),
      floatingActionButton: _buildMaterial3FAB(colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
    );
  }

  /// * Build Material 3 NavigationBar
  Widget _buildMaterial3NavigationBar(ColorScheme colorScheme) {
    return NavigationBar(
      selectedIndex: _currentIndex,
      onDestinationSelected: _onTabSelected,
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      indicatorColor: colorScheme.secondaryContainer,
      height: 80, // * Material 3 recommended height
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      animationDuration: const Duration(
        milliseconds: 400,
      ), // * Smooth transitions
      destinations: [
        // * Home Destination
        NavigationDestination(
          icon: Icon(Icons.home_outlined, size: 24),
          selectedIcon: Icon(
            Icons.home,
            size: 24,
            color: colorScheme.onSecondaryContainer,
          ),
          label: 'Home',
        ),

        // * Marketplace Destination
        NavigationDestination(
          icon: Icon(Icons.storefront_outlined, size: 24),
          selectedIcon: Icon(
            Icons.storefront,
            size: 24,
            color: colorScheme.onSecondaryContainer,
          ),
          label: 'Market',
        ),

        // * Cart Destination with Badge
        NavigationDestination(
          icon: Badge.count(
            count: _cartItemCount,
            isLabelVisible: _cartItemCount > 0,
            backgroundColor: colorScheme.error,
            textColor: colorScheme.onError,
            child: Icon(Icons.shopping_cart_outlined, size: 24),
          ),
          selectedIcon: Badge.count(
            count: _cartItemCount,
            isLabelVisible: _cartItemCount > 0,
            backgroundColor: colorScheme.error,
            textColor: colorScheme.onError,
            child: Icon(
              Icons.shopping_cart,
              size: 24,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          label: 'Cart',
        ),

        // * Orders Destination with Badge
        NavigationDestination(
          icon: Badge.count(
            count: _ordersNotificationCount,
            isLabelVisible: _ordersNotificationCount > 0,
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: Icon(Icons.receipt_long_outlined, size: 24),
          ),
          selectedIcon: Badge.count(
            count: _ordersNotificationCount,
            isLabelVisible: _ordersNotificationCount > 0,
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: Icon(
              Icons.receipt_long,
              size: 24,
              color: colorScheme.onSecondaryContainer,
            ),
          ),
          label: 'Orders',
        ),

        // * Profile Destination
        NavigationDestination(
          icon: Icon(Icons.person_outline, size: 24),
          selectedIcon: Icon(
            Icons.person,
            size: 24,
            color: colorScheme.onSecondaryContainer,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  /// * Build Material 3 Extended FAB
  Widget _buildMaterial3FAB(ColorScheme colorScheme) {
    return ScaleTransition(
      scale: _fabScaleAnimation,
      child: FloatingActionButton.extended(
        onPressed: _showSellScreen,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 3, // * Material 3 elevation
        highlightElevation: 6,
        icon: const Icon(Icons.add_business, size: 24),
        label: const Text(
          'Sell',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    );
  }
}
