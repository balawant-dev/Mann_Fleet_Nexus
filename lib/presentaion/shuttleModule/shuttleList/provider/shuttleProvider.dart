import 'package:flutter/material.dart';

import '../model/generateQrModel.dart';
import '../model/getShuttlePassesModel.dart';

import '../model/purchaseShuttlePassModel.dart';
import '../repo/shuttleRepo.dart';

class ShuttleProvider extends ChangeNotifier {
  final api = ShuttleRepo();

  bool isLoading = false;
  GetShuttlePassesModel? getShuttlePassesModel;
  PurchaseShuttlePassModel? purchaseShuttlePassModel;
  GenerateQrModel? generateQrModel;

  Future<void> getShuttleShiftStopApi({
    required BuildContext context,
    required String destination,
    required String source,
  required String shuttleShiftId,required String bookingDate
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getShuttlePassesApi(
        context: context,
        destination: destination,
        source: source,
        bookingDate: bookingDate,
        shuttleShiftId: shuttleShiftId
      );

      if (res != null && res.status == true) {
        getShuttlePassesModel = res; // ✅ correct assignment
      } else {
        debugPrint("API Error: ${res.message}");
      }

    } catch (e) {
      debugPrint("getShuttlePassesModel Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> purchaseShuttlePassApi({
    required BuildContext context,
    required String destination,
    required String source,
    required String passId
  ,required String bookingDate,required String shiftId
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.purchaseShuttlePassApi(
        context: context,
        destination: destination,
        source: source,
        passId: passId,
        shiftId: shiftId,
        bookingDate: bookingDate
      );

      if (res != null && res.status == true) {
        purchaseShuttlePassModel = res; // ✅ correct assignment
      } else {
        debugPrint("purchaseShuttlePassModel API Error: ${res.message}");
      }

    } catch (e) {
      debugPrint("purchaseShuttlePassModel Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }  Future<void> generateQrApi({
    required BuildContext context,
    required String transactionId,
    required String source,required String destination

  }) async {
    try {
      isLoading = true;
      generateQrModel=null;
      notifyListeners();

      final res = await api.generateQrApi(
        context: context,
        transactionId: transactionId,
        destination: destination,
        source: source

      );

      if (res != null && res.status == true) {
        generateQrModel = res; // ✅ correct assignment
      } else {
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