class AppConstants {
  static const String appName = 'Shifor';
  static const String appVersion = '1.0.0';
  
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int otpLength = 6;
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  
  static const List<String> licenseTypes = ['B', 'C', 'D', 'CE'];
  static const List<String> languages = ['English', 'French', 'Arabic', 'Spanish', 'German'];
  
  static const String databaseName = 'shifor';
  static const int cacheExpiration = 24;
  
  // Error messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailInUse = 'This email is already registered.';
  static const String weakPassword = 'Password is too weak.';
  static const String invalidEmail = 'Please enter a valid email.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String requiredField = 'This field is required.';
  static const String uploadFailed = 'Failed to upload file. Please try again.';
  static const String locationDenied = 'Location permission denied.';
  
  static String getAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'email-already-in-use':
        return emailInUse;
      case 'weak-password':
        return weakPassword;
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return unknownError;
    }
  }
}

class StorageKeys {
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String isEmailVerified = 'is_email_verified';
  static const String isPhoneVerified = 'is_phone_verified';
  static const String profileCompleted = 'profile_completed';
  static const String lastSync = 'last_sync';
}

class FirestoreCollections {
  static const String users = 'users';
  static const String drivers = 'drivers';
  static const String companies = 'companies';
  static const String jobs = 'jobs';
  static const String applications = 'applications';
  static const String references = 'references';
}

class UserRoles {
  static const String driver = 'driver';
  static const String company = 'company';
  static const String agency = 'agency';
  
  static const List<String> all = [driver, company, agency];
}

class VerificationStatus {
  static const String pending = 'pending';
  static const String verified = 'verified';
  static const String rejected = 'rejected';
}

class ApplicationStatus {
  static const String pending = 'pending';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';
}

class ErrorMessages {
  static const String networkError = 'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unknownError = 'An unexpected error occurred.';
  static const String invalidCredentials = 'Invalid email or password.';
  static const String emailInUse = 'This email is already registered.';
  static const String weakPassword = 'Password is too weak.';
  static const String invalidEmail = 'Please enter a valid email.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String requiredField = 'This field is required.';
  static const String uploadFailed = 'Failed to upload file. Please try again.';
  static const String locationDenied = 'Location permission denied.';
  
  static String getAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'email-already-in-use':
        return emailInUse;
      case 'weak-password':
        return weakPassword;
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return unknownError;
    }
  }
}