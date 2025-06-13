// ===================================================================
// * MARKETPLACE SCREEN
// * Purpose: Central place for farmers to buy agri-inputs and nursery saplings
// * Features: Search, filter, categories, product listings
// * State Management: StatefulWidget
// * Security Level: MEDIUM - User-specific purchasing data
// ===================================================================

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * MARKETPLACE SCREEN
/// * Searchable and filterable view of agri-inputs and nursery saplings
class MarketplaceScreen extends StatefulWidget {
  final UserProfile userProfile;

  const MarketplaceScreen({super.key, required this.userProfile});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen>
    with TickerProviderStateMixin {
  // ============================================================================
  // * STATE VARIABLES
  // ============================================================================

  /// * Search controller
  final TextEditingController _searchController = TextEditingController();

  /// * Selected category
  String _selectedCategory = 'All';

  /// * Tab controller for categories
  late TabController _tabController;

  /// * Categories list
  final List<String> _categories = [
    'All',
    'Seeds',
    'Fertilizers',
    'Pesticides',
    'Tools',
    'Saplings',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // ============================================================================
  // * BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Scaffold(
      backgroundColor: CropFreshColors.background60Primary,
      body: SafeArea(
        child: Column(
          children: [
            // * Header with search
            _buildHeader(isSmallScreen),

            // * Category tabs
            _buildCategoryTabs(),

            // * Product grid
            Expanded(child: _buildProductGrid(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  /// * Build header with search and title
  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, isSmallScreen ? 16 : 20, 16, 16),
      decoration: BoxDecoration(
        color: CropFreshColors.surface60Primary,
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.onBackground60Tertiary.withValues(
              alpha: 0.1,
            ),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Title
          Text(
            'Marketplace',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onBackground60,
            ),
          ),

          const SizedBox(height: 16),

          // * Search bar
          Container(
            decoration: BoxDecoration(
              color: CropFreshColors.background60Secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CropFreshColors.onBackground60Tertiary.withValues(
                  alpha: 0.3, // ! IMPROVED: Better border visibility
                ),
              ),
              boxShadow: [
                // ! IMPROVED: Subtle shadow for better definition
                BoxShadow(
                  color: CropFreshColors.onBackground60Tertiary.withValues(
                    alpha: 0.05,
                  ),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                // ! IMPROVED: Better text style for search input
                color: CropFreshColors.onBackground60,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: CropFreshColors.onBackground60Tertiary,
                  fontSize: 16, // ! IMPROVED: Consistent font size
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: CropFreshColors
                      .onBackground60Secondary, // ! IMPROVED: Better icon color
                  size: 22, // ! IMPROVED: Consistent icon size
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: CropFreshColors.green30Primary,
                    size: 22, // ! IMPROVED: Consistent icon size
                  ),
                  onPressed: _showFilterSheet,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14, // ! IMPROVED: Better padding for text alignment
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// * Build category tabs
  Widget _buildCategoryTabs() {
    return Container(
      color: CropFreshColors.surface60Primary,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: CropFreshColors.green30Primary,
        labelColor: CropFreshColors.green30Primary,
        unselectedLabelColor: CropFreshColors.onBackground60Tertiary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        tabs: _categories.map((category) => Tab(text: category)).toList(),
      ),
    );
  }

  /// * Build product grid
  Widget _buildProductGrid(bool isSmallScreen) {
    return TabBarView(
      controller: _tabController,
      children: _categories.map((category) {
        return RefreshIndicator(
          onRefresh: () => _refreshProducts(category),
          child: GridView.builder(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: isSmallScreen
                  ? 0.85
                  : 0.80, // ! IMPROVED: Better aspect ratio for text space
              crossAxisSpacing: isSmallScreen
                  ? 12
                  : 16, // ! IMPROVED: Responsive spacing
              mainAxisSpacing: isSmallScreen
                  ? 12
                  : 16, // ! IMPROVED: Responsive spacing
            ),
            itemCount: _getProductCount(category),
            itemBuilder: (context, index) {
              return _buildProductCard(category, index, isSmallScreen);
            },
          ),
        );
      }).toList(),
    );
  }

  /// * Build individual product card
  Widget _buildProductCard(String category, int index, bool isSmallScreen) {
    return Container(
      decoration: BoxDecoration(
        color: CropFreshColors.surface60Primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CropFreshColors.onBackground60Tertiary.withValues(
              alpha: 0.1,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Product image
          Expanded(
            flex: isSmallScreen
                ? 2
                : 2, // ! FIX: Reduced image space to give more room for text
            child: Container(
              decoration: BoxDecoration(
                color: CropFreshColors.background60Secondary,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  _getCategoryIcon(category),
                  size: isSmallScreen
                      ? 32
                      : 36, // ! FIX: Slightly smaller icons to balance
                  color: CropFreshColors.green30Primary,
                ),
              ),
            ),
          ),

          // * Product details
          Expanded(
            flex: isSmallScreen
                ? 4
                : 3, // ! FIX: More space for price and button section
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
              decoration: BoxDecoration(
                color: CropFreshColors.background60Primary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // * Product name
                  Flexible(
                    flex: 2,
                    child: Text(
                      _getProductName(category, index),
                      style: TextStyle(
                        fontSize: isSmallScreen ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: CropFreshColors.onBackground60,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 4 : 6),

                  // * Price
                  Flexible(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CropFreshColors.green30Primary.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getProductPrice(index),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w800,
                          color: CropFreshColors.green30Primary,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 6 : 8),

                  // * Add to cart button
                  Flexible(
                    flex: 1,
                    child: SizedBox(
                      width: double.infinity,
                      height: isSmallScreen ? 36 : 40,
                      child: ElevatedButton(
                        onPressed: () => _addToCart(category, index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CropFreshColors.orange10Primary,
                          foregroundColor: CropFreshColors.onOrange10,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: isSmallScreen ? 6 : 8,
                            horizontal: 4,
                          ),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 12 : 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // * HELPER METHODS
  // ============================================================================

  /// * Get category icon
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Seeds':
        return Icons.eco;
      case 'Fertilizers':
        return Icons.science;
      case 'Pesticides':
        return Icons.pest_control;
      case 'Tools':
        return Icons.construction;
      case 'Saplings':
        return Icons.park;
      default:
        return Icons.shopping_bag;
    }
  }

  /// * Get product count for category
  int _getProductCount(String category) {
    // * Mock data - replace with actual data
    return category == 'All' ? 20 : 8;
  }

  /// * Get product name
  String _getProductName(String category, int index) {
    // * Mock data - replace with actual data
    final baseNames = {
      'Seeds': ['Premium Rice Seeds', 'Wheat Seeds', 'Corn Seeds'],
      'Fertilizers': ['NPK Fertilizer', 'Organic Compost', 'Urea'],
      'Pesticides': ['Insecticide', 'Herbicide', 'Fungicide'],
      'Tools': ['Garden Spade', 'Pruning Shears', 'Watering Can'],
      'Saplings': ['Mango Sapling', 'Apple Sapling', 'Orange Sapling'],
    };

    final names = baseNames[category] ?? ['Product'];
    return names[index % names.length];
  }

  /// * Get product price
  String _getProductPrice(int index) {
    // * Mock data - replace with actual data
    final prices = ['₹299', '₹499', '₹799', '₹1,299', '₹599'];
    return prices[index % prices.length];
  }

  /// * Show filter sheet
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: CropFreshColors.background60Primary,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Products',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: CropFreshColors.onBackground60,
              ),
            ),
            const SizedBox(height: 20),
            // * Filter options would go here
            Text(
              'Filter options coming soon...',
              style: TextStyle(color: CropFreshColors.onBackground60Secondary),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// * Add product to cart
  void _addToCart(String category, int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_getProductName(category, index)} added to cart'),
        backgroundColor: CropFreshColors.green30Primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// * Refresh products
  Future<void> _refreshProducts(String category) async {
    // * Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // * Refresh logic would go here
  }
}
