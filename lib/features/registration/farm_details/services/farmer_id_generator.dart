// ===================================================================
// * FARMER ID GENERATOR SERVICE
// * Purpose: Generate unique farmer IDs based on location and system data
// * Format: STATE-DISTRICT-TEHSIL-YYYYMM-XXXX (e.g., MH-PUN-HAV-202412-0001)
// * Components: State code, District code, Tehsil code, Year-Month, Sequence
// * Security Level: MEDIUM - Contains location-based identification
// ===================================================================

import 'dart:math';

/// * FARMER ID GENERATOR SERVICE
/// * Generates unique, location-based farmer identification numbers
class FarmerIdGenerator {
  // * STATE CODE MAPPING (Indian states - can be extended)
  static const Map<String, String> _stateCodes = {
    'andhra pradesh': 'AP',
    'arunachal pradesh': 'AR',
    'assam': 'AS',
    'bihar': 'BR',
    'chhattisgarh': 'CG',
    'goa': 'GA',
    'gujarat': 'GJ',
    'haryana': 'HR',
    'himachal pradesh': 'HP',
    'jharkhand': 'JH',
    'karnataka': 'KA',
    'kerala': 'KL',
    'madhya pradesh': 'MP',
    'maharashtra': 'MH',
    'manipur': 'MN',
    'meghalaya': 'ML',
    'mizoram': 'MZ',
    'nagaland': 'NL',
    'odisha': 'OR',
    'punjab': 'PB',
    'rajasthan': 'RJ',
    'sikkim': 'SK',
    'tamil nadu': 'TN',
    'telangana': 'TG',
    'tripura': 'TR',
    'uttar pradesh': 'UP',
    'uttarakhand': 'UK',
    'west bengal': 'WB',
    'delhi': 'DL',
    'jammu and kashmir': 'JK',
    'ladakh': 'LA',
    'chandigarh': 'CH',
    'dadra and nagar haveli': 'DN',
    'daman and diu': 'DD',
    'lakshadweep': 'LD',
    'puducherry': 'PY',
    'andaman and nicobar islands': 'AN',
  };

  // * COMMON DISTRICT ABBREVIATIONS (can be extended with API)
  static const Map<String, String> _districtCodes = {
    'mumbai': 'MUM',
    'pune': 'PUN',
    'nashik': 'NAS',
    'aurangabad': 'AUR',
    'solapur': 'SOL',
    'kolhapur': 'KOL',
    'satara': 'SAT',
    'sangli': 'SAN',
    'ahmednagar': 'AHM',
    'delhi': 'DEL',
    'bangalore': 'BAN',
    'chennai': 'CHE',
    'hyderabad': 'HYD',
    'ahmedabad': 'AHD',
    'surat': 'SUR',
    'jaipur': 'JAI',
    'lucknow': 'LUC',
    'kanpur': 'KAN',
    'patna': 'PAT',
    'bhopal': 'BHO',
    'indore': 'IND',
    'chandigarh': 'CHA',
    'guwahati': 'GUW',
    'bhubaneswar': 'BHU',
    'thiruvananthapuram': 'TVM',
    'kochi': 'KOC',
    'coimbatore': 'COI',
    'madurai': 'MAD',
    'salem': 'SAL',
    'tiruchirappalli': 'TRI',
    'vellore': 'VEL',
    'mysore': 'MYS',
    'mangalore': 'MAN',
    'hubli': 'HUB',
    'belgaum': 'BEL',
    'vijayawada': 'VIJ',
    'visakhapatnam': 'VIS',
    'guntur': 'GUN',
    'warangal': 'WAR',
    'nizamabad': 'NIZ',
  };

  /// * GENERATE FARMER ID
  /// * Creates unique ID based on location and timestamp
  static String generateFarmerId({
    required String state,
    required String district,
    required String tehsil,
    String? village,
    String? phoneNumber,
    DateTime? registrationDate,
  }) {
    final regDate = registrationDate ?? DateTime.now();

    // * Get state code
    final stateCode = _getStateCode(state);

    // * Get district code
    final districtCode = _getDistrictCode(district);

    // * Get tehsil code (first 3 letters, uppercase)
    final tehsilCode = _getTehsilCode(tehsil);

    // * Get year-month
    final yearMonth =
        '${regDate.year}${regDate.month.toString().padLeft(2, '0')}';

    // * Generate unique sequence number
    final sequenceNumber = _generateSequenceNumber(
      phoneNumber: phoneNumber,
      village: village,
      timestamp: regDate,
    );

    // * Combine all parts
    final farmerId =
        '$stateCode-$districtCode-$tehsilCode-$yearMonth-$sequenceNumber';

    return farmerId;
  }

