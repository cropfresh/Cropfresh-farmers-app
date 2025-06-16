// ===================================================================
// * IRRIGATION STEP WIDGET
// * Purpose: Irrigation system and water source collection step
// * Features: Irrigation method selection, water source, tips
// * Security Level: LOW - Irrigation information
// ===================================================================

import 'package:flutter/material.dart';
import 'common/step_header_card.dart';
import '../../../../core/theme/colors.dart';

/// * IRRIGATION STEP WIDGET
/// * Handles irrigation method and water source selection
class IrrigationStep extends StatefulWidget {
  final String selectedIrrigationType;
  final String selectedWaterSource;
  final Function(String) onIrrigationTypeChanged;
  final Function(String) onWaterSourceChanged;

  const IrrigationStep({
    super.key,
    required this.selectedIrrigationType,
    required this.selectedWaterSource,
    required this.onIrrigationTypeChanged,
    required this.onWaterSourceChanged,
  });

  @override
  State<IrrigationStep> createState() => _IrrigationStepState();
}

class _IrrigationStepState extends State<IrrigationStep> {
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
              title: 'Irrigation System',
              subtitle: 'How do you water your crops?',
              icon: Icons.water_drop,
              step: 4,
            ),
            const SizedBox(height: 24),

            // * IRRIGATION TYPE SECTION
            _buildIrrigationTypeSection(),
            const SizedBox(height: 24),

            // * WATER SOURCE SECTION
            _buildWaterSourceSection(),
            const SizedBox(height: 24),

            // * ADDITIONAL IRRIGATION INFO
            _buildAdditionalIrrigationInfo(),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildIrrigationTypeSection() {
    const irrigationTypes = [
      {
        'value': 'Drip Irrigation',
        'icon': Icons.water_drop,
        'description': 'Water-efficient drip system',
      },
      {
        'value': 'Sprinkler',
        'icon': Icons.shower,
        'description': 'Sprinkler irrigation system',
      },
      {
        'value': 'Flood Irrigation',
        'icon': Icons.waves,
        'description': 'Traditional flood irrigation',
      },
      {
        'value': 'Furrow Irrigation',
        'icon': Icons.timeline,
        'description': 'Channel-based irrigation',
      },
      {
        'value': 'Rain Fed',
        'icon': Icons.cloud,
        'description': 'Depends on rainfall',
      },
      {
        'value': 'Mixed',
        'icon': Icons.multiple_stop,
        'description': 'Multiple irrigation methods',
      },
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
                Icon(Icons.water, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Irrigation Method',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...irrigationTypes.map((type) {
              final isSelected = widget.selectedIrrigationType == type['value'];
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                child: RadioListTile<String>(
                  value: type['value'] as String,
                  groupValue: widget.selectedIrrigationType,
                  onChanged: (value) {
                    widget.onIrrigationTypeChanged(value!);
                  },
                  title: Row(
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color: isSelected
                            ? CropFreshColors.green30Primary
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              type['value'] as String,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? CropFreshColors.green30Primary
                                        : null,
                                  ),
                            ),
                            Text(
                              type['description'] as String,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  activeColor: CropFreshColors.green30Primary,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isSelected
                          ? CropFreshColors.green30Primary
                          : Theme.of(
                              context,
                            ).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  tileColor: isSelected
                      ? CropFreshColors.green30Container.withOpacity(0.3)
                      : null,
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaterSourceSection() {
    const waterSources = [
      {'value': 'Borewell', 'icon': Icons.water_damage},
      {'value': 'Canal', 'icon': Icons.water},
      {'value': 'River', 'icon': Icons.waves},
      {'value': 'Pond/Tank', 'icon': Icons.pool},
      {'value': 'Rainwater Harvesting', 'icon': Icons.cloud_queue},
      {'value': 'Government Supply', 'icon': Icons.business},
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
                Icon(Icons.source, color: CropFreshColors.green30Primary),
                const SizedBox(width: 8),
                Text(
                  'Water Source',
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
              children: waterSources.map((source) {
                final isSelected =
                    widget.selectedWaterSource == source['value'];
                return FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        source['icon'] as IconData,
                        size: 18,
                        color: isSelected
                            ? CropFreshColors.onGreen30
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(source['value'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    widget.onWaterSourceChanged(
                      selected ? source['value'] as String : '',
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

  Widget _buildAdditionalIrrigationInfo() {
    return Card(
      elevation: 1,
      color: CropFreshColors.background60Container,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.tips_and_updates,
                  color: CropFreshColors.orange10Primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Irrigation Tips',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CropFreshColors.orange10Primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '💧 Drip irrigation saves up to 50% water\n'
              '🌱 Choose irrigation method based on your crops\n'
              '⏰ Early morning watering reduces evaporation\n'
              '📱 CropFresh will help optimize your irrigation schedule',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
