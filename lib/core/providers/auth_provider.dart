import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../providers/role_provider.dart';

/// Auth State
class AuthState {
  final bool isAuthenticated;
  final String? userId;
  final String? email;

  const AuthState({this.isAuthenticated = false, this.userId, this.email});

  AuthState copyWith({bool? isAuthenticated, String? userId, String? email}) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }
}

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final token = await _storage.read(key: 'auth_token');
    final email = await _storage.read(key: 'user_email');
    final userId = await _storage.read(key: 'user_id');

    if (token != null && email != null && userId != null) {
      state = AuthState(isAuthenticated: true, userId: userId, email: email);
    }
  }

  Future<void> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    await _storage.write(key: 'auth_token', value: 'token_$userId');
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_id', value: userId);

    state = AuthState(isAuthenticated: true, userId: userId, email: email);
  }

  Future<void> signUp(String email, String password, String name) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';

    await _storage.write(key: 'auth_token', value: 'token_$userId');
    await _storage.write(key: 'user_email', value: email);
    await _storage.write(key: 'user_id', value: userId);

    state = AuthState(isAuthenticated: true, userId: userId, email: email);
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    _ref.read(roleProvider.notifier).clearRole();
    state = const AuthState();
  }
}

/// Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
