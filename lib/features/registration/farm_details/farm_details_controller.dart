// ===================================================================
// * FARM DETAILS CONTROLLER
// * Purpose: Manage farm details form state and business logic
// * Features: GPS location, crop selection, form validation, API submission
// * State Management: ChangeNotifier (can be upgraded to Riverpod later)
// * Security Level: HIGH - Handles sensitive farm data
// ===================================================================

import 'package:flutter/foundation.dart';
import 'models/farm_details.dart';
import 'models/crop.dart';
import 'farm_details_repository.dart';
import 'services/farmer_id_generator.dart';

/// * FARM DETAILS FORM STATE
/// * Represents the current state of the farm details form
enum FarmDetailsState {
  initial,
  loading,
  loadingLocation,
  loadingCrops,
  submitting,
  success,
  error,
}

/// * FARM DETAILS CONTROLLER
/// * Manages form state, validation, and submission
class FarmDetailsController extends ChangeNotifier {
  final FarmDetailsRepository _repository = FarmDetailsRepository();

  // * FORM STATE
  FarmDetailsState _state = FarmDetailsState.initial;
  String? _errorMessage;

  // * BASIC INFO (from previous registration steps)
  String _phoneNumber = '';
  String _fullName = '';
  String _farmerId = '';
  String _experienceLevel = '';

  // * LOCATION DATA
  double? _latitude;
  double? _longitude;
  String _address = '';
  String _manualAddress = '';
  bool _isLocationLoading = false;

  // * DETAILED MANUAL ADDRESS FIELDS
  String _village = '';
  String _tehsil = '';
  String _district = '';
  String _addressState = '';
  String _pincode = '';

  // * LAND INFORMATION
  double _landArea = 0.0;
  String _landAreaUnit = 'hectares';
  String _ownershipType = '';

  // * CROP SELECTION
  List<Crop> _availableCrops = [];
  final List<String> _selectedCropIds = [];
  bool _isCropsLoading = false;

  // * IRRIGATION
  String _irrigationType = '';
  String _irrigationSource = '';

  // * GETTERS
  FarmDetailsState get state => _state;
  String? get errorMessage => _errorMessage;
  String get phoneNumber => _phoneNumber;
  String get fullName => _fullName;
  String get farmerId => _farmerId;
  String get experienceLevel => _experienceLevel;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  String get address => _address;
  String get manualAddress => _manualAddress;
  bool get isLocationLoading => _isLocationLoading;
  double get landArea => _landArea;
  String get landAreaUnit => _landAreaUnit;
  String get ownershipType => _ownershipType;
  List<Crop> get availableCrops => _availableCrops;
  List<String> get selectedCropIds => _selectedCropIds;
  bool get isCropsLoading => _isCropsLoading;
  String get irrigationType => _irrigationType;
  String get irrigationSource => _irrigationSource;

  // * COMPUTED PROPERTIES
  List<Crop> get selectedCrops {
    return _availableCrops
        .where((crop) => _selectedCropIds.contains(crop.id))
        .toList();
  }

  bool get hasLocation => _latitude != null && _longitude != null;

  bool get hasManualAddress {
    return _village.isNotEmpty ||
        _tehsil.isNotEmpty ||
        _district.isNotEmpty ||
        _addressState.isNotEmpty ||
        _pincode.isNotEmpty;
  }

  String get formattedManualAddress {
    final parts = <String>[];
    if (_village.isNotEmpty) parts.add(_village);
    if (_tehsil.isNotEmpty) parts.add(_tehsil);
    if (_district.isNotEmpty) parts.add(_district);
    if (_addressState.isNotEmpty) parts.add(_addressState);
    if (_pincode.isNotEmpty) parts.add(_pincode);
    return parts.join(', ');
  }

  String get landAreaReference {
    if (_landArea > 0) {
      return _repository.getLandAreaReference(_landArea, _landAreaUnit);
    }
    return '';
  }

  bool get isFormValid {
    return _phoneNumber.isNotEmpty &&
        _fullName.isNotEmpty &&
        _farmerId.isNotEmpty &&
        _address.isNotEmpty &&
        _landArea > 0 &&
        _ownershipType.isNotEmpty &&
        _selectedCropIds.isNotEmpty &&
        _irrigationType.isNotEmpty &&
        _irrigationSource.isNotEmpty &&
        hasLocation;
  }

