// ===================================================================
// * CART SCREEN - MATERIAL 3 DESIGN
// * Purpose: Shopping cart for agri-inputs and nursery products
// * Features: Material 3 components, quantity management, checkout flow
// * State Management: StatefulWidget with callback for item count updates
// * Security Level: MEDIUM - Handles purchase data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../login/models/user_profile.dart';

/// * CART SCREEN - MATERIAL 3 IMPLEMENTATION
/// * Displays shopping cart with Material 3 design patterns
/// * Features: Item management, quantity controls, price calculations
class CartScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(int) onItemCountChanged;

  const CartScreen({
    super.key,
    required this.userProfile,
    required this.onItemCountChanged,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // ============================================================================
  // * CART STATE MANAGEMENT
  // ============================================================================

  /// * Cart items list (mock data for now)
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _initializeCart();
  }

  /// * Initialize cart with sample data
  void _initializeCart() {
    _cartItems = [
      CartItem(
        id: '1',
        name: 'Organic Tomato Seeds',
        description: 'Hybrid variety, 50g pack',
        price: 125.0,
        quantity: 2,
        category: 'Seeds',
        imageUrl: 'assets/images/tomato_seeds.jpg',
      ),
      CartItem(
        id: '2',
        name: 'NPK Fertilizer',
        description: '10kg bag, balanced formula',
        price: 450.0,
        quantity: 1,
        category: 'Fertilizer',
        imageUrl: 'assets/images/npk_fertilizer.jpg',
      ),
      CartItem(
        id: '3',
        name: 'Mango Sapling',
        description: 'Alphonso variety, 2 years old',
        price: 350.0,
        quantity: 1,
        category: 'Nursery',
        imageUrl: 'assets/images/mango_sapling.jpg',
      ),
    ];

    // * Notify parent about initial cart count
    _updateCartCount();
  }

  // ============================================================================
  // * CART OPERATIONS
  // ============================================================================

  /// * Update item quantity
  void _updateQuantity(String itemId, int newQuantity) {
    try {
      setState(() {
        final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
        if (itemIndex != -1 && itemIndex < _cartItems.length) {
          if (newQuantity <= 0) {
            _cartItems.removeAt(itemIndex);
          } else {
            _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
              quantity: newQuantity,
            );
          }
        }
      });

      _updateCartCount();
      HapticFeedback.selectionClick();
    } catch (e) {
      // * Handle errors gracefully
      debugPrint('Error updating quantity: $e');
    }
  }

  /// * Remove item from cart
  void _removeItem(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });

    _updateCartCount();
    HapticFeedback.lightImpact();

    // * Show confirmation snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // * TODO: Implement undo functionality
          },
        ),
      ),
    );
  }

  /// * Update cart count in parent widget
  void _updateCartCount() {
    final totalItems = _cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );
    widget.onItemCountChanged(totalItems);
  }

  /// * Calculate total price
  double get _totalPrice {
    return _cartItems.fold<double>(
      0.0,
      (sum, item) => sum + (item.price * item.quantity),
    );
  }

  // ============================================================================
  // * BUILD METHODS - MATERIAL 3 DESIGN
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: _buildMaterial3AppBar(colorScheme),
      body: _cartItems.isEmpty
          ? _buildEmptyCart(colorScheme)
          : _buildCartContent(colorScheme),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? _buildCheckoutBar(colorScheme)
          : null,
    );
  }

  /// * Build Material 3 app bar
  PreferredSizeWidget _buildMaterial3AppBar(ColorScheme colorScheme) {
    return AppBar(
      title: const Text(
        'Shopping Cart',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      actions: [
        if (_cartItems.isNotEmpty)
          TextButton.icon(
            onPressed: () => _showClearCartDialog(colorScheme),
            icon: const Icon(Icons.clear_all),
            label: const Text('Clear'),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  /// * Build cart content
  Widget _buildCartContent(ColorScheme colorScheme) {
    if (_cartItems.isEmpty) {
      return _buildEmptyCart(colorScheme);
    }

    return ListView.separated(
      key: const PageStorageKey('cart_items'),
      padding: const EdgeInsets.all(16),
      itemCount: _cartItems.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        // * Extra safety check
        if (index < 0 || index >= _cartItems.length) {
          return const SizedBox.shrink();
        }

        final item = _cartItems[index];
        return _buildCartItemCard(item, colorScheme);
      },
    );
  }

  /// * Build individual cart item card
  Widget _buildCartItemCard(CartItem item, ColorScheme colorScheme) {
    return Card(
      key: ValueKey(item.id),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // * Product image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(item.category),
                size: 40,
                color: colorScheme.primary,
              ),
            ),

            const SizedBox(width: 16),

            // * Product details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹${item.price.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // * Quantity controls
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton.filledTonal(
                      onPressed: () =>
                          _updateQuantity(item.id, item.quantity - 1),
                      icon: const Icon(Icons.remove, size: 18),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                    Container(
                      width: 40,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: () =>
                          _updateQuantity(item.id, item.quantity + 1),
                      icon: const Icon(Icons.add, size: 18),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(32, 32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () => _removeItem(item.id),
                  icon: const Icon(Icons.delete_outline, size: 16),
                  label: const Text('Remove'),
                  style: TextButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    minimumSize: const Size(80, 32),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// * Build empty cart state
  Widget _buildEmptyCart(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 24),
          Text(
            'Your cart is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some products to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  /// * Build checkout bottom bar
  Widget _buildCheckoutBar(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total (${_cartItems.length} items)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '₹${_totalPrice.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => _proceedToCheckout(),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: const Text(
                'Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * HELPER METHODS
  // ============================================================================

  /// * Get category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'seeds':
        return Icons.eco;
      case 'fertilizer':
        return Icons.grass;
      case 'nursery':
        return Icons.park;
      default:
        return Icons.inventory_2;
    }
  }

  /// * Show clear cart confirmation dialog
  void _showClearCartDialog(ColorScheme colorScheme) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
              _updateCartCount();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  /// * Proceed to checkout
  void _proceedToCheckout() {
    HapticFeedback.mediumImpact();

    // * TODO: Implement checkout flow
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

// ============================================================================
// * CART ITEM MODEL
// ============================================================================

/// * Cart item data model
class CartItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.imageUrl,
  });

  /// * Create copy with updated fields
  CartItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? category,
    String? imageUrl,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
