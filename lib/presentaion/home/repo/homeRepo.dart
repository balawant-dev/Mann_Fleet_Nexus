import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../ui/model/bannerModel.dart';
import '../ui/model/oneWayBookingModel.dart';

class HomeRepo {
  final ApiService _api = ApiService();

  Future<BannerModel> getBannerApi({required BuildContext context}) async {
    try {
      final response = await _api.get(
        ApiConstants.banner,
        // data: {'mobile': phone,"countryCode":countryCode },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BannerModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getBannerApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getBannerApi(context: context),
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
  }
  Future<OneWayBookingModel> createBooking({
    required BuildContext context,
    required String bookingType,
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
    int? selectedHours,
    int? tripDays,
  }) async {
    try {
      Map<String, dynamic> data = {
        "bookingType": bookingType,
        "pickupAddress": pickupAddress,
        "pickupLat": pickupLat,
        "pickupLng": pickupLng,
        "regionId": "69b3aa39b73e22ea2eaa192f",
        "date": date,
        "time": time,
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
        ApiConstants.bookingEstimate,
        data: data,
        requiresAuth: true,
      );

      return OneWayBookingModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
  // Future<OneWayBookingModel> createOneWayBooking({
  //   required BuildContext context,
  //   required String bookingType,//round_trip,one_way
  //   required String pickupAddress,
  //   required String dropoffAddress,
  //   required String pickupLat,
  //   required String pickupLng,
  //   required String dropLat,
  //   required String dropLng,
  //   // required String regionId,
  //   required String date,
  //   required String time,
  // }) async {
  //   try {
  //     final response = await _api.post(
  //       ApiConstants.bookingEstimate,
  //       data: {
  //         'bookingType': bookingType,
  //         "pickupAddress": pickupAddress,
  //         "dropoffAddress": dropoffAddress,
  //         "pickupLat": pickupLat,
  //         "pickupLng": pickupLng,
  //         "dropLat": dropLat,
  //         "dropLng": dropLng,
  //         "regionId": "69b3aa39b73e22ea2eaa192f",
  //         "date": date,
  //         "time": time,
  //       },
  //       requiresAuth: true,
  //     );
  //     //   await SecureStorageService.saveToken(response['token']);
  //     return OneWayBookingModel.fromJson(response);
  //     //  return LoginModel.fromJson(response['user']);
  //   } on DioException catch (e) {
  //     if (e.error is NoInternetException) {
  //       showNoInternetScreen(
  //         context,
  //         onRetry:
  //             () => createOneWayBooking(
  //               context: context,
  //               bookingType: bookingType,
  //               date: date,
  //               dropLat: dropLat,
  //               dropLng: dropLng,
  //               dropoffAddress: dropoffAddress,
  //               pickupAddress: pickupAddress,
  //               pickupLat: pickupLat,
  //               pickupLng: pickupLng,
  //               // regionId: regionId,
  //               time: time,
  //             ),
  //       );
  //       throw NoInternetException();
  //     } else if (e.error is ServerException) {
  //       showServerErrorScreen(
  //         context,
  //         onRetry: () => createOneWayBooking(  context: context,
  //           bookingType: bookingType,
  //           date: date,
  //           dropLat: dropLat,
  //           dropLng: dropLng,
  //           dropoffAddress: dropoffAddress,
  //           pickupAddress: pickupAddress,
  //           pickupLat: pickupLat,
  //           pickupLng: pickupLng,
  //           // regionId: regionId,
  //           time: time,),
  //       );
  //       throw ServerException();
  //     } else if (e.error is UnauthorizedException) {
  //       await SecureStorageService.logout(context);
  //       throw UnauthorizedException();
  //     } else {
  //       rethrow;
  //     }
  //   } catch (e) {
  //     throw ApiException(0, e.toString());
  //   }
  // }
}
