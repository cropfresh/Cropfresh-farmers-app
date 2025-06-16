// ===================================================================
// * LOCATION STEP WIDGET
// * Purpose: Farm location collection step for registration
// * Features: Address input, PIN code validation, farmer ID generation
// * Security Level: MEDIUM - Handles location data
// ===================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'common/step_header_card.dart';
import '../utils/farm_form_validator.dart';
import '../farm_details_controller.dart';
import '../../../../core/theme/colors.dart';

/// * LOCATION STEP WIDGET
/// * Handles farm location input and farmer ID generation
class LocationStep extends StatefulWidget {
  final FarmDetailsController controller;
  final String fullName;
  final String experienceLevel;
  final TextEditingController manualAddressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController pincodeController;
  final VoidCallback onAddressChanged;

  const LocationStep({
    super.key,
    required this.controller,
    required this.fullName,
    required this.experienceLevel,
    required this.manualAddressController,
    required this.cityController,
    required this.stateController,
    required this.pincodeController,
    required this.onAddressChanged,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        child: Column(
          children: [
            // * WELCOME CARD
            _buildWelcomeCard(),
            const SizedBox(height: 24),

            // * SIMPLIFIED FARM LOCATION CARD
            _buildSimpleFarmLocationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 32,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${widget.fullName}! 👋',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Experience: ${widget.experienceLevel}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let's set up your farm profile",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // * SIMPLIFIED FARM LOCATION CARD
  Widget _buildSimpleFarmLocationCard() {
    return Card(
      elevation: 2,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * HEADER SECTION
            Row(
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
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
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
            ),
            const SizedBox(height: 24),

            // * FARM ADDRESS FORM
            _buildFarmAddressForm(),

            // * FARMER ID DISPLAY
            if (_hasValidManualAddress()) ...[
              const SizedBox(height: 24),
              _buildFarmerIdDisplay(),
            ],
          ],
        ),
      ),
    );
  }

  // * FARM ADDRESS FORM
  Widget _buildFarmAddressForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // * FARM ADDRESS FIELD
        TextFormField(
          controller: widget.manualAddressController,
          decoration: InputDecoration(
            labelText: 'Farm Address',
            hintText: 'House/Plot number, Street name, Area',
            prefixIcon: const Icon(Icons.home),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          maxLines: 2,
          validator: FarmFormValidator.validateAddress,
          onChanged: (_) => widget.onAddressChanged(),
        ),
        const SizedBox(height: 16),

        // * CITY AND STATE - RESPONSIVE ROW
        LayoutBuilder(
          builder: (context, constraints) {
            // * Use Column for smaller screens to prevent overflow
            if (constraints.maxWidth < 400) {
              return Column(
                children: [
                  _buildCityField(),
                  const SizedBox(height: 16),
                  _buildStateField(),
                ],
              );
            }
            // * Use Row for larger screens
            return Row(
              children: [
                Expanded(child: _buildCityField()),
                const SizedBox(width: 16),
                Expanded(child: _buildStateField()),
              ],
            );
          },
        ),
        const SizedBox(height: 16),

        // * PIN CODE FIELD
        SizedBox(
          width: 200,
          child: TextFormField(
            controller: widget.pincodeController,
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
            validator: FarmFormValidator.validatePincode,
            onChanged: (_) => widget.onAddressChanged(),
          ),
        ),
      ],
    );
  }

  // * CITY FIELD BUILDER
  Widget _buildCityField() {
    return TextFormField(
      controller: widget.cityController,
      decoration: InputDecoration(
        labelText: 'City/District',
        hintText: 'Enter city or district',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      validator: FarmFormValidator.validateCity,
      onChanged: (_) => widget.onAddressChanged(),
    );
  }

  // * STATE FIELD BUILDER
  Widget _buildStateField() {
    return TextFormField(
      controller: widget.stateController,
      decoration: InputDecoration(
        labelText: 'State',
        hintText: 'Enter state',
        prefixIcon: const Icon(Icons.map),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      validator: FarmFormValidator.validateState,
      onChanged: (_) => widget.onAddressChanged(),
    );
  }

  // * FARMER ID DISPLAY
  Widget _buildFarmerIdDisplay() {
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
          Container(
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getManualAddressString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // * FARMER ID CARD
          Container(
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
                      onPressed: _generateNewFarmerId,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.controller.farmerId.isNotEmpty
                        ? widget.controller.farmerId
                        : 'Generating...',
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
          ),
        ],
      ),
    );
  }

  // * HELPER METHODS
  bool _hasValidManualAddress() {
    return FarmFormValidator.hasValidManualAddress(
      address: widget.manualAddressController.text,
      city: widget.cityController.text,
      state: widget.stateController.text,
      pincode: widget.pincodeController.text,
    );
  }

  String _getManualAddressString() {
    return '${widget.manualAddressController.text.trim()}, ${widget.cityController.text.trim()}, ${widget.stateController.text.trim()} - ${widget.pincodeController.text.trim()}';
  }

  void _generateNewFarmerId() {
    if (_hasValidManualAddress()) {
      _updateControllerWithAddressData();
      widget.controller.generateFarmerId();
    }
  }

  void _updateControllerWithAddressData() {
    widget.controller.updateAddressField(
      'village',
      widget.manualAddressController.text.trim(),
    );
    widget.controller.updateAddressField(
      'district',
      widget.cityController.text.trim(),
    );
    widget.controller.updateAddressField(
      'state',
      widget.stateController.text.trim(),
    );
    widget.controller.updateAddressField(
      'pincode',
      widget.pincodeController.text.trim(),
    );
  }
}
