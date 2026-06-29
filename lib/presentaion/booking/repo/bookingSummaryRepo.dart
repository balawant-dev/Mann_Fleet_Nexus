import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/checkedVerificationStatusModel.dart';
import '../model/createBookingSummeryModel.dart';
import '../model/sentOTPModel.dart';
import '../model/verifyOTPModel.dart';

class BookingSummaryRepo {
  final ApiService _api = ApiService();


  Future<SentOTPModel> sendOTPApi({
    required BuildContext context,
    required String mobile,

  }) async {
    try {
      final data = {
        "mobile":mobile,
      };
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

  Future<VerifyOTPModel> verifyOtpApi({
    required BuildContext context,
    required String mobile,
    required String otp,

  }) async {
    try {
      final data = {
        "mobile":mobile,
        "otp":otp
      };
    final response = await _api.post(
        ApiConstants.verifyOtpVerification,
        data: data,
        requiresAuth: true,
      );

      return VerifyOTPModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }  Future<CheckedVerificationStatusModel> checkVerificationApi({
    required BuildContext context,
    required String mobile,


  }) async {
    try {
      final data = {
        "mobile":mobile,
      };
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

    required   bool isPickupAirport,
    required   bool isDropAirport,
    required    bool isAirportTrip,
    required   bool isGrayMatter,
    required   String surchargeAmount,
    required   String airportFare,
    required   String nightFare,
    //New Add

    String? effectiveDistanceKm,
    String? effectiveTotalMins,
    String? idleMinsBetweenLegs,
    String? returnTravelMins,
  }) async {
    try {
      final data = {
        "travellerName":travellerName,
        "travellerEmail":travellerEmail,
        "travellerPhone":travellerPhone,
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
          "surchargeAmount":surchargeAmount??"0",
          "airportFare":airportFare??"0",
          "nightFare":nightFare??"0",
        },
      };

      /// 🔥 CONDITION BASED PAYLOAD
      if (bookingType == "one_way") {
        data.addAll({
          "isPickupAirport":isPickupAirport??false,
          "isDropAirport":isDropAirport??false,
          "isAirportTrip":isAirportTrip??false,
          "isGrayMatter":isGrayMatter??false,




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
          "estimatedKm": estimatedKm,
          "estimatedMins": estimatedMins,
          "estimatedFare": estimatedFare,
          "timeType": timeType,
          "tollAmount": tollAmount,
          "polyline": polyline,
          "returnDate": returnDate??"2026-12-25",
          "returnTime": returnTime??"23:00",
        });

        /// 🔥 ADD THIS BLOCK
        if (effectiveDistanceKm != null ||
            effectiveTotalMins != null ||
            idleMinsBetweenLegs != null ||
            returnTravelMins != null) {

          data["roundTripDetail"] = {
            if (effectiveDistanceKm != null)
              "effectiveDistanceKm": effectiveDistanceKm,
            if (effectiveTotalMins != null)
              "effectiveTotalMins": effectiveTotalMins,
            if (idleMinsBetweenLegs != null)
              "idleMinsBetweenLegs": idleMinsBetweenLegs,
            if (returnTravelMins != null)
              "returnTravelMins": returnTravelMins,
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

      final response = await _api.post(
        ApiConstants.booking,
        data: data,
        requiresAuth: true,
      );

      return CreateBookingSummeryModel.fromJson(response);
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }
}
