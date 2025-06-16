// ===================================================================
// * FARM DETAILS SCREEN - REFACTORED & MODULAR
// * Purpose: Complete farm details collection with modular components
// * Features: Step-based navigation, reusable widgets, clean architecture
// * Security Level: MEDIUM - Handles farmer's farm data
// * Design: Material 3 with accessibility for farmers
// ===================================================================

import 'package:flutter/material.dart';
import '../../login/models/user_profile.dart';
import '../../navigation/main_navigation.dart';
import 'farm_details_controller.dart';
import 'models/farm_details.dart';
import 'utils/farm_form_validator.dart';
import 'widgets/location_step.dart';
import 'widgets/land_details_step.dart';
import 'widgets/crop_selection_step.dart';
import 'widgets/irrigation_step.dart';
import 'widgets/success_view.dart';
import 'widgets/common/navigation_fab.dart';

/// * REFACTORED FARM DETAILS SCREEN
/// * Modular, maintainable farm registration interface
class FarmDetailsScreen extends StatefulWidget {
  final String phoneNumber;
  final String fullName;
  final String experienceLevel;

  const FarmDetailsScreen({
    super.key,
    required this.phoneNumber,
    required this.fullName,
    required this.experienceLevel,
  });

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen>
    with TickerProviderStateMixin {
  late final FarmDetailsController _controller;
  late final AnimationController _animationController;

  final _formKey = GlobalKey<FormState>();
  final _landAreaController = TextEditingController();
  final _pageController = PageController();

  // * MANUAL ADDRESS CONTROLLERS
  final _manualAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  int _currentStep = 0;
  final int _totalSteps = 4;

  // * STATE VARIABLES FOR STEPS
  String _selectedOwnership = 'Owned';
  String _selectedLandUnit = 'acres';
  String _selectedSoilType = '';
  String _selectedIrrigationType = '';
  String _selectedWaterSource = '';
  final Set<String> _selectedCrops = <String>{};
  final Set<String> _selectedLandUsage = <String>{};
  bool _isRegistrationComplete = false;

  @override
  void initState() {
    super.initState();
    _controller = FarmDetailsController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controller.initializeWithBasicInfo(
      phoneNumber: widget.phoneNumber,
      fullName: widget.fullName,
      farmerId: '', // Will be generated after location
      experienceLevel: widget.experienceLevel,
    );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    _animationController.dispose();
    _landAreaController.dispose();
    _pageController.dispose();
    _manualAddressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _isRegistrationComplete ? null : _buildMaterialAppBar(),
      body: _isRegistrationComplete ? _buildSuccessView() : _buildMainContent(),
      floatingActionButton: _isRegistrationComplete
          ? null
          : _buildNavigationFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildMaterialAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Farm Details'),
          Text(
            'Step ${_currentStep + 1} of $_totalSteps',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _showHelpDialog,
          icon: const Icon(Icons.help_outline),
          tooltip: 'Need help?',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(8),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildLocationStep(),
        _buildLandDetailsStep(),
        _buildCropSelectionStep(),
        _buildIrrigationStep(),
      ],
    );
  }

  Widget _buildLocationStep() {
    return LocationStep(
      controller: _controller,
      fullName: widget.fullName,
      experienceLevel: widget.experienceLevel,
      manualAddressController: _manualAddressController,
      cityController: _cityController,
      stateController: _stateController,
      pincodeController: _pincodeController,
      onAddressChanged: _updateFarmerIdIfNeeded,
    );
  }

  Widget _buildLandDetailsStep() {
    return LandDetailsStep(
      landAreaController: _landAreaController,
      selectedOwnership: _selectedOwnership,
      selectedLandUnit: _selectedLandUnit,
      selectedSoilType: _selectedSoilType,
      selectedLandUsage: _selectedLandUsage,
      onOwnershipChanged: (ownership) {
        setState(() {
          _selectedOwnership = ownership;
        });
      },
      onLandUnitChanged: (unit) {
        setState(() {
          _selectedLandUnit = unit;
        });
      },
      onSoilTypeChanged: (soilType) {
        setState(() {
          _selectedSoilType = soilType;
        });
      },
      onLandUsageChanged: (usage, selected) {
        setState(() {
          if (selected) {
            _selectedLandUsage.add(usage);
          } else {
            _selectedLandUsage.remove(usage);
          }
        });
      },
    );
  }

  Widget _buildCropSelectionStep() {
    return CropSelectionStep(
      selectedCrops: _selectedCrops,
      onCropSelectionChanged: (cropId, selected) {
        setState(() {
          if (selected) {
            _selectedCrops.add(cropId);
          } else {
            _selectedCrops.remove(cropId);
          }
        });
      },
    );
  }

