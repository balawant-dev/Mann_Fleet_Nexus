import 'package:flutter/material.dart';


import '../model/shuttleHistoryModel.dart';
import '../repo/shuttleHistoryRepo.dart';

class ShuttleHistoryViewModel extends ChangeNotifier {
  final api = ShuttleHistoryRepo();

  ShuttleHistoryModel? shuttleHistoryModel;

  bool isLoading = false;

  Future<void> getShuttleHistoryApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getShuttleHistoryApi(context: context);
      shuttleHistoryModel = res;
      if (res != null || res.status == true) {
        // await SecureStorageService.saveIsProfileComplete(res.data!.user!.isProfileComplete!);

        // print("Printing isProfileComplete >>>>>>>>>>> ${res.data!.user!.isProfileComplete!}");
        print("Get getShuttleHistoryApi Successfully");
      }
    } catch (e) {
      debugPrint("Error in Wallet getShuttleHistoryApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
