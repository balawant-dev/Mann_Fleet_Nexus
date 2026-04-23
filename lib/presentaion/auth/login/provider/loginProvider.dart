import 'package:flutter/material.dart';
import '../../../../widget/navigator_method.dart';
import '../../otp/ui/otp_screen.dart';
import '../model/signinModel.dart';
import '../repo/signinRepo.dart';

class LoginProvider with ChangeNotifier {

  TextEditingController mobileNumberController = TextEditingController();

  String? errorText;
  String countryCode = "+91";

  void changeCountryCode(String code) {
    countryCode = code;
    notifyListeners();
  }
  void getOTP(BuildContext context) {

    if (mobileNumberController.text.length < 10) {
      errorText = "Enter valid number";
      notifyListeners();
      return;
    }

    errorText = null;
    notifyListeners();

    navPush(
      context: context,
      action: OtpScreen(
        mobileNumber: mobileNumberController.text,
      ),
    );
  }

  final api = SignInRepo();

  SignInModel? signInModel;


  bool isLoading = false;

  Future<void> sendOtp({required BuildContext context,required String phone,required String countryCode}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.sendOtp(phone: phone, context: context,countryCode: countryCode);
      signInModel = res;
      if(res!=null||res.status==true){
        print("sendOtp Successfully");
      }

    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

  }
  void onPhoneChanged(String value) {
    notifyListeners();
  }
}