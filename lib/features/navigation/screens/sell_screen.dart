// ===================================================================
// * SELL SCREEN
// * Purpose: Create new listings to sell produce
// * Features: Product form, photo upload, pricing, location
// * State Management: StatefulWidget with form validation
// * Security Level: HIGH - Financial transaction data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/colors.dart';
import '../../login/models/user_profile.dart';

/// * SELL SCREEN
/// * Create new produce listings for sale
class SellScreen extends StatefulWidget {
  final UserProfile userProfile;
  final ScrollController? scrollController;

  const SellScreen({
    super.key,
    required this.userProfile,
    this.scrollController,
  });

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  // ============================================================================
  // * FORM STATE
  // ============================================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * Form controllers
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // * Form state
  String _selectedCategory = 'Fruits';
  String _selectedUnit = 'kg';
  String _selectedQuality = 'Grade A';
  bool _isOrganic = false;
  bool _isFormValid = false;

  // * Available options
  final List<String> _categories = [
    'Fruits',
    'Vegetables',
    'Grains',
    'Pulses',
    'Spices',
    'Other',
  ];

  final List<String> _units = ['kg', 'quintal', 'ton', 'piece', 'dozen', 'bag'];

  final List<String> _qualityOptions = [
    'Grade A',
    'Grade B',
    'Grade C',
    'Premium',
    'Standard',
  ];

