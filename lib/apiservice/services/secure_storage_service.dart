import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';
import 'package:flutter/material.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  /// TOKEN
  static Future<void> saveToken(String token) async {
    await _storage.write(key: ApiConstants.tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: ApiConstants.tokenKey);
  }

  /// IS AGENT
  static Future<void> saveIsProfileComplete(bool value) async {
    await _storage.write(
      key: ApiConstants.isProfileComplete,
      value: value.toString(), // true / false
    );
  }

  static Future<bool> getIsProfileComplete() async {
    final value = await _storage.read(key: ApiConstants.isProfileComplete);
    return value == 'true';
  }

  /// IS USER
  static Future<void> saveIsUser(bool value) async {
    await _storage.write(key: ApiConstants.isUserKey, value: value.toString());
  }

  static Future<bool> getIsUser() async {
    final value = await _storage.read(key: ApiConstants.isUserKey);
    return value == 'true';
  }

  /// IS AGENT - REMOVE
  static Future<void> removeIsProfileComplete() async {
    await _storage.delete(key: ApiConstants.isProfileComplete);
  }

  static Future<void> removeToken() async {
    await _storage.delete(key: ApiConstants.tokenKey);
  }

  /// IS USER - REMOVE
  static Future<void> removeIsUser() async {
    await _storage.delete(key: ApiConstants.isUserKey);
  }

  /// LOGOUT
  static Future<void> logout(BuildContext context) async {
    await _storage.deleteAll();

    // await AppSettings.clearUserType();
    //
    // context.go(Routes.login);
    // await AppSettings.initUserType();
  }
}
