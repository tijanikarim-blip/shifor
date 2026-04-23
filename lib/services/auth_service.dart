import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../core/constants/app_constants.dart';
import '../../core/utils/input_validator.dart';
import '../../data/models/data_models.dart';
import '../../data/repositories/user_repository.dart';

class AuthService {
  final auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;
  
  AuthService({
    auth.FirebaseAuth? firebaseAuth,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _userRepository = userRepository ?? UserRepository();
  
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return await _userRepository.getUser(firebaseUser.uid);
    });
  }
  
  UserModel? get currentUser {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return UserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName ?? '',
      phone: firebaseUser.phoneNumber ?? '',
      role: '',
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }
  
  String? get currentUserId => _firebaseAuth.currentUser?.uid;
  
  Future<AuthResult<UserModel>> signIn(String email, String password) async {
    try {
      final sanitizedEmail = InputValidator.sanitizeEmail(email);
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: sanitizedEmail,
        password: password,
      );
      
      if (credential.user == null) {
        return AuthResult.failure(AppConstants.unknownError);
      }
      
      final user = await _userRepository.getUser(credential.user!.uid);
      if (user == null) {
        return AuthResult.failure('User data not found');
      }
      
      return AuthResult.success(user);
    } on auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(AppConstants.getAuthError(e.code));
    } catch (e) {
      return AuthResult.failure(AppConstants.serverError);
    }
  }
  
  Future<AuthResult<UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    try {
      final sanitizedEmail = InputValidator.sanitizeEmail(email);
      final sanitizedName = InputValidator.sanitizeName(name);
      final sanitizedPhone = InputValidator.sanitizePhone(phone);
      
      final existingUser = await _userRepository.emailExists(sanitizedEmail);
      if (existingUser) {
        return AuthResult.failure(AppConstants.emailInUse);
      }
      
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: sanitizedEmail,
        password: password,
      );
      
      if (credential.user == null) {
        return AuthResult.failure(AppConstants.unknownError);
      }
      
      await credential.user!.updateProfile(displayName: sanitizedName);
      
      final userData = {
        'name': sanitizedName,
        'email': sanitizedEmail,
        'phone': sanitizedPhone,
        'role': role,
        'isVerified': false,
        'isEmailVerified': false,
        'isPhoneVerified': false,
        'profileCompleted': false,
        'createdAt': DateTime.now().toIso8601String(),
      };
      
      await _userRepository.createUser(credential.user!.uid, userData);
      
      final user = UserModel(
        id: credential.user!.uid,
        name: sanitizedName,
        email: sanitizedEmail,
        phone: sanitizedPhone,
        role: role,
        createdAt: DateTime.now(),
      );
      
      return AuthResult.success(user);
    } on auth.FirebaseAuthException catch (e) {
      return AuthResult.failure(AppConstants.getAuthError(e.code));
    } catch (e) {
      return AuthResult.failure(AppConstants.serverError);
    }
  }
  
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
  
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
  
  Future<AuthResult<void>> verifyEmailOTP(String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (otp.length == 6) {
      return AuthResult.success(null);
    }
    return AuthResult.failure('Invalid OTP');
  }
  
  Future<AuthResult<void>> verifyPhoneOTP(String otp) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (otp.length == 6) {
      return AuthResult.success(null);
    }
    return AuthResult.failure('Invalid OTP');
  }
  
  Future<AuthResult<void>> updateProfile(Map<String, dynamic> data) async {
    try {
      final userId = currentUserId;
      if (userId == null) {
        return AuthResult.failure('Not authenticated');
      }
      
      await _userRepository.updateUser(userId, data);
      return AuthResult.success(null);
    } catch (e) {
      return AuthResult.failure(AppConstants.serverError);
    }
  }
}

class AuthResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  const AuthResult._({this.data, this.error, required this.isSuccess});
  
  factory AuthResult.success(T data) => AuthResult._(data: data, isSuccess: true);
  factory AuthResult.failure(String error) => AuthResult._(error: error, isSuccess: false);
}