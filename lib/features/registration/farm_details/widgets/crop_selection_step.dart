// ===================================================================
// * CROP SELECTION STEP WIDGET
// * Purpose: Crop selection and management step
// * Features: Crop categories, multiple selection, crop summary
// * Security Level: LOW - Crop selection data
// ===================================================================

import 'package:flutter/material.dart';
import 'common/step_header_card.dart';
import '../models/crop.dart';
import '../../../../core/theme/colors.dart';

/// * CROP SELECTION STEP WIDGET
/// * Handles crop selection from categorized lists
class CropSelectionStep extends StatefulWidget {
  final Set<String> selectedCrops;
  final Function(String, bool) onCropSelectionChanged;

  const CropSelectionStep({
    super.key,
    required this.selectedCrops,
    required this.onCropSelectionChanged,
  });

  @override
  State<CropSelectionStep> createState() => _CropSelectionStepState();
}

class _CropSelectionStepState extends State<CropSelectionStep> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * STEP HEADER CARD
          StepHeaderCard(
            title: 'Crop Selection',
            subtitle: 'What crops do you grow?',
            icon: Icons.eco,
            step: 3,
          ),
          const SizedBox(height: 24),

          // * SELECTED CROPS SUMMARY
          if (widget.selectedCrops.isNotEmpty) ...[
            _buildSelectedCropsSummary(),
            const SizedBox(height: 24),
          ],

          // * CROP CATEGORIES
          _buildCropCategoriesGrid(),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildSelectedCropsSummary() {
    return Card(
      elevation: 2,
      color: CropFreshColors.green30Container,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Selected Crops (${widget.selectedCrops.length})',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CropFreshColors.onGreen30Container,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.selectedCrops.map((cropId) {
                final crop = CropData.defaultCrops.firstWhere(
                  (c) => c.id == cropId,
                  orElse: () => Crop(id: cropId, name: cropId, category: ''),
                );
                return Chip(
                  label: Text(crop.name),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () {
                    widget.onCropSelectionChanged(cropId, false);
                  },
                  backgroundColor: CropFreshColors.background60Container,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropCategoriesGrid() {
    final categories = CropData.getAllCategories();

    return Column(
      children: categories.map((category) {
        final categoryIcon = _getCategoryIcon(category);
        final categoryCrops = CropData.getCropsByCategory(category);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 1,
          child: ExpansionTile(
            leading: Icon(categoryIcon, color: CropFreshColors.green30Primary),
            title: Text(
              category,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${categoryCrops.length} crops available',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categoryCrops.map((crop) {
                    final isSelected = widget.selectedCrops.contains(crop.id);
                    return FilterChip(
                      selected: isSelected,
                      label: Text(crop.name),
                      onSelected: (selected) {
                        widget.onCropSelectionChanged(crop.id, selected);
                      },
                      backgroundColor: isSelected
                          ? CropFreshColors.green30Primary
                          : null,
                      selectedColor: CropFreshColors.green30Primary,
                      checkmarkColor: CropFreshColors.onGreen30,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cereals':
        return Icons.grain;
      case 'pulses':
        return Icons.circle;
      case 'vegetables':
        return Icons.local_grocery_store;
      case 'fruits':
        return Icons.apple;
      case 'spices':
        return Icons.local_florist;
      case 'cash crops':
        return Icons.attach_money;
      case 'oil seeds':
        return Icons.opacity;
      default:
        return Icons.eco;
    }
  }
}
