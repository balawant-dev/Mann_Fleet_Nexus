import 'package:flutter/material.dart';



import '../../../widget/motionToastHelper.dart';
import '../../../widget/navigator_method.dart';
import '../model/GetComplaintsDetailModel.dart';
import '../model/createComplaintsModel.dart';
import '../model/getComplaintsModel.dart';

import '../repo/complaintRepo.dart';
import '../ui/complaintHistoryScreen.dart';

class ComplaintsProvider extends ChangeNotifier {
  final api = ComplaintsRepo();

  CreateComplaintsModel? createComplaintsModel;
  GetComplaintsModel? getComplaintsModel;
  GetComplaintsDetailModel? getComplaintsDetailModel;


  bool isLoading = false;

  Future<void> getComplaintsApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getComplaintsApi(context: context);
      getComplaintsModel = res;
      if (res != null || res.status == true) {
        print("Get privacyPolicyModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  Future<void> getComplaintsDetailApi({required BuildContext context,required String id}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getComplaintsDetailApi(context: context,id: id);
      getComplaintsDetailModel = res;
      if (res != null || res.status == true) {
        print("Get getComplaintsDetailApi Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> createComplaint({
    required BuildContext context,
    required String issueCategory,
    required String description,
    required List<String> imageFiles,
    required String videoFiles,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.createComplaintsApi(
        context: context,
        issueCategory: issueCategory,
        description: description,
        imageFiles: imageFiles,
        videoFiles: videoFiles,
      );
      Navigator.pop(context);

      createComplaintsModel = res;


      if (res.status == true) {
        ToastHelper.show(
          context,
          message: "Create new complaint successfully",
          type: ToastType.success,
        );
        navPush(context: context, action: ComplaintHistoryScreen());
        print("Complaint Created Successfully");
      }
    } catch (e) {
      ToastHelper.show(
        context,
        message: "Error: $e",
        type: ToastType.error,
      );
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
