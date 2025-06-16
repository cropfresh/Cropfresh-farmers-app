// ===================================================================
// * LAND DETAILS STEP WIDGET
// * Purpose: Land ownership and area collection step
// * Features: Land area input, ownership type, soil type, land usage
// * Security Level: LOW - Basic land information
// ===================================================================

import 'package:flutter/material.dart';
import 'common/step_header_card.dart';
import '../utils/farm_form_validator.dart';
import '../../../../core/theme/colors.dart';

/// * LAND DETAILS STEP WIDGET
/// * Handles land area, ownership, and usage information
class LandDetailsStep extends StatefulWidget {
  final TextEditingController landAreaController;
  final String selectedOwnership;
  final String selectedLandUnit;
  final String selectedSoilType;
  final Set<String> selectedLandUsage;
  final Function(String) onOwnershipChanged;
  final Function(String) onLandUnitChanged;
  final Function(String) onSoilTypeChanged;
  final Function(String, bool) onLandUsageChanged;

  const LandDetailsStep({
    super.key,
    required this.landAreaController,
    required this.selectedOwnership,
    required this.selectedLandUnit,
    required this.selectedSoilType,
    required this.selectedLandUsage,
    required this.onOwnershipChanged,
    required this.onLandUnitChanged,
    required this.onSoilTypeChanged,
    required this.onLandUsageChanged,
  });

  @override
  State<LandDetailsStep> createState() => _LandDetailsStepState();
}

class _LandDetailsStepState extends State<LandDetailsStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // * STEP HEADER CARD
            StepHeaderCard(
              title: 'Land Details',
              subtitle: 'Tell us about your farm land',
              icon: Icons.landscape,
              step: 2,
            ),
            const SizedBox(height: 24),

            // * LAND AREA SECTION
            _buildLandAreaSection(),
            const SizedBox(height: 24),

            // * OWNERSHIP TYPE SECTION
            _buildOwnershipSection(),
            const SizedBox(height: 24),

            // * SOIL TYPE SECTION (Optional)
            _buildSoilTypeSection(),
            const SizedBox(height: 24),

            // * LAND USAGE SECTION
            _buildLandUsageSection(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildLandAreaSection() {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.straighten, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Land Area',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // * RESPONSIVE LAYOUT FOR LAND AREA INPUT
            Column(
              children: [
                // * LAND AREA INPUT FIELD
                TextFormField(
                  controller: widget.landAreaController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Total Land Area',
                    hintText: 'Enter area',
                    prefixIcon: const Icon(Icons.crop_landscape),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  validator: FarmFormValidator.validateLandArea,
                ),
                const SizedBox(height: 16),
                // * UNIT SELECTION BUTTONS
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'acres', label: Text('Acres')),
                      ButtonSegment(value: 'hectares', label: Text('Hectares')),
                    ],
                    selected: {widget.selectedLandUnit},
                    onSelectionChanged: (Set<String> selection) {
                      widget.onLandUnitChanged(selection.first);
                    },
                    style: SegmentedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      maximumSize: const Size(double.infinity, 48),
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

  Widget _buildOwnershipSection() {
    const ownershipTypes = [
      {'value': 'Owned', 'label': 'Owned', 'icon': Icons.home},
      {'value': 'Leased', 'label': 'Leased', 'icon': Icons.assignment},
      {'value': 'Rented', 'label': 'Rented', 'icon': Icons.receipt_long},
      {'value': 'Shared', 'label': 'Shared', 'icon': Icons.people},
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: CropFreshColors.green30Primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Land Ownership',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ownershipTypes.map((type) {
                final isSelected = widget.selectedOwnership == type['value'];
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? CropFreshColors.onGreen30
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(type['label'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    widget.onOwnershipChanged(type['value'] as String);
                  },
                  backgroundColor: isSelected
                      ? CropFreshColors.green30Primary
                      : null,
                  selectedColor: CropFreshColors.green30Primary,
                  checkmarkColor: CropFreshColors.onGreen30,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoilTypeSection() {
    const soilTypes = [
      'Clay',
      'Sandy',
      'Loamy',
      'Black Soil',
      'Red Soil',
      'Alluvial',
      'Other',
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.terrain, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Soil Type (Optional)',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select your primary soil type if known',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: soilTypes.map((soil) {
                final isSelected = widget.selectedSoilType == soil;
                return FilterChip(
                  selected: isSelected,
                  label: Text(soil),
                  onSelected: (selected) {
                    widget.onSoilTypeChanged(selected ? soil : '');
                  },
                  backgroundColor: isSelected
                      ? CropFreshColors.green30Primary
                      : null,
                  selectedColor: CropFreshColors.green30Primary,
                  checkmarkColor: CropFreshColors.onGreen30,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandUsageSection() {
    const landUsages = [
      {'value': 'Crop Production', 'icon': Icons.agriculture},
      {'value': 'Livestock', 'icon': Icons.pets},
      {'value': 'Mixed Farming', 'icon': Icons.diversity_3},
      {'value': 'Horticulture', 'icon': Icons.park},
      {'value': 'Aquaculture', 'icon': Icons.water},
    ];

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.category, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Land Usage',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Select all that apply to your farm',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: landUsages.map((usage) {
                final isSelected = widget.selectedLandUsage.contains(
                  usage['value'],
                );
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        usage['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? CropFreshColors.onGreen30
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(usage['value'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    widget.onLandUsageChanged(
                      usage['value'] as String,
                      selected,
                    );
                  },
                  backgroundColor: isSelected
                      ? CropFreshColors.green30Primary
                      : null,
                  selectedColor: CropFreshColors.green30Primary,
                  checkmarkColor: CropFreshColors.onGreen30,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