  /// * GENERATE ALTERNATIVE FARMER ID (GPS-based)
  /// * For cases where address details are not available
  static String generateGpsBasedFarmerId({
    required double latitude,
    required double longitude,
    String? phoneNumber,
    DateTime? registrationDate,
  }) {
    final regDate = registrationDate ?? DateTime.now();

    // * Convert GPS coordinates to location codes
    final latCode = _coordinateToCode(latitude);
    final lngCode = _coordinateToCode(longitude);

    // * Get year-month
    final yearMonth =
        '${regDate.year}${regDate.month.toString().padLeft(2, '0')}';

    // * Generate unique sequence
    final sequenceNumber = _generateSequenceNumber(
      phoneNumber: phoneNumber,
      timestamp: regDate,
      latitude: latitude,
      longitude: longitude,
    );

    // * Format: GPS-LAT-LNG-YYYYMM-XXXX
    final farmerId = 'GPS-$latCode-$lngCode-$yearMonth-$sequenceNumber';

    return farmerId;
  }

  /// * VALIDATE FARMER ID FORMAT
  static bool isValidFarmerId(String farmerId) {
    // * Standard format: XX-XXX-XXX-YYYYMM-XXXX
    final standardPattern = RegExp(r'^[A-Z]{2}-[A-Z]{3}-[A-Z]{3}-\d{6}-\d{4}$');

    // * GPS format: GPS-XXX-XXX-YYYYMM-XXXX
    final gpsPattern = RegExp(r'^GPS-[A-Z0-9]{3}-[A-Z0-9]{3}-\d{6}-\d{4}$');

    return standardPattern.hasMatch(farmerId) || gpsPattern.hasMatch(farmerId);
  }

  /// * EXTRACT INFORMATION FROM FARMER ID
  static Map<String, String> parseFarmerId(String farmerId) {
    final parts = farmerId.split('-');

    if (parts.length != 5) {
      return {'error': 'Invalid farmer ID format'};
    }

    if (parts[0] == 'GPS') {
      return {
        'type': 'GPS-based',
        'latitude_code': parts[1],
        'longitude_code': parts[2],
        'year_month': parts[3],
        'sequence': parts[4],
        'year': parts[3].substring(0, 4),
        'month': parts[3].substring(4, 6),
      };
    } else {
      return {
        'type': 'Location-based',
        'state_code': parts[0],
        'district_code': parts[1],
        'tehsil_code': parts[2],
        'year_month': parts[3],
        'sequence': parts[4],
        'year': parts[3].substring(0, 4),
        'month': parts[3].substring(4, 6),
      };
    }
  }

  /// * GENERATE BATCH OF FARMER IDs
  /// * For bulk registration scenarios
  static List<String> generateBatchFarmerIds({
    required String state,
    required String district,
    required String tehsil,
    required int count,
    DateTime? startDate,
  }) {
    final ids = <String>[];
    final baseDate = startDate ?? DateTime.now();

    for (int i = 0; i < count; i++) {
      final id = generateFarmerId(
        state: state,
        district: district,
        tehsil: tehsil,
        registrationDate: baseDate.add(Duration(seconds: i)),
      );
      ids.add(id);
    }

    return ids;
  }

  // * PRIVATE HELPER METHODS

  /// * GET STATE CODE
  static String _getStateCode(String state) {
    final normalizedState = state.toLowerCase().trim();
    return _stateCodes[normalizedState] ?? state.substring(0, 2).toUpperCase();
  }

  /// * GET DISTRICT CODE
  static String _getDistrictCode(String district) {
    final normalizedDistrict = district.toLowerCase().trim();
    return _districtCodes[normalizedDistrict] ??
        district.substring(0, 3).toUpperCase();
  }

  /// * GET TEHSIL CODE
  static String _getTehsilCode(String tehsil) {
    return tehsil.length >= 3
        ? tehsil.substring(0, 3).toUpperCase()
        : tehsil.toUpperCase().padRight(3, 'X');
  }

