import 'package:flutter/material.dart';

import '../../../apiservice/services/secure_storage_service.dart';
import '../model/getProfileModel.dart';

import '../repo/profileRepo.dart';

class ProfileDetailViewModel extends ChangeNotifier {
  final api = ProfileRepo();

  GetProfileModel? getProfileModel;

  bool isLoading = false;

  Future<void> getProfileApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getProfileApi(context: context);
      getProfileModel = res;
      if (res != null || res.status == true) {
        await SecureStorageService.saveIsProfileComplete(res.data!.user!.isProfileComplete!);

        // print("Printing isProfileComplete >>>>>>>>>>> ${res.data!.user!.isProfileComplete!}");
        print("Get Profile Successfully");
      }
    } catch (e) {
      debugPrint("Error in Get Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editProfileApi({
    required String name,
    required String email,
    required String city,
    required String gender, //male,female,other,
    required String dob, //"1998-08-20",
    required String profilePic,
    required BuildContext context,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.editProfileApi(
        context: context,
        dob: dob,
        gender: gender,
        name: name,
        profilePic: profilePic,
        email: email,
        city: city,
      );

      if (res.status == true) {
        debugPrint("Profile Updated Successfully");

        /// After update refresh profile
        await getProfileApi(context: context);
      }
    } catch (e) {
      debugPrint("Error in Edit Profile: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
