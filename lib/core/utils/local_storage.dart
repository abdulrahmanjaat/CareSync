import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _rememberMeKey = 'remember_me';
  static const String _rememberedEmailKey = 'remembered_email';
  static const String _rememberedPasswordKey = 'remembered_password';

  /// Save remember me state and credentials
  static Future<void> saveRememberedCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, true);
    await prefs.setString(_rememberedEmailKey, email);
    await prefs.setString(_rememberedPasswordKey, password);
  }

  /// Clear remembered credentials
  static Future<void> clearRememberedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, false);
    await prefs.remove(_rememberedEmailKey);
    await prefs.remove(_rememberedPasswordKey);
  }

  /// Get remember me state
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  /// Get remembered email
  static Future<String?> getRememberedEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedEmailKey);
  }

  /// Get remembered password
  static Future<String?> getRememberedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rememberedPasswordKey);
  }
}
