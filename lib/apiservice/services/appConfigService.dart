import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppConfigService {
  static const _storage = FlutterSecureStorage();

  static const String razorKey = "RAZOR_KEY";
  static const String googleKey = "GOOGLE_MAP_KEY";



  /// SAVE KEYS
  static Future<void> saveKeys({
    required String razor,
    required String google,
  }) async {
    await _storage.write(key: razorKey, value: razor);
    await _storage.write(key: googleKey, value: google);
  }

  /// GET KEYS
  static Future<String> getRazorKey() async {
    return await _storage.read(key: razorKey) ?? "";
  }

  static Future<String> getGoogleKey() async {
    return await _storage.read(key: googleKey) ?? "";
  }

  /// CLEAR
  static Future<void> clear() async {
    await _storage.delete(key: razorKey);
    await _storage.delete(key: googleKey);
  }
}