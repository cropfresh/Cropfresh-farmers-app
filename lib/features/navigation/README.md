# CropFresh Navigation System

## Overview

The CropFresh navigation system provides a comprehensive bottom navigation interface designed specifically for farmers. It follows Material Design 3 principles and implements a clean, intuitive user experience with a prominent Sell action.

## Architecture

### Main Components

1. **MainNavigationWrapper** - Central navigation controller
2. **Bottom Navigation Bar** - 4 main tabs with space for FAB
3. **Floating Action Button (FAB)** - Prominent "Sell" action
4. **Individual Screen Components** - Modular screen implementations

## Navigation Structure

```
Bottom Navigation:
├── Home (Dashboard)           🏠
├── Marketplace               🏪
├── [FAB - Sell]              ➕ (Modal)
├── My Orders                 📋
└── Profile                   👤

Additional:
└── Services (Accessible via Profile or dedicated routes)
```

## Tab Breakdown

### 1. Home Tab 🏠
- **Icon**: House icon (home_outlined/home)
- **Purpose**: Main dashboard showing key farmer information
- **Content**: 
  - Today's local mandi prices ("Price Beacon")
  - Summary of new buy orders from marketplace
  - Weather information
  - Quick actions
  - Notifications panel

### 2. Marketplace Tab 🏪
- **Icon**: Storefront icon (storefront_outlined/storefront)
- **Purpose**: Central place for purchasing agricultural inputs
- **Content**:
  - Searchable and filterable product catalog
  - Categories: Seeds, Fertilizers, Pesticides, Tools, Saplings
  - Product cards with images, prices, and "Add to Cart" functionality
  - Advanced filtering options

### 3. Sell FAB ➕
- **Icon**: Large plus (+) sign with gradient background
- **Purpose**: Most important farmer action - creating produce listings
- **Implementation**: 
  - Floating Action Button positioned at bottom center
  - Opens as modal bottom sheet (90% screen height)
  - Draggable and scrollable interface
- **Content**:
  - Comprehensive product listing form
  - Product details (name, category, quality grade)
  - Pricing and quantity with unit selection
  - Description and location fields
  - Photo upload interface
  - Organic product checkbox

### 4. My Orders Tab 📋
- **Icon**: List/clipboard icon (list_alt_outlined/list_alt)
- **Purpose**: Consolidated tracking of all transactions
- **Content**:
  - **My Sales Tab**: Status of produce listings and sales
  - **My Purchases Tab**: Status of input and sapling orders
  - Order cards with status indicators
  - Detailed order information and tracking

### 5. Profile Tab 👤
- **Icon**: Person icon (person_outline/person)
- **Purpose**: Account management and app settings
- **Content**:
  - User profile information with avatar
  - Account settings (Personal Info, Farm Details, Privacy)
  - App settings (Language, Notifications, Theme)
  - Help & Support (Help Center, Contact Support, Feedback)
  - About section (App Version, Terms, Privacy Policy)
  - Logout functionality

### 6. Services 🛠️
- **Access**: Via dedicated service cards or navigation
- **Purpose**: Additional agricultural services and tools
- **Content**:
  - Weather & Advisory (Forecasts, Crop Advisory, Pest Alerts)
  - Financial Services (Loans, Insurance, Market Analysis)
  - Education & Training (Courses, Tutorials, Expert Consultation)
  - Technology & Tools (Calculators, Satellite Monitoring, IoT)

## Technical Implementation

### State Management
- **StatefulWidget** with PageController for smooth navigation
- **TabController** for sub-navigation within screens
- Form validation and state management in Sell screen
- Animation controllers for FAB and transitions

### Navigation Flow
```dart
MainNavigationWrapper
├── PageView (for main tabs)
│   ├── DashboardScreenV2 (Home)
│   ├── MarketplaceScreen
│   ├── MyOrdersScreen  
│   └── ProfileScreen
├── FloatingActionButton (Sell)
└── Modal BottomSheet (SellScreen)
```

### Key Features

#### Bottom Navigation Bar
- Custom-built navigation with Material Design 3 styling
- Active/inactive states with color-coded indicators
- Proper spacing for center-docked FAB
- Responsive design for different screen sizes

#### Floating Action Button
- Gradient background (orange primary to vibrant)
- Scale animation on load
- Haptic feedback on press
- Prominent positioning for primary action

#### Modal Implementation
- **DraggableScrollableSheet** for sell interface
- Configurable sheet sizes (50% min, 95% max, 90% initial)
- Smooth scrolling with custom scroll controller
- Proper keyboard handling and form validation

### Design System Integration

#### Colors (60-30-10 Rule)
- **60%**: Light backgrounds for main content areas
- **30%**: Green colors for navigation, agricultural elements
- **10%**: Orange colors for CTAs, FAB, and highlights

#### Typography
- Material Design 3 typography scale
- Responsive font sizes based on screen size
- Proper contrast ratios for accessibility

#### Spacing & Layout
- Consistent padding and margins
- Responsive layout for small and large screens
- Proper safe area handling

## Usage Examples

### Basic Navigation Setup
```dart
// In main app routing
MaterialApp(
  home: MainNavigationWrapper(
    userProfile: currentUser,
  ),
)
```

### Custom Navigation
```dart
// Navigate to specific tab
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => MainNavigationWrapper(
      userProfile: userProfile,
      initialIndex: 2, // Orders tab
    ),
  ),
);
```

### Modal Sell Screen
```dart
// The FAB automatically handles this, but can be called manually:
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.9,
    builder: (context, scrollController) => SellScreen(
      userProfile: userProfile,
      scrollController: scrollController,
    ),
  ),
);
```

## Accessibility Features

- **Screen Reader Support**: Proper semantic labels and descriptions
- **Keyboard Navigation**: Full keyboard accessibility
- **High Contrast**: Proper color contrast ratios
- **Touch Targets**: Minimum 44px touch targets
- **Responsive Text**: Respects system text scaling

## Performance Considerations

- **Lazy Loading**: Screens loaded only when needed
- **Memory Management**: Proper disposal of controllers and listeners
- **Animation Optimization**: Efficient animations with proper curves
- **Image Optimization**: Placeholder icons for missing images

## Future Enhancements

1. **Push Notifications**: Integrate with orders and marketplace updates
2. **Offline Support**: Cache critical data for offline access
3. **Advanced Search**: Enhanced search and filtering capabilities
4. **Real-time Updates**: Live updates for prices and orders
5. **Accessibility Improvements**: Enhanced screen reader support
6. **Internationalization**: Multi-language support
7. **Dark Theme**: Full dark mode implementation

## Testing Strategy

- **Unit Tests**: Test navigation logic and state management
- **Widget Tests**: Test individual screen components
- **Integration Tests**: Test complete navigation flows
- **Accessibility Tests**: Ensure compliance with accessibility standards

## Maintenance Guidelines

1. **State Management**: Keep navigation state minimal and focused
2. **Performance**: Monitor animation performance and memory usage
3. **Accessibility**: Regular accessibility audits
4. **Design Consistency**: Maintain Material Design 3 principles
5. **User Feedback**: Incorporate farmer feedback for improvements

## Dependencies

- `flutter/material.dart` - Material Design components
- `flutter/services.dart` - System services (haptic feedback)
- Core theme system for consistent styling
- User profile models for personalization

This navigation system provides a solid foundation for the CropFresh farmer application, prioritizing ease of use, accessibility, and the most important farmer workflows. 