  Widget _buildIrrigationStep() {
    return IrrigationStep(
      selectedIrrigationType: _selectedIrrigationType,
      selectedWaterSource: _selectedWaterSource,
      onIrrigationTypeChanged: (type) {
        setState(() {
          _selectedIrrigationType = type;
        });
      },
      onWaterSourceChanged: (source) {
        setState(() {
          _selectedWaterSource = source;
        });
      },
    );
  }

  Widget _buildSuccessView() {
    return SuccessView(
      fullName: widget.fullName,
      farmerId: _controller.farmerId,
      address: _getManualAddressString(),
      landArea: _landAreaController.text.trim(),
      landUnit: _selectedLandUnit,
      ownership: _selectedOwnership,
      selectedCropsCount: _selectedCrops.length,
      irrigationType: _selectedIrrigationType,
      waterSource: _selectedWaterSource,
      onContinuePressed: _completeRegistration,
    );
  }

  Widget? _buildNavigationFAB() {
    // * Show navigation FAB only when address is confirmed
    if (!_hasValidManualAddress()) {
      return null;
    }

    return NavigationFAB(
      canContinue: _canContinue(),
      isLastStep: _currentStep == _totalSteps - 1,
      onPressed: _goToNextStep,
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.help_outline,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: const Text('Need Help?'),
        content: const Text(
          'This form helps us understand your farm better. All information is secure and will be used to provide personalized farming solutions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  // ===================================================================
  // * VALIDATION METHODS
  // ===================================================================

  bool _hasValidManualAddress() {
    return FarmFormValidator.hasValidManualAddress(
      address: _manualAddressController.text,
      city: _cityController.text,
      state: _stateController.text,
      pincode: _pincodeController.text,
    );
  }

  bool _canContinue() {
    return FarmFormValidator.canContinueFromStep(
      currentStep: _currentStep,
      address: _manualAddressController.text,
      city: _cityController.text,
      state: _stateController.text,
      pincode: _pincodeController.text,
      landArea: _landAreaController.text,
      ownership: _selectedOwnership,
      selectedCrops: _selectedCrops,
      irrigationType: _selectedIrrigationType,
      waterSource: _selectedWaterSource,
    );
  }

  String _getManualAddressString() {
    return '${_manualAddressController.text.trim()}, ${_cityController.text.trim()}, ${_stateController.text.trim()} - ${_pincodeController.text.trim()}';
  }

  // ===================================================================
  // * NAVIGATION METHODS
  // ===================================================================

  void _updateFarmerIdIfNeeded() {
    setState(() {
      if (_hasValidManualAddress()) {
        _updateControllerWithAddressData();
        _controller.generateFarmerId();
      }
    });
  }

  void _updateControllerWithAddressData() {
    _controller.updateAddressField(
      'village',
      _manualAddressController.text.trim(),
    );
    _controller.updateAddressField('district', _cityController.text.trim());
    _controller.updateAddressField('state', _stateController.text.trim());
    _controller.updateAddressField('pincode', _pincodeController.text.trim());
  }

  void _goToNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      // * Generate farmer ID if not already generated
      if (_controller.farmerId.isEmpty) {
        _updateControllerWithAddressData();
        _controller.generateFarmerId();
      }
    } else {
      // * Show success view
      _showSuccessView();
    }
  }

  void _showSuccessView() {
    setState(() {
      _isRegistrationComplete = true;
    });
  }

  void _completeRegistration() {
    // * CREATE COMPLETE FARM DETAILS
    final farmDetails = FarmDetails(
      phoneNumber: widget.phoneNumber,
      fullName: widget.fullName,
      farmerId: _controller.farmerId,
      experienceLevel: widget.experienceLevel,
      latitude: 0.0, // Will be updated with actual coordinates
      longitude: 0.0, // Will be updated with actual coordinates
      address: _getManualAddressString(),
      manualAddress: _manualAddressController.text.trim(),
      village: _manualAddressController.text.trim(),
      district: _cityController.text.trim(),
      addressState: _stateController.text.trim(),
      pincode: _pincodeController.text.trim(),
      landArea: double.tryParse(_landAreaController.text.trim()) ?? 0.0,
      landAreaUnit: _selectedLandUnit,
      ownershipType: _selectedOwnership,
      primaryCrops: _selectedCrops.toList(),
      irrigationType: _selectedIrrigationType,
      irrigationSource: _selectedWaterSource,
      isOfflineData: false,
      createdAt: DateTime.now(),
    );

    // * TODO: Save farm details to repository/API
    // _controller.saveFarmDetails(farmDetails);

    final userProfile = UserProfile.minimal(
      phoneNumber: widget.phoneNumber,
      fullName: widget.fullName,
      farmerId: _controller.farmerId,
      experienceLevel: widget.experienceLevel,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainNavigationWrapper(userProfile: userProfile),
      ),
    );
  }
}
