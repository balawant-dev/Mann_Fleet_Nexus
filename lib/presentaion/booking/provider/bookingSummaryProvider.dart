import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../model/createBookingSummeryModel.dart';
import '../repo/bookingSummaryRepo.dart';
// import '../repo/bookingHistoryRepo.dart';

class BookingSummaryProvider extends ChangeNotifier {
  final api = BookingSummaryRepo();

  CreateBookingSummeryModel? createBookingSummeryModel;

  bool isLoading = false;
  bool isLoading2 = false;
  bool isVerified = false;
  bool isOtpSent = false;
  bool isOtpVerified = false;
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
      final res = await api.sendOTPApi(
        context: context,
        mobile: mobile,
      );

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
      String mobile, String otp, BuildContext context) async {
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
    required   String surchargeAmount,
    required   String airportFare,
    required   String nightFare,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      final res = await api.createBookingSummary(
        context: context,
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
