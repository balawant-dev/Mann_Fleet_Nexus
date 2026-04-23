

import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseService {

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// initialize all services
  static Future<void> init() async {

    await _requestPermission();

    await _initializeAwesome();

    await _printDeviceId();

    await _getFcmToken();

    _listenForegroundNotification();
  }

  /// Notification Permission
  static Future<void> _requestPermission() async {
    await _messaging.requestPermission();
  }

  /// Awesome Notification initialize
  static Future<void> _initializeAwesome() async {

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ],
    );
  }

  /// Device ID
  static Future<void> _printDeviceId() async {

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final prefs = await SharedPreferences.getInstance();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      String deviceId = androidInfo.id ?? '';
      await prefs.setString("deviceId", deviceId);

      print("DEVICE ID : $deviceId");
    }

    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      String deviceId = iosInfo.identifierForVendor ?? '';

      await prefs.setString("deviceId", deviceId);

      print("DEVICE ID : ${iosInfo.identifierForVendor}");
    }
  }

  /// FCM Token
  static Future<void> _getFcmToken() async {
    String? token = await _messaging.getToken();

    if (token != null) {

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("deviceToken", token);

      print("FCM TOKEN : $token");
    }
  }

  /// Foreground notification
  static void _listenForegroundNotification() {

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      print("Notification Title : ${message.notification?.title}");
      print("Notification Body : ${message.notification?.body}");

      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: message.notification?.title ?? '',
          body: message.notification?.body ?? '',
        ),
      );
    });
  }
}