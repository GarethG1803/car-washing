/// Reusable form-field validators for the CleanRide app.
///
/// Each method returns `null` when the input is valid, or an error
/// message [String] when it is not — matching the signature expected
/// by Flutter's [TextFormField.validator].
class Validators {
  Validators._();

  /// Ensures the field is not null or empty.
  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates a well-formed email address.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!regex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  /// Validates a phone number (digits only, 7-15 characters, optional leading +).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    final regex = RegExp(r'^\+?\d{7,15}$');
    if (!regex.hasMatch(cleaned)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  /// Validates a strong password: minimum 8 characters, at least one
  /// uppercase letter and at least one digit.
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Validates that the confirmation matches the original [password].
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Ensures the value has at least [min] characters.
  static String? minLength(String? value, int min) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    if (value.trim().length < min) {
      return 'Must be at least $min characters';
    }
    return null;
  }
}
