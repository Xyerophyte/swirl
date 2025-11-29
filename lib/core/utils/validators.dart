/// Input Validation Utilities
/// Provides comprehensive validation for user inputs across the application
class Validators {
  // Private constructor to prevent instantiation
  Validators._();

  /// Validate email address
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    // RFC 5322 compliant email regex (simplified)
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validate required field
  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < min) {
      return '$fieldName must be at least $min characters';
    }

    return null;
  }

  /// Validate maximum length
  static String? maxLength(
    String? value,
    int max, {
    String fieldName = 'This field',
  }) {
    if (value == null) return null;

    if (value.length > max) {
      return '$fieldName must not exceed $max characters';
    }

    return null;
  }

  /// Validate length range
  static String? lengthRange(
    String? value,
    int min,
    int max, {
    String fieldName = 'This field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < min || value.length > max) {
      return '$fieldName must be between $min and $max characters';
    }

    return null;
  }

  /// Validate username
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }

    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }

    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }

    // Only alphanumeric, underscores, and hyphens
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, underscores, and hyphens';
    }

    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (value.length > 128) {
      return 'Password is too long';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validate phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    // Remove common formatting characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10 || digitsOnly.length > 15) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validate URL
  static String? url(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL is required';
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || (!uri.scheme.startsWith('http'))) {
        return 'Please enter a valid URL';
      }
    } catch (e) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Validate numeric value
  static String? numeric(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }

    return null;
  }

  /// Validate integer value
  static String? integer(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (int.tryParse(value) == null) {
      return '$fieldName must be a whole number';
    }

    return null;
  }

  /// Validate range (min-max)
  static String? range(
    num? value,
    num min,
    num max, {
    String fieldName = 'Value',
  }) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Validate price (positive number with up to 2 decimal places)
  static String? price(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    // Check for max 2 decimal places
    if (value.contains('.') && value.split('.')[1].length > 2) {
      return 'Price can have at most 2 decimal places';
    }

    return null;
  }

  /// Validate search query
  static String? searchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Search query cannot be empty';
    }

    if (value.trim().length < 2) {
      return 'Search query must be at least 2 characters';
    }

    if (value.length > 100) {
      return 'Search query is too long';
    }

    // Check for SQL injection patterns (basic protection)
    final dangerousPatterns = [
      'DROP',
      'DELETE',
      'INSERT',
      'UPDATE',
      'ALTER',
      'CREATE',
      '--',
      ';',
    ];

    final upperValue = value.toUpperCase();
    for (final pattern in dangerousPatterns) {
      if (upperValue.contains(pattern)) {
        return 'Search query contains invalid characters';
      }
    }

    return null;
  }

  /// Combine multiple validators
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  }

  /// Sanitize HTML/script tags from input
  static String sanitize(String value) {
    return value
        .replaceAll(RegExp(r'<script[^>]*>.*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .trim();
  }
}