



import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';   // ← Reverse Geocoding ke liye

import '../../../apiservice/services/firebaseService.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import '../../../widget/navigator_method.dart';
import '../../bottomBar/bottomBar.dart';
import '../../onBording/ui/onBordingScreen.dart';
import '../provider/homeProvider.dart';

class DeepLinkService {
  static final AppLinks _appLinks = AppLinks();
  static bool _isInitialized = false;

  static Future<void> init(HomeProvider provider, BuildContext context) async {
    if (_isInitialized) return;
    _isInitialized = true;

    // Handle initial link (app cold start)
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri, provider, context);
      }
    } catch (e) {
      debugPrint("DeepLink initial link error: $e");
    }

    // Listen to new links (app already running)
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleLink(uri, provider, context);
      }
    });
  }

  static void _handleLink(
      Uri uri, HomeProvider provider, BuildContext context) async {

    print("🔗 Deep Link Received: ${uri.toString()}");

    double? lat;
    double? lng;
    String address = "";

    // Case 1: Google Maps Link
    if (uri.host.contains("google.com") || uri.host.contains("maps.google")) {
      final query = uri.queryParameters['q'] ?? uri.queryParameters['ll'] ?? '';

      if (query.contains(',')) {
        final parts = query.split(',');
        if (parts.length >= 2) {
          lat = double.tryParse(parts[0]);
          lng = double.tryParse(parts[1]);
        }
      }

      address = uri.queryParameters['q']?.split('+').last ?? "Selected Location";
    }
    // Case 2: Direct geo: scheme (jaise WhatsApp, Google Maps share)
    else if (uri.scheme == "geo") {
      final coords = uri.path.split(',');
      if (coords.length >= 2) {
        lat = double.tryParse(coords[0]);
        lng = double.tryParse(coords[1]);
      }
      address = "Shared Location";
    }

    if (lat != null && lng != null) {
      print("✅ Location Received → Lat: $lat, Lng: $lng");

      // 🔥 Reverse Geocoding - Real Address Fetch
      String finalAddress = await _getAddressFromLatLng(lat, lng);

      provider.setDropLocationFromDeepLink(
        address: finalAddress,
        lat: lat,
        lng: lng,
      );

      await Future.delayed(const Duration(milliseconds: 400));
      await _navigateAfterDeepLink(context);
    }
  }

  // Reverse Geocoding Helper
  static Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String address = [
          place.name,
          place.subLocality,
          place.locality,
          place.administrativeArea,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        return address.isNotEmpty ? address : "Selected Location";
      }
    } catch (e) {
      print("Reverse Geocoding Error: $e");
    }
    return "Selected Location";
  }

  // Navigation
  static Future<void> _navigateAfterDeepLink(BuildContext context) async {
    await FirebaseService.init();
    final token = await SecureStorageService.getToken();
    final isProfileComplete = await SecureStorageService.getIsProfileComplete();

    print("DeepLink → Token: $token | ProfileComplete: $isProfileComplete");

    if (!context.mounted) return;

    await Future.delayed(const Duration(milliseconds: 500));

    if (token != null && isProfileComplete == true) {
      navPushReplace(context: context, action: MainScreen(currentIndex: 0));
    } else {
      navPushReplace(context: context, action: OnBordingScreen());
    }
  }
}