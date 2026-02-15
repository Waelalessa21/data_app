import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum AuthErrorType {
  emailInUse,
  invalidEmail,
  weakPassword,
  userDisabled,
  wrongPassword,
  userNotFound,
  unknown,
}

class AuthException implements Exception {
  final AuthErrorType type;
  final String message;

  AuthException(this.type, this.message);

  @override
  String toString() => message;
}

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> ensurePersistence() async {
    if (kIsWeb) {
      await _auth.setPersistence(Persistence.SESSION);
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user?.updateDisplayName(displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseException(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  AuthException _mapFirebaseException(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return AuthException(AuthErrorType.emailInUse, 'Email already in use');
      case 'invalid-email':
        return AuthException(
          AuthErrorType.invalidEmail,
          'Invalid email address',
        );
      case 'weak-password':
        return AuthException(
          AuthErrorType.weakPassword,
          'Password must be at least 6 characters',
        );
      case 'user-disabled':
        return AuthException(AuthErrorType.userDisabled, 'Account disabled');
      case 'wrong-password':
        return AuthException(
          AuthErrorType.wrongPassword,
          'Invalid email or password',
        );
      case 'user-not-found':
        return AuthException(
          AuthErrorType.userNotFound,
          'Invalid email or password',
        );
      default:
        return AuthException(
          AuthErrorType.unknown,
          e.message ?? 'Authentication failed',
        );
    }
  }
}
