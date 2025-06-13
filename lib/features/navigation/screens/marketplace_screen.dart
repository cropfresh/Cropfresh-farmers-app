// ===================================================================
// * MARKETPLACE SCREEN
// * Purpose: Central place for farmers to buy agri-inputs and nursery saplings
// * Features: Search, filter, categories, product listings with Material 3 design
// * State Management: StatefulWidget
// * Security Level: MEDIUM - User-specific purchasing data
// ===================================================================

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * PRODUCT MODEL
/// * Represents a marketplace product with complete details
class MarketplaceProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String vendor;
  final bool isInStock;
  final String specifications;
  final List<String> benefits;

  const MarketplaceProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.vendor,
    required this.isInStock,
    required this.specifications,
    required this.benefits,
  });
}

/// * MARKETPLACE SCREEN
/// * Material 3 design with enhanced card layouts and detailed views
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

          // * Search bar with Material 3 design
          Container(
            decoration: BoxDecoration(
              color: CropFreshColors.background60Secondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CropFreshColors.onBackground60Tertiary.withValues(
                  alpha: 0.3,
                ),
              ),
              boxShadow: [
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
                color: CropFreshColors.onBackground60,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search products...',
                hintStyle: TextStyle(
                  color: CropFreshColors.onBackground60Tertiary,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: CropFreshColors.onBackground60Secondary,
                  size: 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.filter_list,
                    color: CropFreshColors.green30Primary,
                    size: 22,
                  ),
                  onPressed: _showFilterSheet,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
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

  /// * Build product grid with Material 3 design
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
              // ! FIXED: Adjusted aspect ratio to prevent overflow
              childAspectRatio: isSmallScreen ? 0.68 : 0.65,
              crossAxisSpacing: isSmallScreen ? 16 : 20,
              mainAxisSpacing: isSmallScreen ? 16 : 20,
            ),
            itemCount: _getProductCount(category),
            itemBuilder: (context, index) {
              final product = _getProduct(category, index);
              return _buildMaterial3ProductCard(product, isSmallScreen);
            },
          ),
        );
      }).toList(),
    );
  }

  /// * Build Material 3 enhanced product card
  Widget _buildMaterial3ProductCard(
    MarketplaceProduct product,
    bool isSmallScreen,
  ) {
    return Card(
      // ! MATERIAL 3: Using Material 3 Card widget with proper elevation
      elevation: 2,
      shadowColor: CropFreshColors.onBackground60Tertiary.withValues(
        alpha: 0.15,
      ),
      surfaceTintColor: CropFreshColors.green30Primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16,
        ), // ! MATERIAL 3: Larger corner radius
      ),
      child: InkWell(
        // ! IMPROVED: Full card tap area with Material 3 ripple
        onTap: () => _showProductDetails(product),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CropFreshColors.surface60Primary,
                CropFreshColors.surface60Primary.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // * Product image with Material 3 styling
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CropFreshColors.background60Secondary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        CropFreshColors.green30Primary.withValues(alpha: 0.1),
                        CropFreshColors.orange10Primary.withValues(alpha: 0.1),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // * Product icon/image
                      Center(
                        child: Icon(
                          _getCategoryIcon(product.category),
                          size: isSmallScreen ? 40 : 48,
                          color: CropFreshColors.green30Primary,
                        ),
                      ),
                      // * Stock status badge
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: product.isInStock
                                ? CropFreshColors.green30Primary
                                : CropFreshColors.onBackground60Tertiary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            product.isInStock ? 'In Stock' : 'Out of Stock',
                            style: TextStyle(
                              color: product.isInStock
                                  ? CropFreshColors.onGreen30
                                  : CropFreshColors.surface60Primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // * Product details section
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // * Product name and rating
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 12 : 14,
                              fontWeight: FontWeight.w600,
                              color: CropFreshColors.onBackground60,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          // * Rating and vendor
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 12,
                                color: CropFreshColors.orange10Primary,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${product.rating}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      CropFreshColors.onBackground60Secondary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.reviewCount})',
                                style: TextStyle(
                                  fontSize: 8,
                                  color: CropFreshColors.onBackground60Tertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // * Price with Material 3 styling
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: CropFreshColors.green30Primary.withValues(
                            alpha: 0.12,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CropFreshColors.green30Primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        ),
                        child: Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w700,
                            color: CropFreshColors.green30Primary,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // * Add to cart button with Material 3 styling
                      SizedBox(
                        width: double.infinity,
                        height: isSmallScreen ? 32 : 36,
                        child: FilledButton(
                          onPressed: product.isInStock
                              ? () => _addToCart(product)
                              : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: CropFreshColors.orange10Primary,
                            foregroundColor: CropFreshColors.onOrange10,
                            disabledBackgroundColor: CropFreshColors
                                .onBackground60Tertiary
                                .withValues(alpha: 0.3),
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            product.isInStock ? 'Add to Cart' : 'Out of Stock',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 10 : 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
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
        ),
      ),
    );
  }

  /// * Show detailed product information modal
  void _showProductDetails(MarketplaceProduct product) {
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
          child: _buildProductDetailView(product, scrollController),
        ),
      ),
    );
  }

  /// * Build detailed product view
  Widget _buildProductDetailView(
    MarketplaceProduct product,
    ScrollController scrollController,
  ) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: CropFreshColors.onBackground60Tertiary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * Product header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // * Product image
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: CropFreshColors.background60Secondary,
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            CropFreshColors.green30Primary.withValues(
                              alpha: 0.1,
                            ),
                            CropFreshColors.orange10Primary.withValues(
                              alpha: 0.1,
                            ),
                          ],
                        ),
                      ),
                      child: Icon(
                        _getCategoryIcon(product.category),
                        size: 60,
                        color: CropFreshColors.green30Primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // * Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: CropFreshColors.onBackground60,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'by ${product.vendor}',
                            style: TextStyle(
                              fontSize: 14,
                              color: CropFreshColors.onBackground60Secondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // * Rating
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 18,
                                color: CropFreshColors.orange10Primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${product.rating}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: CropFreshColors.onBackground60,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(${product.reviewCount} reviews)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: CropFreshColors.onBackground60Tertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // * Price
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: CropFreshColors.green30Primary.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: CropFreshColors.green30Primary
                                    .withValues(alpha: 0.2),
                              ),
                            ),
                            child: Text(
                              '₹${product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: CropFreshColors.green30Primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // * Description
                _buildDetailSection('Description', product.description),

                const SizedBox(height: 20),

                // * Specifications
                _buildDetailSection('Specifications', product.specifications),

                const SizedBox(height: 20),

                // * Benefits
                _buildBenefitsSection(product.benefits),

                const SizedBox(height: 24),

                // * Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: CropFreshColors.green30Primary,
                          side: BorderSide(
                            color: CropFreshColors.green30Primary,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: FilledButton(
                        onPressed: product.isInStock
                            ? () {
                                _addToCart(product);
                                Navigator.pop(context);
                              }
                            : null,
                        style: FilledButton.styleFrom(
                          backgroundColor: CropFreshColors.orange10Primary,
                          foregroundColor: CropFreshColors.onOrange10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          product.isInStock ? 'Add to Cart' : 'Out of Stock',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// * Build detail section
  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CropFreshColors.onBackground60,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CropFreshColors.surface60Primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CropFreshColors.onBackground60Tertiary.withValues(
                alpha: 0.2,
              ),
            ),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: CropFreshColors.onBackground60Secondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  /// * Build benefits section
  Widget _buildBenefitsSection(List<String> benefits) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Benefits',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CropFreshColors.onBackground60,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CropFreshColors.surface60Primary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CropFreshColors.onBackground60Tertiary.withValues(
                alpha: 0.2,
              ),
            ),
          ),
          child: Column(
            children: benefits
                .map(
                  (benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: CropFreshColors.green30Primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            benefit,
                            style: TextStyle(
                              fontSize: 14,
                              color: CropFreshColors.onBackground60Secondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
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
    return category == 'All' ? 20 : 8;
  }

  /// * Get product with mock data
  MarketplaceProduct _getProduct(String category, int index) {
    final products = _getMockProducts(category);
    return products[index % products.length];
  }

  /// * Get mock products data
  List<MarketplaceProduct> _getMockProducts(String category) {
    final baseProducts = {
      'Seeds': [
        MarketplaceProduct(
          id: 'seed_001',
          name: 'Premium Basmati Rice Seeds',
          category: 'Seeds',
          price: 299.0,
          description:
              'High-yield basmati rice seeds with excellent grain quality and aroma. Suitable for all soil types and weather conditions.',
          imageUrl: '',
          rating: 4.5,
          reviewCount: 156,
          vendor: 'AgroSeed Co.',
          isInStock: true,
          specifications:
              'Variety: Pusa Basmati 1121\nYield: 45-50 quintals/hectare\nMaturity: 145-150 days\nSeed Rate: 20-25 kg/hectare',
          benefits: [
            'High yielding variety with superior grain quality',
            'Disease resistant and drought tolerant',
            'Long grain with excellent cooking properties',
            'Premium market price for quality produce',
          ],
        ),
        MarketplaceProduct(
          id: 'seed_002',
          name: 'Hybrid Wheat Seeds',
          category: 'Seeds',
          price: 450.0,
          description:
              'Advanced hybrid wheat seeds with high protein content and excellent disease resistance.',
          imageUrl: '',
          rating: 4.3,
          reviewCount: 203,
          vendor: 'CropTech Seeds',
          isInStock: true,
          specifications:
              'Variety: HD-3086\nYield: 55-60 quintals/hectare\nMaturity: 120-125 days\nSeed Rate: 40-50 kg/hectare',
          benefits: [
            'High protein content (12-14%)',
            'Excellent lodging resistance',
            'Suitable for late sowing conditions',
            'Good market demand',
          ],
        ),
      ],
      'Fertilizers': [
        MarketplaceProduct(
          id: 'fert_001',
          name: 'NPK 19:19:19 Fertilizer',
          category: 'Fertilizers',
          price: 850.0,
          description:
              'Balanced NPK fertilizer perfect for all crops during vegetative growth stage.',
          imageUrl: '',
          rating: 4.7,
          reviewCount: 89,
          vendor: 'NutriGrow',
          isInStock: true,
          specifications:
              'NPK Ratio: 19:19:19\nPackage: 50kg bag\nWater Soluble: Yes\nApplication: Foliar/Drip irrigation',
          benefits: [
            'Balanced nutrition for optimal growth',
            'Water soluble for easy application',
            'Improves yield and quality',
            'Cost-effective solution',
          ],
        ),
      ],
      'Tools': [
        MarketplaceProduct(
          id: 'tool_001',
          name: 'Professional Garden Spade',
          category: 'Tools',
          price: 1200.0,
          description:
              'Heavy-duty garden spade with ergonomic handle and sharp steel blade.',
          imageUrl: '',
          rating: 4.6,
          reviewCount: 45,
          vendor: 'ToolMaster',
          isInStock: false,
          specifications:
              'Material: Carbon Steel\nHandle: Fiberglass\nWeight: 1.5kg\nWarranty: 2 years',
          benefits: [
            'Durable carbon steel construction',
            'Ergonomic design reduces fatigue',
            'Sharp blade for easy digging',
            'Long-lasting with proper care',
          ],
        ),
      ],
    };

    return baseProducts[category] ??
        [
          MarketplaceProduct(
            id: 'default_001',
            name: 'Sample Product',
            category: category,
            price: 500.0,
            description: 'Sample product description.',
            imageUrl: '',
            rating: 4.0,
            reviewCount: 10,
            vendor: 'Sample Vendor',
            isInStock: true,
            specifications: 'Sample specifications',
            benefits: ['Sample benefit'],
          ),
        ];
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
  void _addToCart(MarketplaceProduct product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart'),
        backgroundColor: CropFreshColors.green30Primary,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
