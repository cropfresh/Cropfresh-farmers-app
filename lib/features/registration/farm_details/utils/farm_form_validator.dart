// ===================================================================
// * FARM FORM VALIDATOR UTILITY
// * Purpose: Centralized validation logic for farm details form
// * Features: Step-wise validation, address validation, data validation
// * Security Level: LOW - Form validation logic only
// ===================================================================

/// * FARM FORM VALIDATION UTILITY
/// * Handles all validation logic for farm details registration
class FarmFormValidator {
  // * LOCATION STEP VALIDATION
  static bool hasValidManualAddress({
    required String address,
    required String city,
    required String state,
    required String pincode,
  }) {
    return address.trim().isNotEmpty &&
        city.trim().isNotEmpty &&
        state.trim().isNotEmpty &&
        pincode.trim().length == 6;
  }

  // * LAND DETAILS STEP VALIDATION
  static bool hasValidLandDetails({
    required String landArea,
    required String ownership,
  }) {
    if (landArea.trim().isEmpty || ownership.isEmpty) {
      return false;
    }

    final area = double.tryParse(landArea.trim());
    return area != null && area > 0;
  }

  // * CROP SELECTION STEP VALIDATION
  static bool hasValidCropSelection({required Set<String> selectedCrops}) {
    return selectedCrops.isNotEmpty;
  }

  // * IRRIGATION STEP VALIDATION
  static bool hasValidIrrigationDetails({
    required String irrigationType,
    required String waterSource,
  }) {
    return irrigationType.isNotEmpty && waterSource.isNotEmpty;
  }

  // * STEP-WISE VALIDATION
  static bool canContinueFromStep({
    required int currentStep,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String landArea,
    required String ownership,
    required Set<String> selectedCrops,
    required String irrigationType,
    required String waterSource,
  }) {
    switch (currentStep) {
      case 0: // Location step
        return hasValidManualAddress(
          address: address,
          city: city,
          state: state,
          pincode: pincode,
        );
      case 1: // Land details step
        return hasValidLandDetails(landArea: landArea, ownership: ownership);
      case 2: // Crop selection step
        return hasValidCropSelection(selectedCrops: selectedCrops);
      case 3: // Irrigation step
        return hasValidIrrigationDetails(
          irrigationType: irrigationType,
          waterSource: waterSource,
        );
      default:
        return true;
    }
  }

  // * INDIVIDUAL FIELD VALIDATORS
  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your farm address';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter city/district';
    }
    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter state';
    }
    return null;
  }

  static String? validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter PIN code';
    }
    if (value.length != 6) {
      return 'PIN must be 6 digits';
    }
    return null;
  }

  static String? validateLandArea(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter land area';
    }
    final area = double.tryParse(value);
    if (area == null || area <= 0) {
      return 'Enter valid area';
    }
    return null;
  }
}
