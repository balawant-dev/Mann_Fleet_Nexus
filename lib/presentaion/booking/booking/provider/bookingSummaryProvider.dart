import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../../../widget/motionToastHelper.dart';

import '../model/appliedCouponsModel.dart';
import '../model/createBookingSummeryModel.dart';
import '../model/fareSummaryModel.dart';
import '../model/getCouponsModel.dart';
import '../repo/bookingSummaryRepo.dart';
// import '../repo/bookingHistoryRepo.dart';

class BookingSummaryProvider extends ChangeNotifier {
  final api = BookingSummaryRepo();

  CreateBookingSummeryModel? createBookingSummeryModel;
  GetCouponsModel? getCouponsModel;
  AppliedCouponsModel? appliedCouponsModel;

  bool isLoading = false;
  bool isLoading2 = false;
  bool isVerified = false;
  bool isOtpSent = false;
  bool isOtpVerified = false;
  bool isGetCouponApi = false;
  bool isApplyCouponApi = false;

  // ✅ New Coupon Variables
  String? appliedCouponCode;
  String? discountAmountStr;
  String? finalAmountAfterCouponStr;
  double? discountAmount;
  double? finalAmountAfterCoupon;

  String coupon = "";
  String couponMessage = "";
  bool isCouponGreenMessage = false;

  Future<void> fetchAvailableCoupons({
    required String amount,
    required BuildContext context,
    required String dropLat,
    required String dropLng,
    required String pickupLat,
    required String pickupLng,
  }) async {
    try {
      isGetCouponApi = true;
      notifyListeners();

      final res = await api.getCouponApi(
        pickupLng: pickupLng,
        pickupLat: pickupLat,
        dropLng: dropLng,
        dropLat: dropLat,
        context: context,
        amount: amount, // yahan finalPayableAmount bhej rahe ho
      );

      if (res.status == true) {
        getCouponsModel = res;
      }
    } catch (e) {
      debugPrint("fetchAvailableCoupons error: $e");
    } finally {
      isGetCouponApi = false;
      notifyListeners();
    }
  }

