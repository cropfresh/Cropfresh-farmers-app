# CropFresh Farmers App 🌱

[![Flutter Version](https://img.shields.io/badge/Flutter-3.24.0+-blue.svg)](https://flutter.dev/)
[![Dart Version](https://img.shields.io/badge/Dart-3.5.0+-blue.svg)](https://dart.dev/)
[![Material 3](https://img.shields.io/badge/Material-3.0-green.svg)](https://m3.material.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-green.svg)](/.github/workflows/)

A modern, feature-rich mobile application designed to empower farmers with cutting-edge agricultural technologies, market insights, and offline-first capabilities. Built with Flutter and Material 3 design system.

## 📋 Table of Contents

- [🌟 Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🎨 Design System](#-design-system)
- [🛠️ Technologies](#️-technologies)
- [📱 Platform Support](#-platform-support)
- [🚀 Getting Started](#-getting-started)
- [📦 Dependencies](#-dependencies)
- [🏃‍♂️ Running the App](#️-running-the-app)
- [🧪 Testing](#-testing)
- [📖 Development Guidelines](#-development-guidelines)
- [🔄 CI/CD Pipeline](#-cicd-pipeline)
- [📚 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📜 License](#-license)

## 🌟 Features

### 🌾 Core Agricultural Features
- **Smart Crop Management**: AI-powered crop health monitoring and disease detection
- **Weather Intelligence**: Real-time weather data with agricultural insights
- **Soil Analysis**: Digital soil health assessment and recommendations
- **Irrigation Management**: Smart watering schedules and water usage optimization
- **Pest & Disease Control**: Early warning systems and treatment recommendations

### 📈 Market & Financial Tools
- **Real-time Market Prices**: Live commodity pricing from multiple markets
- **Price Trend Analysis**: Historical data and predictive analytics
- **Financial Planning**: Crop budgeting and profit/loss tracking
- **Insurance Integration**: Crop insurance management and claims processing

### 📱 Smart Features
- **Offline-First Architecture**: Full functionality without internet connectivity
- **AI-Powered Insights**: Machine learning recommendations for optimal farming
- **Multi-language Support**: Localized content for diverse farming communities
- **Voice Commands**: Hands-free operation for field use
- **Photo Analysis**: Instant crop health assessment through camera

### 🔗 Connectivity Features
- **IoT Integration**: Connect with smart farming sensors and devices
- **Expert Network**: Direct communication with agricultural experts
- **Community Forums**: Farmer-to-farmer knowledge sharing
- **Supply Chain Tracking**: From seed to market traceability

## 🏗️ Architecture

CropFresh follows **Clean Architecture** principles with a feature-based modular approach:

```
lib/
├── core/                          # Core application infrastructure
│   ├── config/                    # App configuration and constants
│   ├── error/                     # Error handling and exceptions
│   ├── network/                   # Network services and connectivity
│   ├── storage/                   # Local storage and caching
│   ├── theme/                     # Design system and theming
│   │   └── colors.dart           # 60-30-10 color system
│   └── utils/                     # Utility functions and helpers
├── features/                      # Feature-based modules
│   ├── authentication/            # User authentication & authorization
│   │   ├── data/                 # Data sources and repositories
│   │   ├── domain/               # Business logic and entities
│   │   └── presentation/         # UI components and controllers
│   ├── dashboard/                # Main dashboard and navigation
│   ├── crop_management/          # Crop monitoring and management
│   ├── weather/                  # Weather services and forecasting
│   ├── market/                   # Market prices and trading
│   ├── financial/                # Financial planning and tracking
│   ├── community/                # Social features and forums
│   └── settings/                 # App settings and preferences
├── shared/                       # Shared components and utilities
│   ├── components/               # Reusable UI components
│   ├── services/                 # Global services
│   └── models/                   # Shared data models
└── main.dart                     # Application entry point
```

### 🧱 Architecture Layers

1. **Presentation Layer**: Flutter widgets, controllers (Riverpod), and UI state management
2. **Domain Layer**: Business logic, use cases, and entities
3. **Data Layer**: Repositories, data sources, and API services
4. **Infrastructure Layer**: External services, databases, and third-party integrations

## 🎨 Design System

### Material 3 Implementation
- **Dynamic Color System**: Adaptive theming based on user preferences
- **Component Library**: Custom Material 3 components optimized for agricultural workflows
- **Accessibility First**: WCAG 2.1 AA compliance with high contrast and screen reader support
- **Responsive Design**: Optimized layouts for phones, tablets, and foldable devices

### 🎨 Color System (60-30-10 Rule)

```dart
// 60% - Light & Warm Backgrounds (Dominant)
CropFreshColors.background60Primary     // Main backgrounds
CropFreshColors.background60Card        // Card surfaces

// 30% - Green Colors (Supporting, Agricultural Identity)
CropFreshColors.green30Primary          // Navigation, branding
CropFreshColors.green30Light            // Success states, indicators

// 10% - Orange Colors (Highlights, Actions & CTAs)
CropFreshColors.orange10Primary         // Primary action buttons
CropFreshColors.orange10Bright          // Call-to-action elements
```

### 🌙 Dark Mode Support
- Complete dark theme implementation following Material 3 guidelines
- Automatic system theme detection
- Manual theme override options
- Optimized for low-light farming conditions

## 🛠️ Technologies

### 🎯 Core Technologies
- **Flutter 3.24.0+**: Cross-platform mobile development framework
- **Dart 3.5.0+**: Modern programming language for Flutter
- **Material 3**: Latest Material Design system implementation

### 📊 State Management & Architecture
- **Riverpod 2.5.0+**: Modern state management with dependency injection
- **Freezed**: Immutable data classes and union types
- **Clean Architecture**: Separation of concerns and testable code

### 🌐 Backend & APIs
- **Dio**: HTTP client for API communication
- **Retrofit**: Type-safe API client generation
- **WebSocket**: Real-time data streaming for live updates

### 💾 Data Persistence
- **Hive**: Lightweight, fast key-value database for offline storage
- **SQLite**: Relational database for complex data relationships
- **Shared Preferences**: Simple key-value storage

### 🗺️ Navigation & Routing
- **AutoRoute**: Code generation for type-safe navigation
- **Go Router**: Declarative routing with deep linking support

### 🌍 Localization & Accessibility  
- **Flutter Localizations**: Multi-language support
- **Intl**: Internationalization and formatting
- **Semantics**: Screen reader and accessibility support

### 📸 Media & Sensors
- **Camera**: Crop photo analysis and documentation
- **Image Picker**: Gallery and camera image selection
- **Geolocator**: GPS location for field mapping
- **Permission Handler**: Runtime permissions management

### 📈 Analytics & Monitoring
- **Firebase Analytics**: User behavior tracking
- **Crashlytics**: Crash reporting and monitoring
- **Performance Monitoring**: App performance insights

### 🧪 Testing & Quality Assurance
- **Flutter Test**: Unit and widget testing framework
- **Mockito**: Mocking framework for unit tests
- **Integration Test**: End-to-end testing
- **Test Coverage**: Code coverage reporting

## 📱 Platform Support

| Platform | Version | Status |
|----------|---------|--------|
| **Android** | API 21+ (Android 5.0+) | ✅ Primary |
| **iOS** | iOS 12.0+ | ✅ Primary |
| **Web** | Modern browsers | 🚧 Beta |
| **Windows** | Windows 10+ | 📋 Planned |
| **macOS** | macOS 10.14+ | 📋 Planned |
| **Linux** | Ubuntu 18.04+ | 📋 Planned |

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.24.0 or higher
- **Dart SDK**: 3.5.0 or higher
- **Android Studio / VS Code**: Latest version with Flutter extensions
- **Git**: Version control system

### Development Environment Setup

1. **Install Flutter**:
   ```bash
   # macOS (using homebrew)
   brew install flutter
   
   # Windows (using chocolatey)
   choco install flutter
   
   # Linux (manual installation)
   wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.0-stable.tar.xz
   ```

2. **Verify Installation**:
   ```bash
   flutter doctor -v
   ```

3. **Clone Repository**:
   ```bash
   git clone https://github.com/your-org/cropfresh-farmers-app.git
   cd cropfresh-farmers-app
   ```

4. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

## 📦 Dependencies

### 🔧 Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management & Architecture
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  
  # UI & Material Design
  material_color_utilities: ^0.11.1
  dynamic_color: ^1.7.0
  
  # Navigation
  auto_route: ^8.3.0
  
  # Network & API
  dio: ^5.6.0
  retrofit: ^4.2.0
  connectivity_plus: ^6.0.5
  
  # Local Storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  shared_preferences: ^2.3.2
  
  # Device Features
  camera: ^0.11.0+2
  geolocator: ^12.0.0
  permission_handler: ^11.3.1
  
  # Utilities
  intl: ^0.19.0
  path_provider: ^2.1.4
  
dev_dependencies:
  # Code Generation
  build_runner: ^2.4.12
  riverpod_generator: ^2.4.3
  freezed: ^2.5.7
  json_serializable: ^6.8.0
  auto_route_generator: ^8.1.0
  
  # Testing
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
  integration_test:
    sdk: flutter
```

## 🏃‍♂️ Running the App

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run with specific flavor
flutter run --flavor development
flutter run --flavor staging
flutter run --flavor production

# Run with specific device
flutter run -d <device-id>

# Run with hot reload enabled (default)
flutter run --hot
```

### Build Modes
```bash
# Debug build (development)
flutter run --debug

# Profile build (performance testing)
flutter run --profile

# Release build (production)
flutter run --release
```

## 🧪 Testing

### 🎯 Testing Strategy

Following the **Testing Pyramid** approach:
- **70% Unit Tests**: Business logic and utility functions
- **20% Integration Tests**: Feature workflows and API interactions  
- **10% End-to-End Tests**: Complete user journeys

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/authentication/login_test.dart

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Test Structure
```dart
// 🧪 Unit Test Example (AAA Pattern)
void main() {
  group('CropHealthCalculator', () {
    late CropHealthCalculator calculator;
    
    setUp(() {
      // * ARRANGE: Set up test dependencies
      calculator = CropHealthCalculator();
    });
    
    testWidgets('should calculate crop health correctly', (tester) async {
      // * ARRANGE: Prepare test data
      final inputCropData = CropData(
        soilMoisture: 65.0,
        temperature: 25.0,
        humidity: 70.0,
      );
      const expectedHealthScore = 85.0;
      
      // * ACT: Execute the function under test
      final actualHealthScore = calculator.calculateHealth(inputCropData);
      
      // * ASSERT: Verify the results
      expect(actualHealthScore, equals(expectedHealthScore));
    });
  });
}
```

## 📖 Development Guidelines

### 🎯 Code Quality Standards

#### Better Comments Usage
```dart
// * MAIN CROP MONITORING FEATURE
// ! SECURITY: This handles sensitive farmer data
class CropMonitoringService {
  
  // ? TODO: Implement ML-based disease detection
  Future<CropHealth> analyzeCropHealth(String imageUrl) async {
    // NOTE: Using TensorFlow Lite for on-device inference
    // OPTIMIZE: Consider caching model predictions
    
    try {
      // * Process the crop image for analysis
      final processedImage = await _preprocessImage(imageUrl);
      
      // ! ALERT: Ensure image validation before processing
      if (processedImage == null) {
        // FIXME: Implement proper error handling
        throw Exception('Invalid image data');
      }
      
      return await _runInference(processedImage);
    } catch (error) {
      // HACK: Temporary fallback to manual analysis
      return _getFallbackAnalysis();
    }
  }
}
```

#### Function Standards
```dart
// * USER AUTHENTICATION HANDLER
// SECURITY: Handles sensitive authentication data
Future<AuthResult> authenticateUser({  
  required String email,
  required String password,
  bool rememberMe = false,
}) async {
  // ! IMPORTANT: Input validation is critical for security
  _validateUserInput(email, password);
  
  try {
    // * Authenticate with backend service
    final authResponse = await _authService.signIn(email, password);
    
    // * Store authentication tokens securely
    if (rememberMe) {
      await _secureStorage.storeTokens(authResponse.tokens);
    }
    
    return AuthResult.success(user: authResponse.user);
  } on NetworkException catch (error) {
    // NOTE: Network errors should be handled gracefully
    return AuthResult.failure(message: 'Network connection failed');
  } catch (error) {
    // FIXME: Implement specific error handling for different auth failures
    return AuthResult.failure(message: 'Authentication failed');
  }
}
```

### 📁 File Organization
- **Single Responsibility**: Each file should have one primary purpose
- **Maximum 750 lines**: Split larger files into logical modules
- **Feature-based grouping**: Organize by business domain, not technical layers

### 🎨 UI/UX Guidelines
- **Material 3 Components**: Use official Material 3 widgets
- **60-30-10 Color Rule**: Follow the defined color system
- **Accessibility First**: Implement semantic labels and high contrast
- **Responsive Design**: Support multiple screen sizes and orientations

## 🔄 CI/CD Pipeline

### GitHub Actions Workflows

#### 🔍 Continuous Integration (`ci.yml`)
```yaml
name: Continuous Integration

on:
  push:
    branches: [ "main", "develop" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Analyze code
        run: flutter analyze
        
      - name: Run tests
        run: flutter test --coverage
        
      - name: Build APK
        run: flutter build apk --debug
```

#### 🚀 Continuous Deployment (`cd.yml`)
```yaml
name: Continuous Deployment

on:
  push:
    branches: [ "main" ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          
      - name: Build and deploy to Play Store
        env:
          PLAY_STORE_CREDENTIALS: ${{ secrets.PLAY_STORE_CREDENTIALS }}
        run: |
          flutter build appbundle --release
          fastlane deploy
```

### 🌟 Quality Gates
- **Code Coverage**: Minimum 80% coverage required
- **Static Analysis**: Zero critical issues allowed
- **Security Scan**: Automated vulnerability detection
- **Performance Testing**: Memory and CPU usage validation

## 📚 Documentation

### 📖 Documentation Structure
```
docs/
├── api/                    # API documentation
├── architecture/           # System architecture diagrams
├── design-system/         # UI/UX design guidelines
├── deployment/            # Deployment guides
├── features/              # Feature-specific documentation
└── testing/               # Testing strategies and guides
```

### 🎯 Code Documentation Requirements
- **Function Headers**: Every public function must have comprehensive documentation
- **Better Comments**: Use the standard comment system throughout
- **API Documentation**: All REST endpoints documented with OpenAPI
- **Architecture Decisions**: Document major technical decisions

## 🤝 Contributing

### 🔄 Git Workflow

1. **Create Feature Branch**:
   ```bash
   git checkout develop
   git checkout -b feature/crop-health-monitoring
   ```

2. **Follow Conventional Commits**:
   ```bash
   git commit -m "feat(crop-health): implement ML-based disease detection"
   git commit -m "fix(auth): resolve token refresh issue"
   git commit -m "docs(readme): update setup instructions"
   ```

3. **Create Pull Request**:
   - Target: `develop` branch
   - Include: Comprehensive description, screenshots, testing notes
   - Require: At least one code review approval

### 📋 Pull Request Template
```markdown
## Description
Brief summary of changes and motivation

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots
[Add relevant screenshots or GIFs]

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Better Comments implemented
- [ ] Documentation updated
- [ ] No new warnings generated
```

### 🛡️ Branch Protection Rules
- **Require pull request reviews**: Minimum 1 approval
- **Require status checks**: All CI tests must pass
- **Require up-to-date branches**: Must be current with target branch
- **Include administrators**: Apply rules to all contributors

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🚀 Quick Start Commands

```bash
# Initial setup
git clone https://github.com/your-org/cropfresh-farmers-app.git
cd cropfresh-farmers-app
flutter pub get

# Development
flutter run                    # Run app in debug mode
flutter test                   # Run all tests
flutter analyze               # Static code analysis

# Building
flutter build apk --release    # Android APK
flutter build ios --release    # iOS build
flutter build web             # Web build

# Code generation
flutter packages pub run build_runner build --delete-conflicting-outputs
```

---

<div align="center">

**Built with ❤️ for farmers worldwide**

🌱 **Empowering Agriculture Through Technology** 🌱

[Website](https://cropfresh.app) • [Documentation](https://docs.cropfresh.app) • [Support](mailto:support@cropfresh.app)

</div>