  /// * CONVERT COORDINATE TO CODE
  static String _coordinateToCode(double coordinate) {
    // * Convert coordinate to a 3-character code
    final absCoord = coordinate.abs();
    final intPart = absCoord.floor();
    final fracPart = ((absCoord - intPart) * 100).floor();

    // * Create a code using base-36 encoding
    final code =
        (intPart % 36).toRadixString(36).toUpperCase() +
        (fracPart % 36).toRadixString(36).toUpperCase() +
        ((intPart + fracPart) % 36).toRadixString(36).toUpperCase();

    return code.padLeft(3, '0');
  }

  /// * GENERATE SEQUENCE NUMBER
  static String _generateSequenceNumber({
    String? phoneNumber,
    String? village,
    DateTime? timestamp,
    double? latitude,
    double? longitude,
  }) {
    final ts = timestamp ?? DateTime.now();
    final random = Random();

    // * Create a seed based on available data
    int seed = ts.millisecondsSinceEpoch % 10000;

    if (phoneNumber != null && phoneNumber.isNotEmpty) {
      seed += phoneNumber.hashCode % 1000;
    }

    if (village != null && village.isNotEmpty) {
      seed += village.hashCode % 1000;
    }

    if (latitude != null && longitude != null) {
      seed += (latitude * longitude * 1000).floor() % 1000;
    }

    // * Add some randomness to ensure uniqueness
    seed += random.nextInt(1000);

    // * Ensure 4-digit format
    return (seed % 10000).toString().padLeft(4, '0');
  }

  /// * GET FARMER ID STATISTICS
  static Map<String, dynamic> getFarmerIdStats(List<String> farmerIds) {
    final stats = <String, dynamic>{
      'total_ids': farmerIds.length,
      'location_based': 0,
      'gps_based': 0,
      'states': <String, int>{},
      'districts': <String, int>{},
      'registration_months': <String, int>{},
      'invalid_ids': 0,
    };

    for (final id in farmerIds) {
      if (!isValidFarmerId(id)) {
        stats['invalid_ids']++;
        continue;
      }

      final parsed = parseFarmerId(id);

      if (parsed['type'] == 'GPS-based') {
        stats['gps_based']++;
      } else {
        stats['location_based']++;

        // * Count states and districts
        final stateCode = parsed['state_code'] ?? '';
        final districtCode = parsed['district_code'] ?? '';
        final yearMonth = parsed['year_month'] ?? '';

        stats['states'][stateCode] = (stats['states'][stateCode] ?? 0) + 1;
        stats['districts'][districtCode] =
            (stats['districts'][districtCode] ?? 0) + 1;
        stats['registration_months'][yearMonth] =
            (stats['registration_months'][yearMonth] ?? 0) + 1;
      }
    }

    return stats;
  }

  /// * SUGGEST FARMER ID IMPROVEMENTS
  static List<String> suggestImprovements(String farmerId) {
    final suggestions = <String>[];

    if (!isValidFarmerId(farmerId)) {
      suggestions.add('Invalid format. Use: STATE-DISTRICT-TEHSIL-YYYYMM-XXXX');
      return suggestions;
    }

    final parsed = parseFarmerId(farmerId);

    // * Check if codes are meaningful
    if (parsed['state_code']?.length != 2) {
      suggestions.add('State code should be 2 characters');
    }

    if (parsed['district_code']?.length != 3) {
      suggestions.add('District code should be 3 characters');
    }

    if (parsed['tehsil_code']?.length != 3) {
      suggestions.add('Tehsil code should be 3 characters');
    }

    // * Check date validity
    final yearMonth = parsed['year_month'] ?? '';
    if (yearMonth.length == 6) {
      final year = int.tryParse(yearMonth.substring(0, 4));
      final month = int.tryParse(yearMonth.substring(4, 6));

      if (year == null || year < 2020 || year > DateTime.now().year + 1) {
        suggestions.add(
          'Year should be between 2020 and ${DateTime.now().year + 1}',
        );
      }

      if (month == null || month < 1 || month > 12) {
        suggestions.add('Month should be between 01 and 12');
      }
    }

    if (suggestions.isEmpty) {
      suggestions.add('Farmer ID format is valid and well-structured');
    }

    return suggestions;
  }
}
