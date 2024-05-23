import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> saveUser(String key, String value) async {
    await _storage.write(key: key, value: value);
  }
}
