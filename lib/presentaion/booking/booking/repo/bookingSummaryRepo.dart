import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/appliedCouponsModel.dart';
import '../model/checkedVerificationStatusModel.dart';
import '../model/createBookingSummeryModel.dart';
import '../model/fareSummaryModel.dart';
import '../model/getCouponsModel.dart';
import '../model/sentOTPModel.dart';
import '../model/verifyOTPModel.dart';

class BookingSummaryRepo {
  final ApiService _api = ApiService();

  Future<SentOTPModel> sendOTPApi({
    required BuildContext context,
    required String mobile,
  }) async {
    try {
      final data = {"mobile": mobile};
      final response = await _api.post(
        ApiConstants.sendOtpVerification,
        data: data,
        requiresAuth: true,
      );

      return SentOTPModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<GetCouponsModel> getCouponApi({
    required BuildContext context,
    required String amount,
    required String dropLat,
    required String dropLng,
    required String pickupLat,
    required String pickupLng,
  }) async {
    try {
      final data = {
        "amount": amount,
        "drop": {"lat": dropLat, "lng": dropLng},
        "pickup": {"lat": pickupLat, "lng": pickupLng},
      };
      final response = await _api.post(
        ApiConstants.getCoupon,
        data: data,
        requiresAuth: true,
      );

      return GetCouponsModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<AppliedCouponsModel> applyCouponApi({
    required BuildContext context,
    required String amount,
    required String couponCode,
    required String dropLat,
    required String dropLng,
    required String pickupLat,
    required String pickupLng,
  }) async {
    try {
      final data = {
        "amount": amount,
        "couponCode": couponCode,
        "drop": {"lat": dropLat, "lng": dropLng},
        "pickup": {"lat": pickupLat, "lng": pickupLng},
      };
      final response = await _api.post(
        ApiConstants.applyCoupon,
        data: data,
        requiresAuth: true,
      );

      return AppliedCouponsModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return AppliedCouponsModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => applyCouponApi(
                context: context,
                amount: amount,
                couponCode: couponCode,
                dropLat: dropLat,
                dropLng: dropLng,
                pickupLat: pickupLat,
                pickupLng: pickupLng,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => applyCouponApi(
                context: context,
                amount: amount,
                couponCode: couponCode,
                dropLat: dropLat,
                dropLng: dropLng,
                pickupLat: pickupLat,
                pickupLng: pickupLng,
              ),
        );
        throw ServerException();
      } else if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      } else {
        rethrow;
      }
    } catch (e) {
      throw ApiException(0, e.toString());
    }

    // } catch (e) {
    //   if (e.response != null) {
    //     // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
    //     try {
    //       return AppliedCouponsModel.fromJson(e.response!.data);
    //     } catch (_) {
    //       rethrow;
    //     }
    //   }
    //   throw ApiException(0, e.toString());
    // }
  }

  Future<FareSummaryModel> fareSummaryApi({
    required BuildContext context,
    required String bookingType,
    required String travellerPhone,
    required String pickupAddress,
    String? dropoffAddress,
    required String pickupLat,
    required String pickupLng,
    String? dropLat,
    String? dropLng,
    required String date,
    required String time,

    // Optional fields
    String? returnDate,
    String? returnTime,
    String? selectedHours,
    String? tripDays,
    String? couponCode,
    required String segmentId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "bookingType": bookingType,
        "travellerPhone": travellerPhone,
        "pickupAddress": pickupAddress,
        "pickupLat": pickupLat,
        "pickupLng": pickupLng,
        // "regionId": "69b3aa39b73e22ea2eaa192f",
        "date": date,
        "time": time,
        "couponCode": couponCode,
        "segmentId": segmentId,
      };

      /// 🔥 Add fields conditionally
      if (bookingType != "hourly") {
        data["dropoffAddress"] = dropoffAddress;
        data["dropLat"] = dropLat;
        data["dropLng"] = dropLng;
      }

      if (bookingType == "round_trip") {
        data["returnDate"] = returnDate;
        data["returnTime"] = returnTime;
      }

      if (bookingType == "hourly") {
        data["selectedHours"] = selectedHours;
      }

      if (bookingType == "intercity") {
        data["tripDays"] = tripDays;
      }

      final response = await _api.post(
        ApiConstants.fareSummary,
        data: data,
        requiresAuth: true,
      );

      return FareSummaryModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return FareSummaryModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }

      // if (e.response?.data != null) {
      //   return FareSummaryModel.fromJson(
      //     e.response!.data,
      //   );
      // }

      rethrow;
    }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<FareSummaryModel> fareSummaryTabApi({
    required BuildContext context,
    required String bookingType,
    required String travellerPhone,
    required String pickupAddress,
    String? dropoffAddress,
    required String pickupLat,
    required String pickupLng,
    String? dropLat,
    String? dropLng,
    required String date,
    required String time,

    // Optional fields
    String? returnDate,
    String? returnTime,
    String? selectedHours,
    String? tripDays,
    String? couponCode,
    required String segmentId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "bookingType": bookingType,
        "pickupAddress": pickupAddress,
        "travellerPhone": travellerPhone,
        "pickupLat": pickupLat,
        "pickupLng": pickupLng,
        // "regionId": "69b3aa39b73e22ea2eaa192f",
        "date": date,
        "time": time,
        "couponCode": couponCode,
        "segmentId": segmentId,
      };

      /// 🔥 Add fields conditionally
      if (bookingType != "hourly") {
        data["dropoffAddress"] = dropoffAddress;
        data["dropLat"] = dropLat;
        data["dropLng"] = dropLng;
      }

      if (bookingType == "round_trip") {
        data["returnDate"] = returnDate;
        data["returnTime"] = returnTime;
      }

      if (bookingType == "hourly") {
        data["selectedHours"] = selectedHours;
      }

      if (bookingType == "intercity") {
        data["tripDays"] = tripDays;
      }

      final response = await _api.post(
        ApiConstants.fareSummaryTab,
        data: data,
        requiresAuth: true,
      );

      return FareSummaryModel.fromJson(response);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return FareSummaryModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }

      // if (e.response?.data != null) {
      //   return FareSummaryModel.fromJson(
      //     e.response!.data,
      //   );
      // }

      rethrow;
    }
    // } catch (e) {
    //   rethrow;
    // }
  }

  Future<VerifyOTPModel> verifyOtpApi({
    required BuildContext context,
    required String mobile,
    required String otp,
  }) async {
    try {
      final data = {"mobile": mobile, "otp": otp};
      final response = await _api.post(
        ApiConstants.verifyOtpVerification,
        data: data,
        requiresAuth: true,
      );

      return VerifyOTPModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<CheckedVerificationStatusModel> checkVerificationApi({
    required BuildContext context,
    required String mobile,
  }) async {
    try {
      final data = {"mobile": mobile};
      final response = await _api.post(
        ApiConstants.checkVerification,
        data: data,
        requiresAuth: true,
      );

      return CheckedVerificationStatusModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<CreateBookingSummeryModel> createBookingSummary({
    required BuildContext context,
    required String coupon,
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
    required String segmentId,
    required String regionId,
    required String scheduledDate,
    required String scheduledTime,
    required String travellerName,
    required String travellerEmail,
    required String travellerPhone,

    /// 🔥 NEW
    String? returnDate,
    String? returnTime,
    String? selectedHours,
    String? bookedKms,
    String? tripDays,
    String? toCity,

    required bool isPickupAirport,
    required bool isDropAirport,
    required bool isAirportTrip,
    required bool isGrayMatter,
    required String surchargeAmount,
    required String airportFare,
    required String nightFare,

    //New Add
    String? effectiveDistanceKm,
    String? oneWayDistanceKm,
    String? oneWayTravelMins,
    String? effectiveTotalMins,
    String? idleMinsBetweenLegs,
    String? returnTravelMins,

    required String mcdTollCharge,
    required String nightCount,
  }) async {
    final data = {
      "couponCode": coupon,
      "travellerName": travellerName,
      "travellerEmail": travellerEmail,
      "travellerPhone": travellerPhone,
      "bookingType": bookingType,
      "segmentId": segmentId,
      "regionId": regionId,

      "pickupLat": pickupLat,
      "pickupLng": pickupLng,
      "pickupAddress": pickupAddress,

      "scheduledDate": scheduledDate,
      "scheduledTime": scheduledTime,

      "fareBreakdown": {
        "baseFare": baseFare,
        "distanceCharge": distanceCharge,
        "timeCharge": timeCharge,
        "surgeCharge": surgeCharge,
        "subtotal": subtotal,
        "gstPercent": gstPercent,
        "gstAmount": gstAmount,
        "tollCharge": tollCharge,
        "totalFare": totalFare,
        "surgeMultiplier": surgeMultiplier,
        "surgeLabel": surgeLabel,
        "surchargeAmount": surchargeAmount ?? "0",
        "airportFare": airportFare ?? "0",
        "nightFare": nightFare ?? "0",
      },
    };

    /// 🔥 CONDITION BASED PAYLOAD
    if (bookingType == "one_way") {
      data.addAll({
        "isPickupAirport": isPickupAirport ?? false,
        "isDropAirport": isDropAirport ?? false,
        "isAirportTrip": isAirportTrip ?? false,
        "isGrayMatter": isGrayMatter ?? false,

        "dropLat": dropLat,
        "dropLng": dropLng,
        "dropoffAddress": dropoffAddress,
        "estimatedKm": estimatedKm,
        "estimatedMins": estimatedMins,
        "estimatedFare": estimatedFare,
        "timeType": timeType,
        "tollAmount": tollAmount,
        "polyline": polyline,
      });
    }

    if (bookingType == "round_trip") {
      //round trip me ye add hoga
      // "roundTripEffective": {
      //             "effectiveDistanceKm": 93.9,
      //             "effectiveTotalMins": 1588,
      //             "idleMinsBetweenLegs": 1412,
      //             "returnTravelMins": 88
      //         },
      data.addAll({
        "dropLat": dropLat,
        "dropLng": dropLng,
        "dropoffAddress": dropoffAddress,
        "estimatedKm": effectiveDistanceKm.toString(),
        "estimatedMins": effectiveTotalMins.toString(),
        "estimatedFare": estimatedFare,
        "timeType": timeType,
        "tollAmount": tollAmount,
        "polyline": polyline,
        // NEW KEYS
        "mcdTollCharge": mcdTollCharge,
        "nightCount": nightCount,
        "returnDate": returnDate ?? "2026-12-27",
        "returnTime": returnTime ?? "23:00",
        // Missing fields from sample payload
        "isPickupAirport": isPickupAirport,
        "isDropAirport": isDropAirport,
        "isAirportTrip": isAirportTrip,
        "isGrayMatter": isGrayMatter,
      });

      /// 🔥 ADD THIS BLOCK
      if (effectiveDistanceKm != null ||
          effectiveTotalMins != null ||
          oneWayDistanceKm != null ||
          idleMinsBetweenLegs != null ||
          oneWayTravelMins != null ||
          returnTravelMins != null) {
        data["roundTripDetail"] = {
          if (effectiveDistanceKm != null)
            "effectiveDistanceKm": effectiveDistanceKm,
          if (effectiveTotalMins != null)
            "effectiveTotalMins": effectiveTotalMins,
          if (oneWayDistanceKm != null) "oneWayDistanceKm": oneWayDistanceKm,
          if (idleMinsBetweenLegs != null)
            "idleMinsBetweenLegs": idleMinsBetweenLegs,
          if (oneWayTravelMins != null) "oneWayTravelMins": oneWayTravelMins,
          if (returnTravelMins != null) "returnTravelMins": returnTravelMins,
        };
      }
      // if (effectiveDistanceKm != null ||
      //     effectiveTotalMins != null ||
      //     idleMinsBetweenLegs != null ||
      //     returnTravelMins != null) {
      //   data["roundTripDetail"] = {
      //     if (effectiveDistanceKm != null)
      //       "effectiveDistanceKm": effectiveDistanceKm,
      //     if (effectiveTotalMins != null)
      //       "effectiveTotalMins": effectiveTotalMins,
      //     if (idleMinsBetweenLegs != null)
      //       "idleMinsBetweenLegs": idleMinsBetweenLegs,
      //     if (returnTravelMins != null)
      //       "returnTravelMins": returnTravelMins,
      //   };
      // }
    }

    if (bookingType == "intercity") {
      data.addAll({
        "dropLat": dropLat,
        "dropLng": dropLng,
        "dropoffAddress": dropoffAddress,
        "estimatedKm": estimatedKm,
        "estimatedMins": estimatedMins,
        "estimatedFare": estimatedFare,
        "timeType": timeType,
        "tollAmount": tollAmount,
        "polyline": polyline,
        "toCity": toCity ?? "GKP",
        "tripDays": tripDays ?? "10",
        "mcdTollCharge": mcdTollCharge,
        "nightCount": nightCount,
        "isGrayMatter": isGrayMatter ?? false,
      });
    }

    if (bookingType == "hourly") {
      data.addAll({
        "selectedHours": selectedHours ?? "5",
        "bookedKms": bookedKms ?? "50",
        "estimatedFare": estimatedFare,
        "timeType": timeType,
        "tollAmount": tollAmount,
      });
    }
    print("Booking Data is ");
    print("📤 ================= BOOKING API REQUEST =================");
    print("📤 URL: ${ApiConstants.booking}");
    print("📤 METHOD: POST");

    debugPrint("📤 REQUEST DATA: ${jsonEncode(data)}", wrapWidth: 1024);

    try {
      final response = await _api.post(
        ApiConstants.booking,
        data: data,
        requiresAuth: true,
      );

      print("📥 ================= BOOKING API RESPONSE =================");

      // _api.post() directly response body return kar raha hai
      debugPrint("📥 RESPONSE DATA: ${jsonEncode(response)}", wrapWidth: 1024);

      print("📥 RESPONSE TYPE: ${response.runtimeType}");

      print("📥 =========================================================");

      return CreateBookingSummeryModel.fromJson(
        response as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      print("❌ ================= BOOKING API ERROR =================");
      print("❌ ERROR TYPE: ${e.type}");
      print("❌ ERROR MESSAGE: ${e.message}");

      if (e.response != null) {
        print("❌ STATUS CODE: ${e.response?.statusCode}");
        print("❌ STATUS MESSAGE: ${e.response?.statusMessage}");

        debugPrint(
          "❌ ERROR RESPONSE: ${jsonEncode(e.response?.data)}",
          wrapWidth: 1024,
        );

        print("❌ =======================================================");

        try {
          return CreateBookingSummeryModel.fromJson(
            e.response!.data as Map<String, dynamic>,
          );
        } catch (_) {
          rethrow;
        }
      }

      throw ApiException(0, e.toString());
    } catch (e, stackTrace) {
      print("❌ ================= UNKNOWN ERROR =================");
      print("❌ ERROR: $e");
      print("❌ ERROR TYPE: ${e.runtimeType}");

      debugPrint("❌ STACK TRACE:\n$stackTrace", wrapWidth: 1024);

      print("❌ ==================================================");

      throw ApiException(0, e.toString());
    }
  }
}
