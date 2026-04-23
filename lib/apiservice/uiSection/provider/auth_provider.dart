// Step 13: Providers (Example)
// core/providers/auth_provider.dart
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../repo/auth_repository.dart';
import '../routes/dummyRoutes.dart';

class AuthProvider with ChangeNotifier {
  UserModel? user;
  bool isLoading = false;
  String? errorMessage;

  final AuthRepository _repo = AuthRepository();

  Future<void> login(String email, String password, BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      user = await _repo.login(email, password, context);
      // Navigate to home
      Navigator.pushNamed(context, DummyAppRoutes.home);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// Similarly for other providers, e.g., ProfileProvider
class ProfileProvider with ChangeNotifier {
  ProfileModel? profile;
  bool isLoading = false;
  String? errorMessage;

  final ProfileRepository _repo = ProfileRepository();

  Future<void> fetchProfile(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await _repo.getProfile(context);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

// Add providers for dashboard, settings, upload similarly.