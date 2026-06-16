import 'package:flutter/material.dart';


import '../../../../widget/motionToastHelper.dart';
import '../../shuttleList/model/generateQrModel.dart';
import '../../shuttleList/repo/shuttleRepo.dart';
import '../model/myShuttleModel.dart';
import '../repo/myShuttleRepo.dart';

class MyShuttleViewModel extends ChangeNotifier {
  final api = MyShuttleRepo();

  MyShuttleModel? myShuttleModel;

  bool isLoading = false;

  Future<void> getShuttleHistoryApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getMyShuttleApi(context: context);
      myShuttleModel = res;
      if (res != null || res.status == true) {
        // await SecureStorageService.saveIsProfileComplete(res.data!.user!.isProfileComplete!);

        // print("Printing isProfileComplete >>>>>>>>>>> ${res.data!.user!.isProfileComplete!}");
        print("Get getMyShuttleApi Successfully");
      }
    } catch (e) {
      debugPrint("Error in Wallet getMyShuttleApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  final api2 = ShuttleRepo();
  GenerateQrModel? generateQrModel;
  Future<void> generateQrApi({
    required BuildContext context,
    required String transactionId,
    required String source,required String destination

  }) async {
    try {
      isLoading = true;
      generateQrModel=null;
      notifyListeners();

      final res = await api2.generateQrApi(
          context: context,
          transactionId: transactionId,
          destination: destination,
          source: source

      );

      if (res != null && res.status == true) {
        generateQrModel = res; // ✅ correct assignment
      } else {
        ToastHelper.show(context, message: res.message??"Something went wrong",type:ToastType.error );
        // df
        debugPrint("generateQrModel API Error: ${res.message}");
      }

    } catch (e) {
      debugPrint("generateQrModel Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
