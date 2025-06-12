// ===================================================================
// * NOTIFICATION DATA MODEL
// * Purpose: Immutable notification data model for dashboard notifications
// * Features: System alerts, order updates, weather alerts
// * Security Level: MEDIUM - Contains user-specific notifications
// ===================================================================

// * NOTIFICATION TYPE ENUMERATION
enum NotificationType { system, order, weather, government, marketing, alert }

// * NOTIFICATION PRIORITY ENUMERATION
enum NotificationPriority { low, medium, high, urgent }

// * NOTIFICATION DATA MODEL
class NotificationData {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime timestamp;
  final bool isRead;
  final String? actionUrl;
  final String? imageUrl;
  final Map<String, dynamic>? metadata;

  const NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.timestamp,
    this.isRead = false,
    this.actionUrl,
    this.imageUrl,
    this.metadata,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      priority: NotificationPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => NotificationPriority.medium,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['isRead'] as bool? ?? false,
      actionUrl: json['actionUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  NotificationData copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? timestamp,
    bool? isRead,
    String? actionUrl,
    String? imageUrl,
    Map<String, dynamic>? metadata,
  }) {
    return NotificationData(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      actionUrl: actionUrl ?? this.actionUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
