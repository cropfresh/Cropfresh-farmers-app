// ===================================================================
// * MY ORDERS SCREEN
// * Purpose: Consolidated tracking of sales and purchases
// * Features: Two sub-tabs (My Sales, My Purchases), order status tracking
// * State Management: StatefulWidget with TabController
// * Security Level: HIGH - Financial and transaction data
// ===================================================================

import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * MY ORDERS SCREEN
/// * Track all sales and purchases in one place
class MyOrdersScreen extends StatefulWidget {
  final UserProfile userProfile;

  const MyOrdersScreen({super.key, required this.userProfile});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen>
    with TickerProviderStateMixin {
  // ============================================================================
  // * STATE VARIABLES
  // ============================================================================

  /// * Tab controller for sales/purchases
  late TabController _tabController;

  /// * Tab labels
  final List<String> _tabs = ['My Sales', 'My Purchases'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
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
            // * Header with title
            _buildHeader(isSmallScreen),

            // * Tab bar
            _buildTabBar(),

            // * Tab content
            Expanded(child: _buildTabContent(isSmallScreen)),
          ],
        ),
      ),
    );
  }

  /// * Build header with title
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'My Orders',
            style: TextStyle(
              fontSize: isSmallScreen ? 24 : 28,
              fontWeight: FontWeight.w600,
              color: CropFreshColors.onBackground60,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: CropFreshColors.green30Primary,
            ),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
    );
  }

  /// * Build tab bar
  Widget _buildTabBar() {
    return Container(
      color: CropFreshColors.surface60Primary,
      child: TabBar(
        controller: _tabController,
        indicatorColor: CropFreshColors.green30Primary,
        labelColor: CropFreshColors.green30Primary,
        unselectedLabelColor: CropFreshColors.onBackground60Tertiary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  /// * Build tab content
  Widget _buildTabContent(bool isSmallScreen) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildSalesTab(isSmallScreen),
        _buildPurchasesTab(isSmallScreen),
      ],
    );
  }

  /// * Build sales tab content
  Widget _buildSalesTab(bool isSmallScreen) {
    return RefreshIndicator(
      onRefresh: _refreshSales,
      child: ListView.builder(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        itemCount: 8, // Mock data count
        itemBuilder: (context, index) {
          return _buildSalesOrderCard(index, isSmallScreen);
        },
      ),
    );
  }

  /// * Build purchases tab content
  Widget _buildPurchasesTab(bool isSmallScreen) {
    return RefreshIndicator(
      onRefresh: _refreshPurchases,
      child: ListView.builder(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        itemCount: 6, // Mock data count
        itemBuilder: (context, index) {
          return _buildPurchaseOrderCard(index, isSmallScreen);
        },
      ),
    );
  }

  /// * Build individual sales order card
  Widget _buildSalesOrderCard(int index, bool isSmallScreen) {
    final orderStatus = _getSalesOrderStatus(index);
    final statusColor = _getStatusColor(orderStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #SL${1000 + index}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    orderStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // * Product info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CropFreshColors.green30Container,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.eco,
                    color: CropFreshColors.green30Primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getSalesProductName(index),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: CropFreshColors.onBackground60,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getSalesQuantity(index)} | ${_getSalesPrice(index)}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // * Date and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Listed: ${_getOrderDate(index)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.onBackground60Tertiary,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewOrderDetails('sales', index),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: CropFreshColors.green30Primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// * Build individual purchase order card
  Widget _buildPurchaseOrderCard(int index, bool isSmallScreen) {
    final orderStatus = _getPurchaseOrderStatus(index);
    final statusColor = _getStatusColor(orderStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * Header row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #PU${2000 + index}',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.w600,
                    color: CropFreshColors.onBackground60,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    orderStatus,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // * Product info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: CropFreshColors.orange10Container,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.science,
                    color: CropFreshColors.orange10Primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getPurchaseProductName(index),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w500,
                          color: CropFreshColors.onBackground60,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_getPurchaseQuantity(index)} | ${_getPurchasePrice(index)}',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 12 : 14,
                          color: CropFreshColors.onBackground60Secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // * Date and actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ordered: ${_getOrderDate(index)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: CropFreshColors.onBackground60Tertiary,
                  ),
                ),
                TextButton(
                  onPressed: () => _viewOrderDetails('purchase', index),
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: CropFreshColors.orange10Primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * HELPER METHODS
  // ============================================================================

  /// * Get sales order status
  String _getSalesOrderStatus(int index) {
    final statuses = ['Active', 'Sold', 'Expired', 'Pending'];
    return statuses[index % statuses.length];
  }

  /// * Get purchase order status
  String _getPurchaseOrderStatus(int index) {
    final statuses = ['Delivered', 'Shipped', 'Processing', 'Cancelled'];
    return statuses[index % statuses.length];
  }

  /// * Get status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'delivered':
        return CropFreshColors.successPrimary;
      case 'sold':
      case 'shipped':
        return CropFreshColors.green30Primary;
      case 'processing':
      case 'pending':
        return CropFreshColors.orange10Primary;
      case 'expired':
      case 'cancelled':
        return CropFreshColors.errorPrimary;
      default:
        return CropFreshColors.onBackground60Tertiary;
    }
  }

  /// * Get sales product name
  String _getSalesProductName(int index) {
    final products = [
      'Premium Rice',
      'Organic Wheat',
      'Fresh Tomatoes',
      'Green Beans',
    ];
    return products[index % products.length];
  }

  /// * Get purchase product name
  String _getPurchaseProductName(int index) {
    final products = [
      'NPK Fertilizer',
      'Organic Seeds',
      'Pesticide Spray',
      'Garden Tools',
    ];
    return products[index % products.length];
  }

  /// * Get sales quantity
  String _getSalesQuantity(int index) {
    final quantities = ['50 kg', '100 kg', '25 kg', '75 kg'];
    return quantities[index % quantities.length];
  }

  /// * Get purchase quantity
  String _getPurchaseQuantity(int index) {
    final quantities = ['5 bags', '2 packets', '1 bottle', '3 items'];
    return quantities[index % quantities.length];
  }

  /// * Get sales price
  String _getSalesPrice(int index) {
    final prices = ['₹2,500', '₹4,000', '₹1,200', '₹3,500'];
    return prices[index % prices.length];
  }

  /// * Get purchase price
  String _getPurchasePrice(int index) {
    final prices = ['₹1,500', '₹800', '₹450', '₹2,200'];
    return prices[index % prices.length];
  }

  /// * Get order date
  String _getOrderDate(int index) {
    final dates = ['2 days ago', '1 week ago', '3 days ago', '5 days ago'];
    return dates[index % dates.length];
  }

  /// * Show filter options
  void _showFilterOptions() {
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
              'Filter Orders',
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

  /// * View order details
  void _viewOrderDetails(String type, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CropFreshColors.background60Primary,
        title: Text(
          'Order Details',
          style: TextStyle(color: CropFreshColors.onBackground60),
        ),
        content: Text(
          'Detailed view for ${type == 'sales' ? 'sales' : 'purchase'} order #${index + 1000} coming soon...',
          style: TextStyle(color: CropFreshColors.onBackground60Secondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: TextStyle(color: CropFreshColors.green30Primary),
            ),
          ),
        ],
      ),
    );
  }

  /// * Refresh sales data
  Future<void> _refreshSales() async {
    await Future.delayed(const Duration(seconds: 1));
    // * Refresh logic would go here
  }

  /// * Refresh purchases data
  Future<void> _refreshPurchases() async {
    await Future.delayed(const Duration(seconds: 1));
    // * Refresh logic would go here
  }
}
