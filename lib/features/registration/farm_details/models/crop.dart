// ===================================================================
// * CROP MODEL
// * Purpose: Data model for crop types and varieties
// * Used for: Multi-select crop selection in farm details
// * Security Level: LOW - Contains crop reference data
// ===================================================================

/// * CROP DATA MODEL
/// * Represents different crop types available for selection
class Crop {
  final String id;
  final String name;
  final String category;
  final String? description;
  final bool isRegionallyAvailable;
  final List<String> regions;
  final String? imageUrl;

  const Crop({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    this.isRegionallyAvailable = true,
    this.regions = const [],
    this.imageUrl,
  });

  /// * CREATE FROM JSON
  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      isRegionallyAvailable: json['isRegionallyAvailable'] as bool? ?? true,
      regions: List<String>.from(json['regions'] as List? ?? []),
      imageUrl: json['imageUrl'] as String?,
    );
  }

  /// * CONVERT TO JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'isRegionallyAvailable': isRegionallyAvailable,
      'regions': regions,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() => 'Crop(id: $id, name: $name, category: $category)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Crop &&
        other.id == id &&
        other.name == name &&
        other.category == category;
  }

  @override
  int get hashCode => Object.hash(id, name, category);
}

/// * CROP CATEGORY ENUM
/// * Defines different categories of crops
enum CropCategory {
  cereals('Cereals'),
  pulses('Pulses'),
  vegetables('Vegetables'),
  fruits('Fruits'),
  spices('Spices'),
  cashCrops('Cash Crops'),
  fodder('Fodder Crops'),
  oilSeeds('Oil Seeds');

  const CropCategory(this.displayName);
  final String displayName;
}

/// * PREDEFINED CROP LIST
/// * Common crops available for selection
class CropData {
  static const List<Crop> defaultCrops = [
    // * Cereals
    Crop(id: 'rice', name: 'Rice', category: 'Cereals'),
    Crop(id: 'wheat', name: 'Wheat', category: 'Cereals'),
    Crop(id: 'maize', name: 'Maize/Corn', category: 'Cereals'),
    Crop(id: 'barley', name: 'Barley', category: 'Cereals'),
    Crop(id: 'millet', name: 'Millet', category: 'Cereals'),

    // * Pulses
    Crop(id: 'chickpea', name: 'Chickpea', category: 'Pulses'),
    Crop(id: 'lentil', name: 'Lentil', category: 'Pulses'),
    Crop(id: 'blackgram', name: 'Black Gram', category: 'Pulses'),
    Crop(id: 'greengram', name: 'Green Gram', category: 'Pulses'),
    Crop(id: 'pigeon_pea', name: 'Pigeon Pea', category: 'Pulses'),

    // * Vegetables
    Crop(id: 'tomato', name: 'Tomato', category: 'Vegetables'),
    Crop(id: 'onion', name: 'Onion', category: 'Vegetables'),
    Crop(id: 'potato', name: 'Potato', category: 'Vegetables'),
    Crop(id: 'cabbage', name: 'Cabbage', category: 'Vegetables'),
    Crop(id: 'cauliflower', name: 'Cauliflower', category: 'Vegetables'),
    Crop(id: 'brinjal', name: 'Brinjal/Eggplant', category: 'Vegetables'),
    Crop(id: 'okra', name: 'Okra/Lady Finger', category: 'Vegetables'),

    // * Fruits
    Crop(id: 'mango', name: 'Mango', category: 'Fruits'),
    Crop(id: 'banana', name: 'Banana', category: 'Fruits'),
    Crop(id: 'apple', name: 'Apple', category: 'Fruits'),
    Crop(id: 'orange', name: 'Orange', category: 'Fruits'),
    Crop(id: 'grapes', name: 'Grapes', category: 'Fruits'),

    // * Cash Crops
    Crop(id: 'cotton', name: 'Cotton', category: 'Cash Crops'),
    Crop(id: 'sugarcane', name: 'Sugarcane', category: 'Cash Crops'),
    Crop(id: 'tobacco', name: 'Tobacco', category: 'Cash Crops'),

    // * Oil Seeds
    Crop(id: 'groundnut', name: 'Groundnut', category: 'Oil Seeds'),
    Crop(id: 'sunflower', name: 'Sunflower', category: 'Oil Seeds'),
    Crop(id: 'mustard', name: 'Mustard', category: 'Oil Seeds'),
    Crop(id: 'sesame', name: 'Sesame', category: 'Oil Seeds'),

    // * Spices
    Crop(id: 'turmeric', name: 'Turmeric', category: 'Spices'),
    Crop(id: 'chili', name: 'Chili', category: 'Spices'),
    Crop(id: 'coriander', name: 'Coriander', category: 'Spices'),
    Crop(id: 'cumin', name: 'Cumin', category: 'Spices'),
  ];

  /// * GET CROPS BY CATEGORY
  static List<Crop> getCropsByCategory(String category) {
    return defaultCrops.where((crop) => crop.category == category).toList();
  }

  /// * GET ALL CATEGORIES
  static List<String> getAllCategories() {
    return defaultCrops.map((crop) => crop.category).toSet().toList();
  }

  /// * SEARCH CROPS BY NAME
  static List<Crop> searchCrops(String query) {
    final lowerQuery = query.toLowerCase();
    return defaultCrops
        .where((crop) => crop.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
