// ===================================================================
// * WEATHER DATA MODEL
// * Purpose: Immutable weather data model for dashboard weather widget
// * Features: Current weather, forecast data, alerts
// * Security Level: LOW - Public weather information
// ===================================================================

// * WEATHER DATA MODEL
class WeatherData {
  final double temperature;
  final double humidity;
  final double windSpeed;
  final int uvIndex;
  final String condition;
  final String description;
  final String icon;
  final DateTime timestamp;
  final double rainfall;
  final bool hasAlert;
  final String? alertMessage;
  final String? alertType;

  const WeatherData({
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.uvIndex,
    required this.condition,
    required this.description,
    required this.icon,
    required this.timestamp,
    this.rainfall = 0.0,
    this.hasAlert = false,
    this.alertMessage,
    this.alertType,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      windSpeed: (json['windSpeed'] as num).toDouble(),
      uvIndex: json['uvIndex'] as int,
      condition: json['condition'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      rainfall: (json['rainfall'] as num?)?.toDouble() ?? 0.0,
      hasAlert: json['hasAlert'] as bool? ?? false,
      alertMessage: json['alertMessage'] as String?,
      alertType: json['alertType'] as String?,
    );
  }
}

// * WEATHER FORECAST MODEL
class WeatherForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final double rainProbability;
  final String? cropAdvice;

  const WeatherForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.rainProbability,
    this.cropAdvice,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: DateTime.parse(json['date'] as String),
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      rainProbability: (json['rainProbability'] as num).toDouble(),
      cropAdvice: json['cropAdvice'] as String?,
    );
  }
}

// * WEATHER RESPONSE MODEL
class WeatherResponse {
  final WeatherData current;
  final List<WeatherForecast> forecast;
  final String? location;
  final DateTime? lastUpdated;

  const WeatherResponse({
    required this.current,
    required this.forecast,
    this.location,
    this.lastUpdated,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: WeatherData.fromJson(json['current'] as Map<String, dynamic>),
      forecast: (json['forecast'] as List)
          .map((e) => WeatherForecast.fromJson(e as Map<String, dynamic>))
          .toList(),
      location: json['location'] as String?,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }
}
