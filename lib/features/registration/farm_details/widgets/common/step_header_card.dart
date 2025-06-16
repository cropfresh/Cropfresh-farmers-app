// ===================================================================
// * STEP HEADER CARD WIDGET
// * Purpose: Reusable header component for farm registration steps
// * Features: Material 3 design, consistent styling, icon support
// * Security Level: LOW - UI component only
// ===================================================================

import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';

/// * REUSABLE STEP HEADER CARD
/// * Common header component used across all farm registration steps
class StepHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int step;

  const StepHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: CropFreshColors.green30Container,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: CropFreshColors.green30Primary,
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CropFreshColors.onGreen30Container,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CropFreshColors.onGreen30Container.withOpacity(
                        0.8,
                      ),
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
}
