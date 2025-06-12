// ===================================================================
// * FARM DETAILS SCREEN
// * Purpose: Comprehensive farm information collection screen
// * Features: GPS location, land area, ownership, crops, irrigation
// * UI Components: Map integration, multi-select crops, form validation
// * Security Level: HIGH - Handles sensitive farm data
// ===================================================================

import 'package:flutter/material.dart';
import 'farm_details_controller.dart';
import 'models/farm_details.dart';
import 'models/crop.dart';

/// * FARM DETAILS SCREEN
/// * Main screen for collecting detailed farm information
class FarmDetailsScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String farmerId;
  final String experienceLevel;

  const FarmDetailsScreen({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.farmerId,
    required this.experienceLevel,
  });

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  late final FarmDetailsController _controller;
  final _formKey = GlobalKey<FormState>();
  final _landAreaController = TextEditingController();
  final _manualAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = FarmDetailsController();
    _controller.initializeWithBasicInfo(
      phoneNumber: widget.phoneNumber,
      fullName: widget.fullName,
      farmerId: widget.farmerId,
      experienceLevel: widget.experienceLevel,
    );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _landAreaController.dispose();
    _manualAddressController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Details'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBody() {
    if (_controller.state == FarmDetailsState.success) {
      return _buildSuccessView();
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildLocationSection(),
            const SizedBox(height: 16),
            _buildLandDetailsSection(),
            const SizedBox(height: 16),
            _buildCropSelectionSection(),
            const SizedBox(height: 16),
            _buildIrrigationSection(),
            const SizedBox(height: 100), // Space for bottom bar
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.fullName}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please provide your farm details to complete registration.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('Farmer ID: ${widget.farmerId}'),
                const SizedBox(width: 16),
                Icon(Icons.star, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text('Level: ${widget.experienceLevel}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Farm Location',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // * GPS LOCATION BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _controller.isLocationLoading
                    ? null
                    : () => _controller.getCurrentLocation(),
                icon: _controller.isLocationLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.gps_fixed),
                label: Text(
                  _controller.isLocationLoading
                      ? 'Getting Location...'
                      : 'Get GPS Location',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),

            // * LOCATION DISPLAY
            if (_controller.hasLocation) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Location Detected',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(_controller.address),
                    const SizedBox(height: 4),
                    Text(
                      'Lat: ${_controller.latitude?.toStringAsFixed(6)}, '
                      'Lng: ${_controller.longitude?.toStringAsFixed(6)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],

            // * MANUAL ADDRESS INPUT
            const SizedBox(height: 16),
            TextFormField(
              controller: _manualAddressController,
              decoration: const InputDecoration(
                labelText: 'Manual Address (Optional)',
                hintText: 'Enter address if GPS is not accurate',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit_location),
              ),
              maxLines: 2,
              onChanged: _controller.updateManualAddress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandDetailsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.landscape, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Land Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // * LAND AREA INPUT
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _landAreaController,
                    decoration: const InputDecoration(
                      labelText: 'Land Area *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.square_foot),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Land area is required';
                      }
                      final area = double.tryParse(value);
                      if (area == null || area <= 0) {
                        return 'Enter valid area';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final area = double.tryParse(value) ?? 0.0;
                      _controller.updateLandArea(area);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _controller.landAreaUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'hectares',
                        child: Text('Hectares'),
                      ),
                      DropdownMenuItem(value: 'acres', child: Text('Acres')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        _controller.updateLandAreaUnit(value);
                      }
                    },
                  ),
                ),
              ],
            ),

            // * LAND AREA REFERENCE
            if (_controller.landAreaReference.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _controller.landAreaReference,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // * OWNERSHIP TYPE
            DropdownButtonFormField<String>(
              value: _controller.ownershipType.isEmpty
                  ? null
                  : _controller.ownershipType,
              decoration: const InputDecoration(
                labelText: 'Ownership Type *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
              items: OwnershipType.values.map((type) {
                return DropdownMenuItem(
                  value: type.displayName,
                  child: Text(type.displayName),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ownership type is required';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) {
                  _controller.updateOwnershipType(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropSelectionSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.grass, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  'Primary Crops',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_controller.selectedCropIds.isNotEmpty)
                  TextButton(
                    onPressed: _controller.clearSelectedCrops,
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select the crops you primarily grow (${_controller.selectedCropIds.length} selected)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            if (_controller.isCropsLoading)
              const Center(child: CircularProgressIndicator())
            else
              _buildCropGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildCropGrid() {
    final categories = _controller.getAllCropCategories();

    return Column(
      children: categories.map((category) {
        final crops = _controller.getCropsByCategory(category);
        return ExpansionTile(
          title: Text(category),
          initiallyExpanded: category == 'Cereals', // Expand first category
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: crops.map((crop) {
                final isSelected = _controller.selectedCropIds.contains(
                  crop.id,
                );
                return FilterChip(
                  label: Text(crop.name),
                  selected: isSelected,
                  onSelected: (_) => _controller.toggleCropSelection(crop.id),
                  selectedColor: Colors.green.shade100,
                  checkmarkColor: Colors.green.shade700,
                );
              }).toList(),
            ),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildIrrigationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.water_drop, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  'Irrigation Details',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // * IRRIGATION TYPE
            DropdownButtonFormField<String>(
              value: _controller.irrigationType.isEmpty
                  ? null
                  : _controller.irrigationType,
              decoration: const InputDecoration(
                labelText: 'Irrigation Type *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.water),
              ),
              items: IrrigationType.values.map((type) {
                return DropdownMenuItem(
                  value: type.displayName,
                  child: Text(type.displayName),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Irrigation type is required';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) {
                  _controller.updateIrrigationType(value);
                }
              },
            ),

            const SizedBox(height: 16),

            // * IRRIGATION SOURCE
            DropdownButtonFormField<String>(
              value: _controller.irrigationSource.isEmpty
                  ? null
                  : _controller.irrigationSource,
              decoration: const InputDecoration(
                labelText: 'Water Source *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.opacity),
              ),
              items: IrrigationSource.values.map((source) {
                return DropdownMenuItem(
                  value: source.displayName,
                  child: Text(source.displayName),
                );
              }).toList(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Water source is required';
                }
                return null;
              },
              onChanged: (value) {
                if (value != null) {
                  _controller.updateIrrigationSource(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // * ERROR MESSAGE
          if (_controller.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _controller.errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // * SUBMIT BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _controller.state == FarmDetailsState.submitting
                  ? null
                  : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _controller.state == FarmDetailsState.submitting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Submitting...'),
                      ],
                    )
                  : const Text(
                      'Complete Registration',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Registration Complete!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.green.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your farm details have been successfully submitted. '
              'Welcome to CropFresh!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to main app or dashboard
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Continue to App'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _controller.submitFarmDetails();
    }
  }
}
