import 'package:flutter/material.dart';


import '../model/walletTransactionModel.dart';
import '../repo/walletRepo.dart';

class WalletViewModel extends ChangeNotifier {
  final api = WalletRepo();

  WalletTransactionModel? walletTransactionModel;

  bool isLoading = false;

  Future<void> getWalletTransactionApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getWalletTransactionApi(context: context);
      walletTransactionModel = res;
      if (res != null || res.status == true) {
        // await SecureStorageService.saveIsProfileComplete(res.data!.user!.isProfileComplete!);

        // print("Printing isProfileComplete >>>>>>>>>>> ${res.data!.user!.isProfileComplete!}");
        print("Get Wallet Successfully");
      }
    } catch (e) {
      debugPrint("Error in Wallet getWalletTransactionApi: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}
