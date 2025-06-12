// ===================================================================
// * MARKET PRICE MODEL
// * Purpose: Immutable market price data model for dashboard pricing widget
// * Features: Current prices, trends, mandi data
// * Security Level: LOW - Public market information
// ===================================================================

// * PRICE TREND ENUMERATION
// * Indicates price movement direction
enum PriceTrend { up, down, stable }

// * MARKET PRICE MODEL
class MarketPrice {
  final String cropName;
  final String cropId;
  final double currentPrice;
  final double previousPrice;
  final PriceTrend trend;
  final String unit;
  final String mandiName;
  final String district;
  final DateTime lastUpdated;
  final double? minPrice;
  final double? maxPrice;
  final double? avgPrice;
  final String? grade;

  const MarketPrice({
    required this.cropName,
    required this.cropId,
    required this.currentPrice,
    required this.previousPrice,
    required this.trend,
    required this.unit,
    required this.mandiName,
    required this.district,
    required this.lastUpdated,
    this.minPrice,
    this.maxPrice,
    this.avgPrice,
    this.grade,
  });

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      cropName: json['cropName'] as String,
      cropId: json['cropId'] as String,
      currentPrice: (json['currentPrice'] as num).toDouble(),
      previousPrice: (json['previousPrice'] as num).toDouble(),
      trend: PriceTrend.values.firstWhere(
        (e) => e.name == json['trend'],
        orElse: () => PriceTrend.stable,
      ),
      unit: json['unit'] as String,
      mandiName: json['mandiName'] as String,
      district: json['district'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      avgPrice: (json['avgPrice'] as num?)?.toDouble(),
      grade: json['grade'] as String?,
    );
  }

  // * Calculate percentage change from previous price
  double get percentageChange {
    if (previousPrice == 0) return 0.0;
    return ((currentPrice - previousPrice) / previousPrice) * 100;
  }

  // * Get formatted price change with symbol
  String get formattedChange {
    final change = percentageChange;
    final symbol = change > 0
        ? '↗'
        : change < 0
        ? '↘'
        : '→';
    return '$symbol ${change.abs().toStringAsFixed(1)}%';
  }

  // * Get color for trend display
  String get trendColor {
    switch (trend) {
      case PriceTrend.up:
        return 'green';
      case PriceTrend.down:
        return 'red';
      case PriceTrend.stable:
        return 'gray';
    }
  }
}

// * MARKET PRICE RESPONSE MODEL
class MarketPriceResponse {
  final List<MarketPrice> prices;
  final DateTime lastSync;
  final String? location;
  final String? message;

  const MarketPriceResponse({
    required this.prices,
    required this.lastSync,
    this.location,
    this.message,
  });

  factory MarketPriceResponse.fromJson(Map<String, dynamic> json) {
    return MarketPriceResponse(
      prices: (json['prices'] as List)
          .map((e) => MarketPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastSync: DateTime.parse(json['lastSync'] as String),
      location: json['location'] as String?,
      message: json['message'] as String?,
    );
  }
}
