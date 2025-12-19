import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../providers/role_provider.dart';
import '../models/user_model.dart';

/// Auth State
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? name;

  const AuthState({
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.name,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? name,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}

/// Auth Notifier - Handles Firebase authentication and user management
class AuthNotifier extends StateNotifier<AuthState> {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref _ref;
  static const String _usersKey = 'app_users'; // Store user roles by email

  AuthNotifier(this._ref) : super(const AuthState()) {
    // Delay initialization to ensure Firebase is ready
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Wait for Firebase to be initialized with retry logic
    int retries = 0;
    const maxRetries = 10;

    while (Firebase.apps.isEmpty && retries < maxRetries) {
      await Future.delayed(const Duration(milliseconds: 200));
      retries++;
      debugPrint(
        'Waiting for Firebase initialization... ($retries/$maxRetries)',
      );
    }

    if (Firebase.apps.isEmpty) {
      debugPrint('Firebase not initialized after $maxRetries retries');
      state = const AuthState();
      return;
    }

    try {
      _loadAuthState();
      _auth.authStateChanges().listen((User? user) {
        if (user != null) {
          _updateAuthState(user);
        } else {
          state = const AuthState();
        }
      });
    } catch (e) {
      debugPrint('Firebase Auth initialization error: $e');
      // If Firebase isn't ready, just set unauthenticated state
      state = const AuthState();
    }
  }

  Future<void> _loadAuthState() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _updateAuthState(user);
      } else {
        // Check if we have stored auth data
        final email = await _storage.read(key: 'user_email');
        final userId = await _storage.read(key: 'user_id');
        final name = await _storage.read(key: 'user_name');

        if (email != null && userId != null) {
          state = AuthState(
            isAuthenticated:
                false, // Not authenticated if Firebase user is null
            userId: userId,
            email: email,
            name: name,
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading auth state: $e');
      // If Firebase isn't ready, just set unauthenticated state
      state = const AuthState();
    }
  }

  Future<void> _updateAuthState(User user) async {
    // Get user roles from local storage
    final userModel = await _getUserByEmail(user.email!);

    state = AuthState(
      isAuthenticated: true,
      userId: user.uid,
      email: user.email,
      name: user.displayName ?? userModel?.name ?? 'User',
    );

    // Save to secure storage
    await _storage.write(key: 'auth_token', value: await user.getIdToken());
    await _storage.write(key: 'user_email', value: user.email!);
    await _storage.write(key: 'user_id', value: user.uid);
    await _storage.write(
      key: 'user_name',
      value: user.displayName ?? userModel?.name ?? 'User',
    );
  }

  /// Get user by email (for checking roles)
  Future<UserModel?> _getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    if (usersJson == null) return null;

    final usersMap = jsonDecode(usersJson) as Map<String, dynamic>;
    final userJson = usersMap[email.toLowerCase()];

    if (userJson == null) return null;

    return UserModel.fromJson(userJson as Map<String, dynamic>);
  }

  /// Save user roles to storage
  Future<void> _saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_usersKey);

    Map<String, dynamic> usersMap = {};
    if (usersJson != null) {
      usersMap = jsonDecode(usersJson) as Map<String, dynamic>;
    }

    usersMap[user.email.toLowerCase()] = user.toJson();
    await prefs.setString(_usersKey, jsonEncode(usersMap));
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized. Please restart the app.');
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        await _updateAuthState(user);

        // Load registered roles
        final userModel = await _getUserByEmail(email);
        if (userModel != null) {
          // Register roles in RoleProvider
          for (final role in userModel.registeredRoles) {
            await _ref.read(roleProvider.notifier).registerRole(role);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign up with email and password
  Future<void> signUp(
    String email,
    String password,
    String name,
    UserRole role,
  ) async {
    // Ensure Firebase is initialized
    if (Firebase.apps.isEmpty) {
      throw Exception('Firebase is not initialized. Please restart the app.');
    }

    try {
      // Create Firebase user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Update display name
        await user.updateDisplayName(name);
        await user.reload();
        final updatedUser = _auth.currentUser!;

        // Check if user already exists in local storage
        final existingUser = await _getUserByEmail(email);

        UserModel userModel;
        if (existingUser != null) {
          // User exists - add new role if not already registered
          if (existingUser.hasRole(role)) {
            throw Exception('This role is already registered for this email.');
          }
          userModel = existingUser.addRole(role);
        } else {
          // New user - create account with first role
          userModel = UserModel(
            id: user.uid,
            email: email,
            name: name,
            registeredRoles: [role],
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
        }

        // Save user roles
        await _saveUser(userModel);

        // Register role in RoleProvider
        await _ref.read(roleProvider.notifier).registerRole(role);

        // Update auth state
        await _updateAuthState(updatedUser);
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        // Check if user exists in local storage
        final existingUser = await _getUserByEmail(user.email!);

        if (existingUser == null) {
          // New user - create user model with default role (Patient)
          final userModel = UserModel(
            id: user.uid,
            email: user.email!,
            name: user.displayName ?? 'User',
            registeredRoles: [
              UserRole.patient,
            ], // Default role for Google sign-in
            createdAt: DateTime.now(),
            lastLoginAt: DateTime.now(),
          );
          await _saveUser(userModel);
          await _ref.read(roleProvider.notifier).registerRole(UserRole.patient);
        } else {
          // Existing user - register all roles
          for (final role in existingUser.registeredRoles) {
            await _ref.read(roleProvider.notifier).registerRole(role);
          }
        }

        await _updateAuthState(user);
      }
    } catch (e) {
      throw Exception('Google sign-in failed: ${e.toString()}');
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _storage.deleteAll();
      await _ref.read(roleProvider.notifier).clearActiveRole();
      state = const AuthState();
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }

  /// Get current user's registered roles
  Future<List<UserRole>> getRegisteredRoles() async {
    final user = _auth.currentUser;
    if (user?.email == null) return [];

    final userModel = await _getUserByEmail(user!.email!);
    return userModel?.registeredRoles ?? [];
  }

  /// Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return e.message ?? 'An error occurred during authentication.';
    }
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
