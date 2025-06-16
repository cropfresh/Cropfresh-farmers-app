// ===================================================================
// * FARM ADDRESS CARD WIDGET - MATERIAL 3 DESIGN
// * Purpose: Reusable card widget for farm address entry
// * Features: Manual address input with responsive design
// * Security Level: LOW - Handles address data only
// * Design: Material 3 with accessibility and overflow prevention
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// * FARM ADDRESS CARD WIDGET
/// * Clean, responsive design for manual address entry
class FarmAddressCard extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final VoidCallback onAddressChanged;
  final bool showFarmerId;
  final String farmerId;
  final VoidCallback onRefreshFarmerId;

  const FarmAddressCard({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.onAddressChanged,
    this.showFarmerId = false,
    this.farmerId = '',
    required this.onRefreshFarmerId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * HEADER SECTION
            _buildHeader(context),
            const SizedBox(height: 24),

            // * FARM ADDRESS FORM
            _buildAddressForm(context),

            // * FARMER ID DISPLAY
            if (showFarmerId) ...[
              const SizedBox(height: 24),
              _buildFarmerIdDisplay(context),
            ],
          ],
        ),
      ),
    );
  }

  // * HEADER SECTION
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.location_on,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Farm Location',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Enter your farm address details',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // * FARM ADDRESS FORM
  Widget _buildAddressForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * FARM ADDRESS FIELD
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Farm Address',
            hintText: 'House/Plot number, Street name, Area',
            prefixIcon: const Icon(Icons.home),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your farm address';
            }
            return null;
          },
          onChanged: (_) => onAddressChanged(),
        ),
        const SizedBox(height: 16),

        // * CITY AND STATE - RESPONSIVE LAYOUT
        LayoutBuilder(
          builder: (context, constraints) {
            // * Use Column for smaller screens to prevent overflow
            if (constraints.maxWidth < 400) {
              return Column(
                children: [
                  _buildCityField(context),
                  const SizedBox(height: 16),
                  _buildStateField(context),
                ],
              );
            }
            // * Use Row for larger screens
            return Row(
              children: [
                Expanded(child: _buildCityField(context)),
                const SizedBox(width: 16),
                Expanded(child: _buildStateField(context)),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // * PIN CODE FIELD
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: pincodeController,
            decoration: InputDecoration(
              labelText: 'PIN Code',
              hintText: '123456',
              prefixIcon: const Icon(Icons.pin_drop),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceVariant,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Enter PIN code';
              }
              if (value.length != 6) {
                return 'PIN must be 6 digits';
              }
              return null;
            },
            onChanged: (_) => onAddressChanged(),
          ),
        ),
      ],
    );
  }

  // * CITY FIELD BUILDER
  Widget _buildCityField(BuildContext context) {
    return TextFormField(
      controller: cityController,
      decoration: InputDecoration(
        labelText: 'City/District',
        hintText: 'Enter city or district',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter city/district';
        }
        return null;
      },
      onChanged: (_) => onAddressChanged(),
    );
  }

  // * STATE FIELD BUILDER
  Widget _buildStateField(BuildContext context) {
    return TextFormField(
      controller: stateController,
      decoration: InputDecoration(
        labelText: 'State',
        hintText: 'Enter state',
        prefixIcon: const Icon(Icons.map),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Enter state';
        }
        return null;
      },
      onChanged: (_) => onAddressChanged(),
    );
  }

  // * FARMER ID DISPLAY
  Widget _buildFarmerIdDisplay(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * SUCCESS INDICATOR
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Address Confirmed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // * ADDRESS DISPLAY
          _buildAddressDisplay(context),
          const SizedBox(height: 16),

          // * FARMER ID CARD
          _buildFarmerIdCard(context),
        ],
      ),
    );
  }

  // * ADDRESS DISPLAY
  Widget _buildAddressDisplay(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.place,
                color: Theme.of(context).colorScheme.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Farm Address:',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getAddressString(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // * FARMER ID CARD
  Widget _buildFarmerIdCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.badge,
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your Farmer ID',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              // * REFRESH BUTTON
              IconButton(
                onPressed: onRefreshFarmerId,
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                tooltip: 'Generate New ID',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              farmerId.isNotEmpty ? farmerId : 'Generating...',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // * HELPER METHODS
  String _getAddressString() {
    return '${addressController.text.trim()}, ${cityController.text.trim()}, ${stateController.text.trim()} - ${pincodeController.text.trim()}';
  }
}