  /// * INITIALIZE WITH BASIC INFO
  void initializeWithBasicInfo({
    required String phoneNumber,
    required String fullName,
    required String farmerId,
    required String experienceLevel,
  }) {
    _phoneNumber = phoneNumber;
    _fullName = fullName;
    _farmerId = farmerId;
    _experienceLevel = experienceLevel;

    // * Load available crops
    loadAvailableCrops();
    notifyListeners();
  }

  /// * AUTO-GENERATE FARMER ID
  /// * Generates ID based on location data or GPS coordinates
  void generateFarmerId() {
    String generatedId;

    if (_addressState.isNotEmpty &&
        _district.isNotEmpty &&
        _tehsil.isNotEmpty) {
      // * Use location-based generation
      generatedId = FarmerIdGenerator.generateFarmerId(
        state: _addressState,
        district: _district,
        tehsil: _tehsil,
        village: _village.isNotEmpty ? _village : null,
        phoneNumber: _phoneNumber,
        registrationDate: DateTime.now(),
      );
    } else if (_latitude != null && _longitude != null) {
      // * Use GPS-based generation
      generatedId = FarmerIdGenerator.generateGpsBasedFarmerId(
        latitude: _latitude!,
        longitude: _longitude!,
        phoneNumber: _phoneNumber,
        registrationDate: DateTime.now(),
      );
    } else {
      // * Fallback: Use phone number and timestamp
      final now = DateTime.now();
      final yearMonth = '${now.year}${now.month.toString().padLeft(2, '0')}';
      final sequence = (_phoneNumber.hashCode % 10000).toString().padLeft(
        4,
        '0',
      );
      generatedId = 'CF-GEN-TMP-$yearMonth-$sequence';
    }

    _farmerId = generatedId;
    notifyListeners();
  }

