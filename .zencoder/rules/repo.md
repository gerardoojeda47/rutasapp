---
description: Repository Information Overview
alwaysApply: true
---

# RouWhite Information

## Summary
RouWhite is a Flutter mobile application that provides real-time information about public transportation routes in Popayán, Colombia. The app allows users to search for routes, track buses, check stops, and manage their user profile. It features a modern Material Design interface with a focus on usability and accessibility.

## Structure
- **lib/**: Core application code
  - **main.dart**: Application entry point
  - **view/**: UI pages and components
  - **model/**: Data models
  - **data/**: Data sources and repositories
  - **core/**: Core utilities, constants, and services
  - **domain/**: Business logic and use cases
- **assets/**: Application assets (animations, images)
- **test/**: Test files
- **android/**, **ios/**, **web/**, **linux/**, **macos/**, **windows/**: Platform-specific code

## Language & Runtime
**Language**: Dart
**Version**: SDK >=3.2.3 <4.0.0
**Framework**: Flutter
**Build System**: Flutter build system
**Package Manager**: pub (Flutter/Dart package manager)

## Dependencies
**Main Dependencies**:
- **UI and Icons**: cupertino_icons, flutter_vector_icons, lottie, flutter_animate
- **Maps and Location**: flutter_map, latlong2, flutter_polyline_points, geolocator
- **State Management**: provider
- **Data and Storage**: shared_preferences, equatable
- **Network and API**: dio, connectivity_plus, geocoding
- **Utilities**: dartz, intl
- **Voice and Audio**: flutter_tts, permission_handler

**Development Dependencies**:
- **Linting and Code Quality**: flutter_lints, very_good_analysis
- **Testing**: mockito, build_runner, json_annotation, json_serializable
- **Integration Testing**: integration_test

## Build & Installation
```bash
# Install dependencies
flutter pub get

# Run the application
flutter run

# Build for Android
flutter build apk --release

# Build for iOS
flutter build ios --release
```

## Testing
**Framework**: Flutter test
**Test Location**: test/ directory
**Integration Tests**: integration_test/ directory
**Run Command**:
```bash
# Run unit and widget tests
flutter test

# Run integration tests
flutter test integration_test
```

## Features
- **Route Management**: Complete list of routes with detailed information
- **Route Search**: Search by origin and destination with advanced filters
- **Bus Tracking**: Real-time tracking of specific buses
- **Stop Management**: Stops organized by communes with route information
- **User Profile**: Personal information, transport card, favorite routes
- **Maps Integration**: Route visualization on maps