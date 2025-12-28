import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'auth_token';
  final SharedPreferences sharedPreferences;

  TokenManager(this.sharedPreferences);

  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  String? getToken() {
    return sharedPreferences.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    await sharedPreferences.remove(_tokenKey);
  }

  bool hasToken() {
    return sharedPreferences.containsKey(_tokenKey);
  }
}
