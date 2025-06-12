// ===================================================================
// * FARM DETAILS MODEL
// * Purpose: Data model for farmer's farm information
// * Used for: API requests, local storage, and form validation
// * Security Level: MEDIUM - Contains farm location data
// ===================================================================

/// * FARM DETAILS DATA MODEL
/// * Contains all farm-related information for registration
class FarmDetails {
  // * Basic farmer info from previous steps
  final String phoneNumber;
  final String fullName;
  final String farmerId;
  final String experienceLevel;

  // * Farm location details
  final double latitude;
  final double longitude;
  final String address;
  final String? manualAddress;

  // * Land information
  final double landArea;
  final String landAreaUnit; // 'hectares' or 'acres'
  final String ownershipType;

  // * Crop information
  final List<String> primaryCrops;

  // * Irrigation details
  final String irrigationType;
  final String irrigationSource;

  // * Metadata
  final bool isOfflineData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FarmDetails({
    required this.phoneNumber,
    required this.fullName,
    required this.farmerId,
    required this.experienceLevel,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.manualAddress,
    required this.landArea,
    required this.landAreaUnit,
    required this.ownershipType,
    required this.primaryCrops,
    required this.irrigationType,
    required this.irrigationSource,
    this.isOfflineData = false,
    this.createdAt,
    this.updatedAt,
  });

  /// * CREATE FROM JSON
  factory FarmDetails.fromJson(Map<String, dynamic> json) {
    return FarmDetails(
      phoneNumber: json['phoneNumber'] as String,
      fullName: json['fullName'] as String,
      farmerId: json['farmerId'] as String,
      experienceLevel: json['experienceLevel'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      manualAddress: json['manualAddress'] as String?,
      landArea: (json['landArea'] as num).toDouble(),
      landAreaUnit: json['landAreaUnit'] as String,
      ownershipType: json['ownershipType'] as String,
      primaryCrops: List<String>.from(json['primaryCrops'] as List),
      irrigationType: json['irrigationType'] as String,
      irrigationSource: json['irrigationSource'] as String,
      isOfflineData: json['isOfflineData'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// * CONVERT TO JSON
  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'farmerId': farmerId,
      'experienceLevel': experienceLevel,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'manualAddress': manualAddress,
      'landArea': landArea,
      'landAreaUnit': landAreaUnit,
      'ownershipType': ownershipType,
      'primaryCrops': primaryCrops,
      'irrigationType': irrigationType,
      'irrigationSource': irrigationSource,
      'isOfflineData': isOfflineData,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// * CREATE COPY WITH UPDATED FIELDS
  FarmDetails copyWith({
    String? phoneNumber,
    String? fullName,
    String? farmerId,
    String? experienceLevel,
    double? latitude,
    double? longitude,
    String? address,
    String? manualAddress,
    double? landArea,
    String? landAreaUnit,
    String? ownershipType,
    List<String>? primaryCrops,
    String? irrigationType,
    String? irrigationSource,
    bool? isOfflineData,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FarmDetails(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      farmerId: farmerId ?? this.farmerId,
      experienceLevel: experienceLevel ?? this.experienceLevel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      manualAddress: manualAddress ?? this.manualAddress,
      landArea: landArea ?? this.landArea,
      landAreaUnit: landAreaUnit ?? this.landAreaUnit,
      ownershipType: ownershipType ?? this.ownershipType,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      irrigationType: irrigationType ?? this.irrigationType,
      irrigationSource: irrigationSource ?? this.irrigationSource,
      isOfflineData: isOfflineData ?? this.isOfflineData,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FarmDetails(phoneNumber: $phoneNumber, fullName: $fullName, farmerId: $farmerId, address: $address)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FarmDetails &&
        other.phoneNumber == phoneNumber &&
        other.fullName == fullName &&
        other.farmerId == farmerId &&
        other.experienceLevel == experienceLevel &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.address == address &&
        other.manualAddress == manualAddress &&
        other.landArea == landArea &&
        other.landAreaUnit == landAreaUnit &&
        other.ownershipType == ownershipType &&
        other.primaryCrops.toString() == primaryCrops.toString() &&
        other.irrigationType == irrigationType &&
        other.irrigationSource == irrigationSource &&
        other.isOfflineData == isOfflineData;
  }

  @override
  int get hashCode {
    return Object.hash(
      phoneNumber,
      fullName,
      farmerId,
      experienceLevel,
      latitude,
      longitude,
      address,
      manualAddress,
      landArea,
      landAreaUnit,
      ownershipType,
      primaryCrops,
      irrigationType,
      irrigationSource,
      isOfflineData,
    );
  }
}

/// * OWNERSHIP TYPE ENUM
/// * Defines possible farm ownership types
enum OwnershipType {
  owner('Owner'),
  tenant('Tenant'),
  sharecropper('Sharecropper'),
  cooperativeMember('Cooperative Member');

  const OwnershipType(this.displayName);
  final String displayName;
}

/// * IRRIGATION TYPE ENUM
/// * Defines irrigation methods
enum IrrigationType {
  drip('Drip Irrigation'),
  sprinkler('Sprinkler'),
  flood('Flood Irrigation'),
  rainfed('Rainfed'),
  other('Other');

  const IrrigationType(this.displayName);
  final String displayName;
}

/// * IRRIGATION SOURCE ENUM
/// * Defines water sources for irrigation
enum IrrigationSource {
  borewell('Borewell'),
  canal('Canal'),
  river('River'),
  pond('Pond'),
  rainwater('Rainwater Harvesting'),
  other('Other');

  const IrrigationSource(this.displayName);
  final String displayName;
}
