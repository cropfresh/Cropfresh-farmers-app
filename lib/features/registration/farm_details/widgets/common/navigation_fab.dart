// ===================================================================
// * NAVIGATION FAB WIDGET
// * Purpose: Floating action button for step navigation
// * Features: Context-aware text, enabled state, step progression
// * Security Level: LOW - Navigation component only
// ===================================================================

import 'package:flutter/material.dart';

/// * NAVIGATION FLOATING ACTION BUTTON
/// * Context-aware navigation button for farm registration steps
class NavigationFAB extends StatelessWidget {
  final bool canContinue;
  final bool isLastStep;
  final VoidCallback? onPressed;

  const NavigationFAB({
    super.key,
    required this.canContinue,
    required this.isLastStep,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: FloatingActionButton.extended(
        onPressed: canContinue ? onPressed : null,
        backgroundColor: canContinue
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.surfaceVariant,
        foregroundColor: canContinue
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        elevation: canContinue ? 6 : 2,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isLastStep ? 'Complete' : 'Continue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Icon(isLastStep ? Icons.check_circle : Icons.arrow_forward),
          ],
        ),
      ),
    );
  }
}
