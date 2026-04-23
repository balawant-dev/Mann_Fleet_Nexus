import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/home/ui/home_screen.dart';
import '../../../../apiservice/services/secure_storage_service.dart';
import '../../../../widget/navigator_method.dart';
import '../../../bottomBar/bottomBar.dart';
import '../model/resendOtpModel.dart';
import '../model/verifyOtpModel.dart';
import '../repo/verifyOtpRepo.dart';

class OtpProvider with ChangeNotifier {

  int seconds = 45;
  Timer? timer;

  void startTimer() {
    seconds = 45;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        seconds--;
        notifyListeners();
      }
    });
  }

  void resendOtp() {
    if (seconds == 0) {
      startTimer();
    }
  }

  void OtoVerify(BuildContext context) {
    navPushReplace(
      context: context,
      action: const MainScreen(currentIndex: 0,),
    );
  }


  final api = VerifyOtpRepo();

  VerifyOtpModel? verifyOtpModel;
  ResendOtpModel? resendOtpModel;


  bool isLoading = false;

  Future<void> verifyOtp({    required String phone,
    required String otp,
    required String fcmToken ,
    required String deviceId ,
    required String deviceType ,
    required BuildContext context,}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.verifyOtp(phone: phone, context: context,otp: otp,fcmToken: fcmToken,deviceType: deviceType,deviceId: deviceId );
      verifyOtpModel = res;
      if(res!=null||res.status==true){
        print("verifyOtpModel Successfully");
        await SecureStorageService.saveToken(res.token!);
        print("Printing Token >>>>>>>>>>> ${res.token!}");
      }

    } catch (e) {
      debugPrint("Error in verifyOtpModel: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
  Future<void> resendOtpApi({
    required BuildContext context,
    required String phone,
  }) async {
    try {

      final res = await api.resendOtpApi(
        phone: phone,
        context: context,
      );

      resendOtpModel = res;

      if (res != null && res.status == true) {
        debugPrint("resendOtpModel Successfully");
      }

    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    }
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}