  /// * UPDATE LOCATION DATA
  void updateLocation({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    _clearError();

    // * Auto-generate farmer ID based on GPS if no manual address
    if (!hasManualAddress) {
      generateFarmerId();
    }

    notifyListeners();
  }

  /// * UPDATE MANUAL ADDRESS
  void updateManualAddress(String address) {
    _manualAddress = address;
    notifyListeners();
  }

  /// * UPDATE INDIVIDUAL ADDRESS FIELD
  void updateAddressField(String field, String value) {
    switch (field) {
      case 'village':
        _village = value;
        break;
      case 'tehsil':
        _tehsil = value;
        break;
      case 'district':
        _district = value;
        break;
      case 'state':
        _addressState = value;
        break;
      case 'pincode':
        _pincode = value;
        break;
    }

    // * Update the combined manual address
    _manualAddress = formattedManualAddress;

    // * Auto-generate farmer ID if we have enough location data
    if (_addressState.isNotEmpty &&
        _district.isNotEmpty &&
        _tehsil.isNotEmpty) {
      generateFarmerId();
    }

    notifyListeners();
  }

  /// * UPDATE LAND AREA
  void updateLandArea(double area) {
    _landArea = area;
    _clearError();
    notifyListeners();
  }

  /// * UPDATE LAND AREA UNIT
  void updateLandAreaUnit(String unit) {
    _landAreaUnit = unit;
    notifyListeners();
  }

  /// * UPDATE OWNERSHIP TYPE
  void updateOwnershipType(String type) {
    _ownershipType = type;
    _clearError();
    notifyListeners();
  }

  /// * UPDATE IRRIGATION TYPE
  void updateIrrigationType(String type) {
    _irrigationType = type;
    _clearError();
    notifyListeners();
  }

  /// * UPDATE IRRIGATION SOURCE
  void updateIrrigationSource(String source) {
    _irrigationSource = source;
    _clearError();
    notifyListeners();
  }

  /// * TOGGLE CROP SELECTION
  void toggleCropSelection(String cropId) {
    if (_selectedCropIds.contains(cropId)) {
      _selectedCropIds.remove(cropId);
    } else {
      _selectedCropIds.add(cropId);
    }
    _clearError();
    notifyListeners();
  }

  /// * CLEAR ALL SELECTED CROPS
  void clearSelectedCrops() {
    _selectedCropIds.clear();
    notifyListeners();
  }

  /// * LOAD AVAILABLE CROPS
  Future<void> loadAvailableCrops({String? region}) async {
    _isCropsLoading = true;
    notifyListeners();

    try {
      _availableCrops = await _repository.loadAvailableCrops(region: region);
    } catch (e) {
      _setError('Failed to load crops: $e');
    } finally {
      _isCropsLoading = false;
      notifyListeners();
    }
  }

  /// * GET CURRENT LOCATION (GPS)
  Future<void> getCurrentLocation() async {
    _isLocationLoading = true;
    _setState(FarmDetailsState.loadingLocation);

    try {
      // TODO: Implement actual GPS location using geolocator
      // final position = await Geolocator.getCurrentPosition();
      // final placemarks = await placemarkFromCoordinates(
      //   position.latitude,
      //   position.longitude,
      // );
      // final address = _formatAddress(placemarks.first);

      // * MOCK GPS LOCATION - Replace with actual implementation
      await Future.delayed(const Duration(seconds: 2));

      // * Mock coordinates (example: somewhere in India)
      updateLocation(
        latitude: 28.6139, // New Delhi latitude
        longitude: 77.2090, // New Delhi longitude
        address: 'Mock Farm Location, New Delhi, India',
      );

      _setState(FarmDetailsState.initial);
    } catch (e) {
      _setError('Failed to get location: $e');
      _setState(FarmDetailsState.error);
    } finally {
      _isLocationLoading = false;
      notifyListeners();
    }
  }

  /// * SUBMIT FARM DETAILS
  Future<void> submitFarmDetails() async {
    if (!isFormValid) {
      _setError('Please fill all required fields');
      return;
    }

    _setState(FarmDetailsState.submitting);

    try {
      final farmDetails = FarmDetails(
        phoneNumber: _phoneNumber,
        fullName: _fullName,
        farmerId: _farmerId,
        experienceLevel: _experienceLevel,
        latitude: _latitude!,
        longitude: _longitude!,
        address: _address,
        manualAddress: _manualAddress.isNotEmpty ? _manualAddress : null,
        village: _village.isNotEmpty ? _village : null,
        tehsil: _tehsil.isNotEmpty ? _tehsil : null,
        district: _district.isNotEmpty ? _district : null,
        addressState: _addressState.isNotEmpty ? _addressState : null,
        pincode: _pincode.isNotEmpty ? _pincode : null,
        landArea: _landArea,
        landAreaUnit: _landAreaUnit,
        ownershipType: _ownershipType,
        primaryCrops: _selectedCropIds,
        irrigationType: _irrigationType,
        irrigationSource: _irrigationSource,
        createdAt: DateTime.now(),
      );

      // * Validate before submission
      final validationError = _repository.validateFarmDetails(farmDetails);
      if (validationError != null) {
        _setError(validationError);
        return;
      }

      // * Submit to repository
      final isOnline = await _repository.submitFarmDetails(farmDetails);

      if (isOnline) {
        _setState(FarmDetailsState.success);
      } else {
        // * Data saved offline
        _setState(FarmDetailsState.success);
        // TODO: Show offline message to user
      }
    } catch (e) {
      _setError('Failed to submit farm details: $e');
      _setState(FarmDetailsState.error);
    }
  }

  /// * RESET FORM
  void resetForm() {
    _latitude = null;
    _longitude = null;
    _address = '';
    _manualAddress = '';
    _village = '';
    _tehsil = '';
    _district = '';
    _addressState = '';
    _pincode = '';
    _landArea = 0.0;
    _landAreaUnit = 'hectares';
    _ownershipType = '';
    _selectedCropIds.clear();
    _irrigationType = '';
    _irrigationSource = '';
    _setState(FarmDetailsState.initial);
    _clearError();
  }

  /// * PRIVATE HELPER METHODS
  void _setState(FarmDetailsState newState) {
    _state = newState;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _state = FarmDetailsState.error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_state == FarmDetailsState.error) {
      _state = FarmDetailsState.initial;
    }
  }

  /// * GET CROPS BY CATEGORY
  List<Crop> getCropsByCategory(String category) {
    return _availableCrops.where((crop) => crop.category == category).toList();
  }

  /// * GET ALL CROP CATEGORIES
  List<String> getAllCropCategories() {
    return _availableCrops.map((crop) => crop.category).toSet().toList();
  }

  /// * SEARCH CROPS
  List<Crop> searchCrops(String query) {
    if (query.isEmpty) return _availableCrops;

    final lowerQuery = query.toLowerCase();
    return _availableCrops
        .where(
          (crop) =>
              crop.name.toLowerCase().contains(lowerQuery) ||
              crop.category.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }
}
