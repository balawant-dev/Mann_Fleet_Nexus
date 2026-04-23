import 'package:flutter/material.dart';



import '../model/privacyPolicyModel.dart';
import '../model/refundPrivacyPolicyModel.dart';
import '../model/termConditionsModel.dart';
import '../repo/cmsRepo.dart';

class CMSProvider extends ChangeNotifier {
  final api = CMSRepo();

  PrivacyPolicyModel? privacyPolicyModel;
  RefundPrivacyPolicyModel? refundPrivacyPolicyModel;
  TermConditionsModel? termConditionsModel;

  bool isLoading = false;

  Future<void> getPrivacyPolicyApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getPrivacyPolicyApi(context: context);
      privacyPolicyModel = res;
      if (res != null || res.status == true) {
        print("Get privacyPolicyModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> getTermsConditionsApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getTermsConditionsApi(context: context);
      termConditionsModel = res;
      if (res != null || res.status == true) {
        print("Get privacyPolicyModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  Future<void> getRefundPolicyApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getRefundPolicyApi(context: context);
      refundPrivacyPolicyModel = res;
      if (res != null || res.status == true) {
        print("Get privacyPolicyModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


}