  @override
  void initState() {
    super.initState();
    _initializeForm();
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// * Initialize form with user data
  void _initializeForm() {
    // * Pre-fill location if available
    if (widget.userProfile.formattedAddress.isNotEmpty &&
        widget.userProfile.formattedAddress != 'Address not available') {
      _locationController.text = widget.userProfile.formattedAddress;
    }
  }

  // ============================================================================
  // * BUILD METHODS
  // ============================================================================

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 700;

    return Column(
      children: [
        // * Header with handle
        _buildHeader(isSmallScreen),

        // * Form content
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Form(
              key: _formKey,
              onChanged: _validateForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // * Product details section
                  _buildSectionTitle('Product Details', isSmallScreen),
                  const SizedBox(height: 16),
                  _buildProductDetailsSection(isSmallScreen),

                  const SizedBox(height: 24),

                  // * Pricing section
                  _buildSectionTitle('Pricing & Quantity', isSmallScreen),
                  const SizedBox(height: 16),
                  _buildPricingSection(isSmallScreen),

                  const SizedBox(height: 24),

                  // * Additional info section
                  _buildSectionTitle('Additional Information', isSmallScreen),
                  const SizedBox(height: 16),
                  _buildAdditionalInfoSection(isSmallScreen),

                  const SizedBox(height: 24),

                  // * Photos section
                  _buildSectionTitle('Product Photos', isSmallScreen),
                  const SizedBox(height: 16),
                  _buildPhotosSection(isSmallScreen),

                  const SizedBox(height: 32),

                  // * Submit button
                  _buildSubmitButton(isSmallScreen),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// * Build header with drag handle
  Widget _buildHeader(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, isSmallScreen ? 16 : 20),
      child: Column(
        children: [
          // * Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: CropFreshColors.onBackground60Tertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 16),

          // * Title and close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sell Your Produce',
                style: TextStyle(
                  fontSize: isSmallScreen ? 20 : 24,
                  fontWeight: FontWeight.w600,
                  color: CropFreshColors.onBackground60,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: CropFreshColors.onBackground60Tertiary,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// * Build section title
  Widget _buildSectionTitle(String title, bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        fontSize: isSmallScreen ? 16 : 18,
        fontWeight: FontWeight.w600,
        color: CropFreshColors.onBackground60,
      ),
    );
  }

  /// * Build product details section
  Widget _buildProductDetailsSection(bool isSmallScreen) {
    return Column(
      children: [
        // * Product name
        TextFormField(
          controller: _productNameController,
          decoration: InputDecoration(
            labelText: 'Product Name',
            hintText: 'e.g., Fresh Tomatoes',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(Icons.eco, color: CropFreshColors.green30Primary),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter product name';
            }
            return null;
          },
        ),

        const SizedBox(height: 16),

        // * Category dropdown
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: InputDecoration(
            labelText: 'Category',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(
              Icons.category,
              color: CropFreshColors.green30Primary,
            ),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem(value: category, child: Text(category));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),

        const SizedBox(height: 16),

        // * Quality dropdown
        DropdownButtonFormField<String>(
          value: _selectedQuality,
          decoration: InputDecoration(
            labelText: 'Quality Grade',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(
              Icons.star,
              color: CropFreshColors.orange10Primary,
            ),
          ),
          items: _qualityOptions.map((quality) {
            return DropdownMenuItem(value: quality, child: Text(quality));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedQuality = value!;
            });
          },
        ),
      ],
    );
  }

  /// * Build pricing section
  Widget _buildPricingSection(bool isSmallScreen) {
    return Column(
      children: [
        // * Quantity and unit row
        Row(
          children: [
            // * Quantity
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: '100',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.inventory,
                    color: CropFreshColors.green30Primary,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter quantity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Invalid number';
                  }
                  return null;
                },
              ),
            ),

            const SizedBox(width: 16),

            // * Unit
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _units.map((unit) {
                  return DropdownMenuItem(value: unit, child: Text(unit));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUnit = value!;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // * Price per unit
        TextFormField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
          decoration: InputDecoration(
            labelText: 'Price per $_selectedUnit',
            hintText: '₹50',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(
              Icons.currency_rupee,
              color: CropFreshColors.orange10Primary,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter price';
            }
            if (double.tryParse(value) == null) {
              return 'Invalid price';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// * Build additional info section
  Widget _buildAdditionalInfoSection(bool isSmallScreen) {
    return Column(
      children: [
        // * Organic checkbox
        CheckboxListTile(
          value: _isOrganic,
          onChanged: (value) {
            setState(() {
              _isOrganic = value ?? false;
            });
          },
          title: const Text('Organic Product'),
          subtitle: const Text('Check if this is organically grown'),
          activeColor: CropFreshColors.green30Primary,
          contentPadding: EdgeInsets.zero,
        ),

        const SizedBox(height: 16),

        // * Description
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            hintText: 'Describe your product, growing methods, etc.',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(
              Icons.description,
              color: CropFreshColors.green30Primary,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // * Location
        TextFormField(
          controller: _locationController,
          decoration: InputDecoration(
            labelText: 'Pickup Location',
            hintText: 'Where buyers can collect the produce',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            prefixIcon: Icon(
              Icons.location_on,
              color: CropFreshColors.orange10Primary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.my_location,
                color: CropFreshColors.green30Primary,
              ),
              onPressed: _getCurrentLocation,
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter pickup location';
            }
            return null;
          },
        ),
      ],
    );
  }

  /// * Build photos section
  Widget _buildPhotosSection(bool isSmallScreen) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(
          color: CropFreshColors.onBackground60Tertiary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: _addPhotos,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo,
              size: 40,
              color: CropFreshColors.green30Primary,
            ),
            const SizedBox(height: 8),
            Text(
              'Add Product Photos',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: CropFreshColors.onBackground60,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Photos help buyers trust your product',
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: CropFreshColors.onBackground60Secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// * Build submit button
  Widget _buildSubmitButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormValid ? _submitListing : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: CropFreshColors.orange10Primary,
          foregroundColor: CropFreshColors.onOrange10,
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 14 : 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.publish, size: isSmallScreen ? 18 : 20),
            const SizedBox(width: 8),
            Text(
              'Create Listing',
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // * ACTION METHODS
  // ============================================================================

  /// * Validate form
  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  /// * Get current location
  void _getCurrentLocation() {
    // * Mock implementation - replace with actual location service
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Location service coming soon...'),
        backgroundColor: CropFreshColors.orange10Primary,
      ),
    );
  }

  /// * Add photos
  void _addPhotos() {
    // * Mock implementation - replace with actual image picker
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Photo upload coming soon...'),
        backgroundColor: CropFreshColors.green30Primary,
      ),
    );
  }

  /// * Submit listing
  void _submitListing() {
    if (_formKey.currentState?.validate() ?? false) {
      // * Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Listing created successfully!'),
          backgroundColor: CropFreshColors.successPrimary,
        ),
      );

      // * Close the modal
      Navigator.of(context).pop();

      // * Here you would typically:
      // * 1. Collect all form data
      // * 2. Upload photos
      // * 3. Submit to API
      // * 4. Navigate to listing details or orders screen
    }
  }
}
