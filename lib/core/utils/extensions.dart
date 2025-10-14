import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

/// Extension methods for String
extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  /// Capitalizes the first letter of each word
  String get capitalizeWords {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Checks if string is a valid email
  bool get isValidEmail {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(this);
  }

  /// Removes all whitespace from string
  String get removeWhitespace {
    return replaceAll(RegExp(r'\s+'), '');
  }

  /// Checks if string is null or empty
  bool get isNullOrEmpty {
    return isEmpty;
  }

  /// Checks if string is not null and not empty
  bool get isNotNullOrEmpty {
    return isNotEmpty;
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - 3)}...';
  }
}

/// Extension methods for DateTime
extension DateTimeExtensions on DateTime {
  /// Checks if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Checks if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Checks if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  /// Gets time ago string
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 0) {
      return '${difference.inDays} día${difference.inDays > 1 ? 's' : ''} atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hora${difference.inHours > 1 ? 's' : ''} atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''} atrás';
    } else {
      return 'Ahora';
    }
  }

  /// Formats date as dd/MM/yyyy
  String get formatDate {
    return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year';
  }

  /// Formats time as HH:mm
  String get formatTime {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

/// Extension methods for BuildContext
extension BuildContextExtensions on BuildContext {
  /// Gets screen size
  Size get screenSize => MediaQuery.of(this).size;

  /// Gets screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Gets screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Gets theme data
  ThemeData get theme => Theme.of(this);

  /// Gets text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Gets color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Shows snackbar with message
  void showSnackBar(String message,
      {Color? backgroundColor, Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Shows error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.red);
  }

  /// Shows success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(message, backgroundColor: Colors.green);
  }

  /// Checks if device is in dark mode
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Gets safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Checks if keyboard is visible
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;
}

/// Extension methods for List
extension ListExtensions<T> on List<T> {
  /// Safely gets element at index
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }

  /// Checks if list is null or empty
  bool get isNullOrEmpty => isEmpty;

  /// Checks if list is not null and not empty
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Gets random element from list
  T? get randomElement {
    if (isEmpty) return null;
    return this[(DateTime.now().millisecondsSinceEpoch % length)];
  }
}

/// Extension methods for LatLng
extension LatLngExtensions on LatLng {
  /// Calculates distance to another point in meters
  double distanceTo(LatLng other) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, this, other);
  }

  /// Formats coordinates as string
  String get formatted {
    return '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}';
  }

  /// Checks if coordinates are valid
  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }
}

/// Extension methods for Duration
extension DurationExtensions on Duration {
  /// Formats duration as human readable string
  String get formatted {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}min';
    } else if (minutes > 0) {
      return '${minutes}min ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Gets short format (e.g., "5m", "2h")
  String get shortFormat {
    if (inHours > 0) {
      return '${inHours}h';
    } else if (inMinutes > 0) {
      return '${inMinutes}m';
    } else {
      return '${inSeconds}s';
    }
  }
}

/// Extension methods for double
extension DoubleExtensions on double {
  /// Rounds to specified decimal places
  double roundToDecimalPlaces(int decimalPlaces) {
    final factor = 1.0 * (10 * decimalPlaces);
    return (this * factor).round() / factor;
  }

  /// Formats as currency
  String get asCurrency {
    return '\$${toStringAsFixed(0)}';
  }

  /// Formats as percentage
  String get asPercentage {
    return '${(this * 100).round()}%';
  }
}

