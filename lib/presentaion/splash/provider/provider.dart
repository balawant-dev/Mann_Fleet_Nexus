import 'package:flutter/material.dart';

import '../model/checkMandatoryUpdate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../repo/repository.dart';

class PlatformDependenciesPro extends ChangeNotifier {
  final PlatformDependenciesRepo api = PlatformDependenciesRepo();

  PlatformDependenciesModel? platformDependenciesModel;
  bool isLoading = false;
  String? errorMessage;



  Future<void> getPlatformDependenciesApi({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();

    try {
      /// ✅ Get app version dynamically
      final info = await PackageInfo.fromPlatform();
     final currentVersion = info.version; // e.g. 1.0.2
      // final currentVersion = info.buildNumber; // 1



      final res = await api.getPlatformDependenciesApi(context: context);

      platformDependenciesModel = res;

      errorMessage = null;

    } catch (e) {
      errorMessage = e.toString();
      platformDependenciesModel = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}