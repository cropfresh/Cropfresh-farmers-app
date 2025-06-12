// ===================================================================
// * FARMER ID GENERATION DEMO
// * Purpose: Demonstrate how Farmer IDs are generated
// * Examples: Location-based, GPS-based, and fallback scenarios
// * Security Level: LOW - Demo/educational content only
// ===================================================================

import '../services/farmer_id_generator.dart';

/// * FARMER ID GENERATION EXAMPLES
/// * Shows different scenarios and generated IDs
class FarmerIdDemo {
  /// * DEMO: LOCATION-BASED FARMER ID GENERATION
  static void demonstrateLocationBasedGeneration() {
    print('=== LOCATION-BASED FARMER ID GENERATION ===\n');

    // * Example 1: Maharashtra farmer
    final maharashtraId = FarmerIdGenerator.generateFarmerId(
      state: 'Maharashtra',
      district: 'Pune',
      tehsil: 'Haveli',
      village: 'Pirangut',
      phoneNumber: '9876543210',
    );
    print('Maharashtra Farmer: $maharashtraId');
    print('Format: MH-PUN-HAV-YYYYMM-XXXX\n');

    // * Example 2: Punjab farmer
    final punjabId = FarmerIdGenerator.generateFarmerId(
      state: 'Punjab',
      district: 'Ludhiana',
      tehsil: 'Samrala',
      village: 'Khanna',
      phoneNumber: '9123456789',
    );
    print('Punjab Farmer: $punjabId');
    print('Format: PB-LUD-SAM-YYYYMM-XXXX\n');

    // * Example 3: Tamil Nadu farmer
    final tamilNaduId = FarmerIdGenerator.generateFarmerId(
      state: 'Tamil Nadu',
      district: 'Coimbatore',
      tehsil: 'Pollachi',
      village: 'Udumalaipettai',
      phoneNumber: '9988776655',
    );
    print('Tamil Nadu Farmer: $tamilNaduId');
    print('Format: TN-COI-POL-YYYYMM-XXXX\n');
  }

  /// * DEMO: GPS-BASED FARMER ID GENERATION
  static void demonstrateGpsBasedGeneration() {
    print('=== GPS-BASED FARMER ID GENERATION ===\n');

    // * Example 1: Farm in Maharashtra (GPS coordinates)
    final gpsId1 = FarmerIdGenerator.generateGpsBasedFarmerId(
      latitude: 18.5204, // Pune latitude
      longitude: 73.8567, // Pune longitude
      phoneNumber: '9876543210',
    );
    print('GPS-based ID (Pune): $gpsId1');
    print('Format: GPS-LAT-LNG-YYYYMM-XXXX\n');

    // * Example 2: Farm in Punjab (GPS coordinates)
    final gpsId2 = FarmerIdGenerator.generateGpsBasedFarmerId(
      latitude: 30.9010, // Ludhiana latitude
      longitude: 75.8573, // Ludhiana longitude
      phoneNumber: '9123456789',
    );
    print('GPS-based ID (Ludhiana): $gpsId2');
    print('Format: GPS-LAT-LNG-YYYYMM-XXXX\n');
  }

  /// * DEMO: FARMER ID VALIDATION
  static void demonstrateValidation() {
    print('=== FARMER ID VALIDATION ===\n');

    final testIds = [
      'MH-PUN-HAV-202412-0001', // Valid location-based
      'GPS-I2S-K3T-202412-0002', // Valid GPS-based
      'CF-GEN-TMP-202412-0003', // Valid temporary
      'INVALID-ID', // Invalid format
      'MH-PUN-202412-0001', // Missing component
    ];

    for (final id in testIds) {
      final isValid = FarmerIdGenerator.isValidFarmerId(id);
      print('$id: ${isValid ? "✅ VALID" : "❌ INVALID"}');

      if (isValid) {
        final parsed = FarmerIdGenerator.parseFarmerId(id);
        print('  Type: ${parsed['type']}');
        print('  Year: ${parsed['year']}, Month: ${parsed['month']}');
      }
      print('');
    }
  }

  /// * DEMO: REAL-WORLD SCENARIOS
  static void demonstrateRealWorldScenarios() {
    print('=== REAL-WORLD SCENARIOS ===\n');

    // * Scenario 1: Complete address information
    print('Scenario 1: Farmer with complete address');
    final completeAddressId = FarmerIdGenerator.generateFarmerId(
      state: 'Karnataka',
      district: 'Bangalore',
      tehsil: 'Anekal',
      village: 'Jigani',
      phoneNumber: '9845123456',
    );
    print('Generated ID: $completeAddressId\n');

    // * Scenario 2: Only GPS coordinates available
    print('Scenario 2: Farmer with only GPS location');
    final gpsOnlyId = FarmerIdGenerator.generateGpsBasedFarmerId(
      latitude: 12.9716, // Bangalore latitude
      longitude: 77.5946, // Bangalore longitude
      phoneNumber: '9845123456',
    );
    print('Generated ID: $gpsOnlyId\n');

    // * Scenario 3: Batch registration for cooperative
    print('Scenario 3: Batch registration for farmer cooperative');
    final batchIds = FarmerIdGenerator.generateBatchFarmerIds(
      state: 'Haryana',
      district: 'Karnal',
      tehsil: 'Assandh',
      count: 5,
    );

    for (int i = 0; i < batchIds.length; i++) {
      print('Farmer ${i + 1}: ${batchIds[i]}');
    }
    print('');
  }

  /// * DEMO: BENEFITS OF AUTO-GENERATED FARMER IDs
  static void demonstrateBenefits() {
    print('=== BENEFITS OF AUTO-GENERATED FARMER IDs ===\n');

    print('✅ UNIQUENESS:');
    print('   - Each ID is unique based on location + timestamp + phone');
    print('   - No duplicate IDs possible\n');

    print('✅ LOCATION TRACKING:');
    print('   - Easy to identify farmer\'s region from ID');
    print('   - Useful for government schemes and subsidies\n');

    print('✅ STANDARDIZATION:');
    print('   - Consistent format across all farmers');
    print('   - Compatible with government databases\n');

    print('✅ SCALABILITY:');
    print('   - Can generate millions of unique IDs');
    print('   - Supports batch generation for cooperatives\n');

    print('✅ OFFLINE CAPABILITY:');
    print('   - Works without internet connection');
    print('   - Uses local data for generation\n');

    print('✅ TRACEABILITY:');
    print('   - Registration date embedded in ID');
    print('   - Easy to track farmer onboarding trends\n');
  }

  /// * RUN ALL DEMOS
  static void runAllDemos() {
    print('🌾 CROPFRESH FARMER ID GENERATION SYSTEM 🌾\n');
    print('=' * 50);

    demonstrateLocationBasedGeneration();
    print('=' * 50);

    demonstrateGpsBasedGeneration();
    print('=' * 50);

    demonstrateValidation();
    print('=' * 50);

    demonstrateRealWorldScenarios();
    print('=' * 50);

    demonstrateBenefits();
    print('=' * 50);

    print('\n🎉 Demo completed! Your farmers will have unique,');
    print('   location-based IDs that are perfect for');
    print('   agricultural management and government integration.');
  }
}

/// * EXAMPLE USAGE
void main() {
  FarmerIdDemo.runAllDemos();
}
