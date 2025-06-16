// ===================================================================
// * SUCCESS VIEW WIDGET
// * Purpose: Registration completion celebration screen
// * Features: Success animation, farm profile summary, navigation
// * Security Level: LOW - Display only
// ===================================================================

import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';

/// * SUCCESS VIEW WIDGET
/// * Displays registration completion with farm profile summary
class SuccessView extends StatelessWidget {
  final String fullName;
  final String farmerId;
  final String address;
  final String landArea;
  final String landUnit;
  final String ownership;
  final int selectedCropsCount;
  final String irrigationType;
  final String waterSource;
  final VoidCallback onContinuePressed;

  const SuccessView({
    super.key,
    required this.fullName,
    required this.farmerId,
    required this.address,
    required this.landArea,
    required this.landUnit,
    required this.ownership,
    required this.selectedCropsCount,
    required this.irrigationType,
    required this.waterSource,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // * SUCCESS ANIMATION/ICON
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: CropFreshColors.green30Container,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: CropFreshColors.green30Primary,
              ),
            ),
            const SizedBox(height: 32),

            // * SUCCESS MESSAGE
            Text(
              'Registration Complete! 🎉',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: CropFreshColors.green30Primary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 16),

            Text(
              'Welcome to CropFresh, $fullName!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 8),

            Text(
              'Your Farmer ID: $farmerId',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: CropFreshColors.green30Primary,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 32),

            // * COMPLETION SUMMARY CARD
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Farm Profile',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow(context, Icons.place, 'Location', address),
                    _buildSummaryRow(
                      context,
                      Icons.landscape,
                      'Land Area',
                      '$landArea $landUnit',
                    ),
                    _buildSummaryRow(
                      context,
                      Icons.verified_user,
                      'Ownership',
                      ownership,
                    ),
                    _buildSummaryRow(
                      context,
                      Icons.eco,
                      'Crops',
                      '$selectedCropsCount selected',
                    ),
                    _buildSummaryRow(
                      context,
                      Icons.water_drop,
                      'Irrigation',
                      irrigationType,
                    ),
                    _buildSummaryRow(
                      context,
                      Icons.source,
                      'Water Source',
                      waterSource,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // * CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onContinuePressed,
                icon: const Icon(Icons.home),
                label: const Text(
                  'Go to Dashboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CropFreshColors.green30Primary,
                  foregroundColor: CropFreshColors.onGreen30,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24), // * BOTTOM PADDING FOR SAFE AREA
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: CropFreshColors.green30Primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
