import 'package:flutter/material.dart';




import '../model/notificationDetailModel.dart';
import '../model/notificationModel.dart';
import '../repo/notificationRepo.dart';

class NotificationProvider extends ChangeNotifier {
  final api = NotificationRepo();
  NotificationDetailModel? notificationDetailModel;
  GetNotificationModel? getNotificationModel;


  bool isLoading = false;

  Future<void> getNotificationApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNotificationApi(context: context);
      getNotificationModel = res;
      if (res != null || res.status == true) {
        print("Get getNotificationModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> getNotificationDetailApi({required BuildContext context,required String id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getNotificationDetailApi(context: context, id: id);

      if (res != null && res.status == true) {
        notificationDetailModel = res;
      } else {
        notificationDetailModel = null;
      }

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
