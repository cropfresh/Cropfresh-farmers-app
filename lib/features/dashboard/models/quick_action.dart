// ===================================================================
// * QUICK ACTION MODEL
// * Purpose: Quick action data model for dashboard quick actions grid
// * Features: Action definitions, icons, navigation
// * Security Level: LOW - Public action definitions
// ===================================================================

import 'package:flutter/material.dart';

// * QUICK ACTION MODEL
class QuickAction {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String route;
  final bool isEnabled;
  final bool requiresAuth;
  final String? badge;
  final Map<String, dynamic>? params;

  const QuickAction({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    this.isEnabled = true,
    this.requiresAuth = false,
    this.badge,
    this.params,
  });

  QuickAction copyWith({
    String? id,
    String? title,
    String? description,
    IconData? icon,
    String? route,
    bool? isEnabled,
    bool? requiresAuth,
    String? badge,
    Map<String, dynamic>? params,
  }) {
    return QuickAction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      route: route ?? this.route,
      isEnabled: isEnabled ?? this.isEnabled,
      requiresAuth: requiresAuth ?? this.requiresAuth,
      badge: badge ?? this.badge,
      params: params ?? this.params,
    );
  }
}
