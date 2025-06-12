// ===================================================================
// * USER PROFILE MODEL
// * Purpose: Immutable user data model for authenticated users
// * Contains: Basic info, farm details, session data
// * Security Level: HIGH - Contains sensitive user information
// ===================================================================

/// * USER PROFILE MODEL
/// * Immutable data model representing an authenticated farmer
class UserProfile {
  final String phoneNumber;
  final String fullName;
  final String farmerId;
  final String experienceLevel;
  final DateTime? lastLoginTime;
  final bool isActive;

  // * Optional farm details (from registration)
  final double? latitude;
  final double? longitude;
  final String? address;
  final String? village;
  final String? district;
  final String? addressState;
  final String? pincode;
  final double? landArea;
  final String? landAreaUnit;
  final String? ownershipType;
  final List<String>? primaryCrops;
  final String? irrigationType;
  final String? irrigationSource;

  const UserProfile({
    required this.phoneNumber,
    required this.fullName,
    required this.farmerId,
    required this.experienceLevel,
    this.lastLoginTime,
    this.isActive = true,
    this.latitude,
    this.longitude,
    this.address,
    this.village,
    this.district,
    this.addressState,
    this.pincode,
    this.landArea,
    this.landAreaUnit,
    this.ownershipType,
    this.primaryCrops,
    this.irrigationType,
    this.irrigationSource,
  });

  // ============================================================================
  // * FACTORY CONSTRUCTORS
  // ============================================================================

  /// * Create UserProfile from JSON data (API response or local storage)
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      phoneNumber: json['phoneNumber'] as String,
      fullName: json['fullName'] as String,
      farmerId: json['farmerId'] as String,
      experienceLevel: json['experienceLevel'] as String,
      lastLoginTime: json['lastLoginTime'] != null
          ? DateTime.parse(json['lastLoginTime'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      address: json['address'] as String?,
      village: json['village'] as String?,
      district: json['district'] as String?,
      addressState: json['addressState'] as String?,
      pincode: json['pincode'] as String?,
      landArea: json['landArea'] as double?,
      landAreaUnit: json['landAreaUnit'] as String?,
      ownershipType: json['ownershipType'] as String?,
      primaryCrops: json['primaryCrops'] != null
          ? List<String>.from(json['primaryCrops'] as List)
          : null,
      irrigationType: json['irrigationType'] as String?,
      irrigationSource: json['irrigationSource'] as String?,
    );
  }

  /// * Create minimal UserProfile (for basic authentication)
  factory UserProfile.minimal({
    required String phoneNumber,
    required String fullName,
    required String farmerId,
    required String experienceLevel,
  }) {
    return UserProfile(
      phoneNumber: phoneNumber,
      fullName: fullName,
      farmerId: farmerId,
      experienceLevel: experienceLevel,
      lastLoginTime: DateTime.now(),
    );
  }

  // ============================================================================
  // * JSON SERIALIZATION
  // ============================================================================

  /// * Convert UserProfile to JSON for storage/API calls
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'farmerId': farmerId,
      'experienceLevel': experienceLevel,
      'lastLoginTime': lastLoginTime?.toIso8601String(),
      'isActive': isActive,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'village': village,
      'district': district,
      'addressState': addressState,
      'pincode': pincode,
      'landArea': landArea,
      'landAreaUnit': landAreaUnit,
      'ownershipType': ownershipType,
      'primaryCrops': primaryCrops,
      'irrigationType': irrigationType,
      'irrigationSource': irrigationSource,
    };
  }

  // ============================================================================
  // * COMPUTED PROPERTIES
  // ============================================================================

  /// * Get formatted display name for UI
  String get displayName => fullName;

  /// * Get formatted phone number for display
  String get formattedPhoneNumber {
    if (phoneNumber.length >= 10) {
      final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
      if (cleaned.length >= 10) {
        final lastTen = cleaned.substring(cleaned.length - 10);
        return '+91 ${lastTen.substring(0, 5)} ${lastTen.substring(5)}';
      }
    }
    return phoneNumber;
  }

  /// * Get formatted address for display
  String get formattedAddress {
    final parts = <String>[];
    if (village != null && village!.isNotEmpty) parts.add(village!);
    if (district != null && district!.isNotEmpty) parts.add(district!);
    if (addressState != null && addressState!.isNotEmpty)
      parts.add(addressState!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);

    return parts.isNotEmpty
        ? parts.join(', ')
        : (address ?? 'Address not available');
  }

  /// * Get experience level display text
  String get experienceLevelDisplay {
    switch (experienceLevel.toLowerCase()) {
      case 'beginner':
        return 'Beginner Farmer';
      case 'intermediate':
        return 'Experienced Farmer';
      case 'advanced':
        return 'Expert Farmer';
      default:
        return experienceLevel;
    }
  }

  /// * Check if user has complete farm details
  bool get hasCompleteFarmDetails {
    return latitude != null &&
        longitude != null &&
        landArea != null &&
        ownershipType != null &&
        primaryCrops != null &&
        primaryCrops!.isNotEmpty;
  }

  /// * Get primary crops as comma-separated string
  String get primaryCropsDisplay {
    if (primaryCrops == null || primaryCrops!.isEmpty) {
      return 'No crops specified';
    }
    return primaryCrops!.join(', ');
  }

  // ============================================================================
  // * OBJECT METHODS
  // ============================================================================

  /// * Create a copy with updated values
  UserProfile copyWith({
    String? phoneNumber,
    String? fullName,
    String? farmerId,
    String? experienceLevel,
    DateTime? lastLoginTime,
    bool? isActive,
    double? latitude,
    double? longitude,
    String? address,
    String? village,
    String? district,
    String? addressState,
    String? pincode,
    double? landArea,
    String? landAreaUnit,
    String? ownershipType,
    List<String>? primaryCrops,
    String? irrigationType,
    String? irrigationSource,
  }) {
    return UserProfile(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      farmerId: farmerId ?? this.farmerId,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      lastLoginTime: lastLoginTime ?? this.lastLoginTime,
      isActive: isActive ?? this.isActive,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      village: village ?? this.village,
      district: district ?? this.district,
      addressState: addressState ?? this.addressState,
      pincode: pincode ?? this.pincode,
      landArea: landArea ?? this.landArea,
      landAreaUnit: landAreaUnit ?? this.landAreaUnit,
      ownershipType: ownershipType ?? this.ownershipType,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      irrigationType: irrigationType ?? this.irrigationType,
      irrigationSource: irrigationSource ?? this.irrigationSource,
    );
  }

  /// * Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.phoneNumber == phoneNumber &&
        other.fullName == fullName &&
        other.farmerId == farmerId &&
        other.experienceLevel == experienceLevel &&
        other.lastLoginTime == lastLoginTime &&
        other.isActive == isActive;
  }

  /// * Hash code for object comparison
  @override
  int get hashCode {
    return Object.hash(
      phoneNumber,
      fullName,
      farmerId,
      experienceLevel,
      lastLoginTime,
      isActive,
    );
  }

  /// * String representation for debugging
  @override
  String toString() {
    return 'UserProfile(phoneNumber: $phoneNumber, fullName: $fullName, farmerId: $farmerId, experienceLevel: $experienceLevel)';
  }
}