  Future<void> applyCouponApi({
    required BuildContext context,
    required String amount,
    required String couponCode,    required String dropLat,
    required String dropLng,
    required String pickupLat,
    required String pickupLng,


    required bool isBack,
  }) async {
    try {
      isApplyCouponApi = true;
      notifyListeners();

      final res = await api.applyCouponApi(
        context: context,
        amount: amount,
        couponCode: couponCode,        pickupLng: pickupLng,
        pickupLat: pickupLat,
        dropLng: dropLng,
        dropLat: dropLat,

      );

      if (res.status == true && res.data != null) {
        appliedCouponsModel = res;

        appliedCouponCode = res.data!.couponCode;
        print("Bala<<<<<<<<<<<<<<${appliedCouponCode}<<<<<<${res.data!.couponCode}>>>>>>>>>>>>>>>>>>>>");
        notifyListeners();
        discountAmount = res.data!.discountAmount?.toDouble();
        finalAmountAfterCoupon = res.data!.finalAmount?.toDouble();

        discountAmountStr = discountAmount?.toStringAsFixed(2) ?? "0";
        finalAmountAfterCouponStr =
            finalAmountAfterCoupon?.toStringAsFixed(2) ?? amount;

        coupon = couponCode;
        couponMessage = res.message;
        isCouponGreenMessage = true;

        if (isBack == true) {
          Navigator.pop(context);
        }

        ToastHelper.show(
          context,
          message: res.message ?? "Coupon applied successfully!",
          type: ToastType.success,
        );
        notifyListeners();
      } else {
        print("Error go this section ??????????????? ${res.message}");
        isCouponGreenMessage = false;
        couponMessage = res.message;

        ToastHelper.show(
          context,
          message: res.message ?? "Failed to apply coupon",
          type: ToastType.error,
        );
        couponMessage = res.message;
        if (isBack == true) {
          Navigator.pop(context);
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("applyCouponApi error: $e");
      ToastHelper.show(
        context,
        message: "Something went wrong",
        type: ToastType.error,
      );
    } finally {
      isApplyCouponApi = false;
      notifyListeners();
    }
  }

  void removeCoupon() {
    appliedCouponCode = null;
    discountAmount = null;
    finalAmountAfterCoupon = null;
    discountAmountStr = null;
    finalAmountAfterCouponStr = null;
    coupon = "";
    notifyListeners();
  }

  FareSummaryModel? fareSummaryModel;

  // Future<void> fareSummaryTabApi({
  //   required BuildContext context,
  //   required String bookingType,
  //   required String pickupAddress,
  //   String? dropoffAddress,
  //   required String pickupLat,
  //   required String pickupLng,
  //   String? dropLat,
  //   String? dropLng,
  //   String? couponCode,
  //   required String date,
  //   required String time,
  //   String? returnDate,
  //   String? returnTime,
  //   String? selectedHours,
  //   String? tripDays,
  //   required String segmentId,
  // }) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //
  //
  //     final res = await api.fareSummaryTabApi(
  //       context: context,
  //       bookingType: bookingType,
  //       pickupAddress: pickupAddress,
  //       dropoffAddress: dropoffAddress,
  //       pickupLat: pickupLat,
  //       pickupLng: pickupLng,
  //       dropLat: dropLat,
  //       dropLng: dropLng,
  //       date: date,
  //       time: time,
  //       segmentId: segmentId,
  //       couponCode: couponCode,
  //       returnDate: returnDate,
  //       returnTime: returnTime,
  //       selectedHours: selectedHours,
  //       tripDays: tripDays,
  //     );
  //
  //     fareSummaryModel = res; // same model
  //     print(">>>>>>>>>>>>>>>>>>>fareSummaryModel${fareSummaryModel?.data?.tollAmount}");
  //   } catch (e) {
  //     debugPrint("fareSummaryTabApi Error: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  Future<void> fareSummaryTabApi({
    required BuildContext context,
    required String bookingType,
    required String travellerPhone,
    required String pickupAddress,
    String? dropoffAddress,
    required String pickupLat,
    required String pickupLng,
    String? dropLat,
    String? dropLng,
    String? couponCode,
    required String date,
    required String time,
    String? returnDate,
    String? returnTime,
    String? selectedHours,
    String? tripDays,
    required String segmentId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.fareSummaryTabApi(
        context: context,
        bookingType: bookingType,
        travellerPhone: travellerPhone,
        pickupAddress: pickupAddress,
        dropoffAddress: dropoffAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,
        date: date,
        time: time,
        segmentId: segmentId,
        couponCode: couponCode,
        returnDate: returnDate,
        returnTime: returnTime,
        selectedHours: selectedHours,
        tripDays: tripDays,
      );

      fareSummaryModel = res;

      // Print everything
      print(">>>>>>>>>>>>>>>>>>>fareSummaryModel: $fareSummaryModel");

      // Or pretty JSON (uncomment if model has toJson)
      // print(const JsonEncoder.withIndent('  ').convert(fareSummaryModel?.toJson()));

    } catch (e) {
      debugPrint("fareSummaryTabApi Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fareSummaryApi({
    required BuildContext context,
    required String bookingType,
    required String travellerPhone,
    required String pickupAddress,
    String? dropoffAddress,
    required String pickupLat,
    required String pickupLng,
    String? dropLat,
    String? dropLng,
    String? couponCode,
    required String date,
    required String time,

    // Optional fields
    String? returnDate,
    String? returnTime,
    String? selectedHours,
    String? tripDays,
    required String segmentId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.fareSummaryApi(
        context: context,
        bookingType: bookingType,
        travellerPhone: travellerPhone,

        pickupAddress: pickupAddress,
        dropoffAddress: dropoffAddress,

        pickupLat: pickupLat!.toString(),
        pickupLng: pickupLng!.toString(),
        dropLat: dropLat?.toString(),
        dropLng: dropLng?.toString(),

        date: date,
        time: time,
        segmentId: segmentId,
        couponCode: couponCode,
        // time: timeController.text,

        /// 🔥 Extra fields
        returnDate: returnDate,
        // tum alag bhi rakh sakte ho
        returnTime: returnTime,
        // returnTime: returnTimeController.text,
        selectedHours: selectedHours,
        // dynamic kar lena
        tripDays: "1",
      );
      // saveFavoriteLocations(
      //   context: context,
      //   location: dropController.text,
      //   latitude: dropLat.toString(),
      //   longitude: dropLng.toString(),
      //   addressType: "Home"
      // );
      fareSummaryModel = res;
    } catch (e) {
      debugPrint(" fareSummaryModel Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 CHECK VERIFICATION
  Future<void> checkVerification(String mobile, BuildContext context) async {
    try {
      final res = await api.checkVerificationApi(
        context: context,
        mobile: mobile,
      );

      isVerified = res.data?.isVerified ?? false;
      notifyListeners();
    } catch (e) {
      debugPrint("checkVerification error: $e");
    }
  }

  /// 🔹 SEND OTP
  Future<void> sendOtp(String mobile, BuildContext context) async {
    try {
      final res = await api.sendOTPApi(context: context, mobile: mobile);

      if (res.status == true) {
        isOtpSent = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("sendOtp error: $e");
    }
  }

  /// 🔹 VERIFY OTP
  Future<void> verifyOtp(
      String mobile,
      String otp,
      BuildContext context,
      ) async {
    try {
      final res = await api.verifyOtpApi(
        context: context,
        mobile: mobile,
        otp: otp,
      );

      if (res.data?.isVerified == true) {
        isVerified = true;
        isOtpVerified = true;
        isOtpSent = false;
        notifyListeners();
      }
    } catch (e) {
      debugPrint("verifyOtp error: $e");
    }
  }

  Future<void> createOneWayBooking({
    required BuildContext context,
    required String bookingType,
    required String pickupAddress,
    required String dropoffAddress,
    required String pickupLat,
    required String pickupLng,
    required String dropLat,
    required String dropLng,
    required String estimatedKm,
    required String estimatedMins,
    required String estimatedFare,
    required String tollAmount,
    required String timeType,
    required String polyline,
    required String baseFare,
    required String distanceCharge,
    required String timeCharge,
    required String surgeCharge,
    required String subtotal,
    required String gstPercent,
    required String gstAmount,
    required String tollCharge,
    required String totalFare,
    required String surgeMultiplier,
    required String surgeLabel,
    required String paymentMethod,
    required String gatewayRef,
    required String regionId,
    required String segmentId,
    required String scheduledDate,
    required String scheduledTime,
    required String returnDate,
    required String returnTime,
    required String selectedHours,
    required String bookedKms,
    required String tripDays,
    required String toCity,
    required String travellerName,
    required String travellerEmail,
    required String travellerPhone,
    required bool isPickupAirport,
    required bool isDropAirport,
    required bool isAirportTrip,
    required bool isGrayMatter,
    required String surchargeAmount,
    required String airportFare,
    required String nightFare,
    //New Added
    String? effectiveDistanceKm,
    String? effectiveTotalMins,
    String? idleMinsBetweenLegs,
    String? returnTravelMins,
    String? oneWayDistanceKm,
    String? oneWayTravelMins,
    required String mcdTollCharge,
    required String nightCount,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final res = await api.createBookingSummary(
        coupon: coupon,
        context: context,
        mcdTollCharge: mcdTollCharge,
        nightCount: nightCount,
        surchargeAmount: surchargeAmount,
        airportFare: airportFare,

        bookingType: bookingType,
        travellerEmail: travellerEmail,
        travellerName: travellerName,
        travellerPhone: travellerPhone,
        segmentId: segmentId,
        regionId: regionId,

        pickupAddress: pickupAddress,
        dropoffAddress: dropoffAddress,
        pickupLat: pickupLat,
        pickupLng: pickupLng,
        dropLat: dropLat,
        dropLng: dropLng,

        estimatedKm: estimatedKm,
        estimatedMins: estimatedMins,
        estimatedFare: estimatedFare,

        timeType: timeType,
        tollAmount: tollAmount,
        polyline: polyline,

        baseFare: baseFare,
        distanceCharge: distanceCharge,
        timeCharge: timeCharge,
        surgeCharge: surgeCharge,
        subtotal: subtotal,
        gstPercent: gstPercent,
        gstAmount: gstAmount,
        tollCharge: tollCharge,
        totalFare: totalFare,
        surgeMultiplier: surgeMultiplier,
        surgeLabel: surgeLabel,

        paymentMethod: "upi",
        gatewayRef: "TEST_TXN_123",

        scheduledDate: scheduledDate,
        scheduledTime: scheduledTime,
        returnDate: returnDate,
        returnTime: returnTime,
        selectedHours: selectedHours,
        bookedKms: bookedKms,
        tripDays: tripDays,
        toCity: toCity,
        isAirportTrip: isAirportTrip,
        isDropAirport: isDropAirport,
        isGrayMatter: isGrayMatter,
        isPickupAirport: isPickupAirport,
        nightFare: nightFare,
        //new added
        effectiveDistanceKm: effectiveDistanceKm,
        effectiveTotalMins: effectiveTotalMins,
        idleMinsBetweenLegs: idleMinsBetweenLegs,
        returnTravelMins: returnTravelMins,
        oneWayDistanceKm:oneWayDistanceKm ,
        oneWayTravelMins: oneWayTravelMins,
      );

      createBookingSummeryModel = res;
      if (res != null || res.status == true) {
        print("oneWayBooking Create Successfully");
      }
    } catch (e) {
      debugPrint("Error in oneWayBooking: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
