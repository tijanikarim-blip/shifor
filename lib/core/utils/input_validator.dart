class InputValidator {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp _phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
  
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    if (value.length > 254) {
      return 'Email is too long';
    }
    return null;
  }
  
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value.length > 128) {
      return 'Password is too long';
    }
    return null;
  }
  
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
  
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    final cleanPhone = value.replaceAll(RegExp(r'[\s\-()]'), '');
    if (!_phoneRegex.hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }
  
  static String? validateRequired(String? value, [String fieldName = 'This field']) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    if (value.length < 2) {
      return 'Name is too short';
    }
    if (value.length > 100) {
      return 'Name is too long';
    }
    return null;
  }
  
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    return null;
  }
  
  static String? validateNumber(String? value, {int? min, int? max}) {
    if (value == null || value.isEmpty) {
      return 'Number is required';
    }
    final number = int.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }
    if (min != null && number < min) {
      return 'Minimum value is $min';
    }
    if (max != null && number > max) {
      return 'Maximum value is $max';
    }
    return null;
  }
  
  static String sanitizeEmail(String value) {
    return value.trim().toLowerCase();
  }
  
  static String sanitizeName(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static String sanitizePhone(String value) {
    return value.replaceAll(RegExp(r'[\s\-()]'), '');
  }
}