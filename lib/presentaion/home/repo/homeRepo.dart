import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/home/model/recent_location.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';

import '../../../shuttleModule/shuttleList/model/allUniqueStoppageModel.dart';


import '../model/savedRecentSearchModel.dart';
import '../ui/model/bannerModel.dart';
import '../ui/model/choosePackageModel.dart';
import '../ui/model/oneWayBookingModel.dart';
import '../ui/model/shuttleShiftStopPageModel.dart';

class HomeRepo {
  final ApiService _api = ApiService();

  Future<BannerModel> getBannerApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.banner, requiresAuth: true);
      return BannerModel.fromJson(response);
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

  Future<RecentLocationModel> getRecentLocations({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.recentTripLocations,
        requiresAuth: true,
      );
      return RecentLocationModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getRecentLocations(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getRecentLocations(context: context),
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

  // Future<GetNewRecentSearchModel> getRecentSearchHistoryNew({
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final response = await _api.get(
  //       ApiConstants.recentSearcheHistory,
  //       requiresAuth: true,
  //     );
  //     return GetNewRecentSearchModel.fromJson(response);
  //   } on DioException catch (e) {
  //     if (e.error is NoInternetException) {
  //       showNoInternetScreen(
  //         context,
  //         onRetry: () => getRecentLocations(context: context),
  //       );
  //       throw NoInternetException();
  //     } else if (e.error is ServerException) {
  //       showServerErrorScreen(
  //         context,
  //         onRetry: () => getRecentLocations(context: context),
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

  Future<SavedRecentSearchModel> postRecentSearchHistoryNew({
    required BuildContext context,
    required String location,
    // required String nearAddress,
    // required String addressType,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.recentSearcheHistory,
        requiresAuth: true,
        data: {
          "location": location, "latitude": latitude,
          "longitude":longitude,
          // "addressType":addressType,
          // "addressName":nearAddress,
        }
      );
      return SavedRecentSearchModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => postRecentSearchHistoryNew(context: context,latitude: latitude,location: location,longitude: longitude,

              // nearAddress: nearAddress,addressType: addressType

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => postRecentSearchHistoryNew(context: context,latitude: latitude,location: location,longitude: longitude
              // ,addressType: addressType,nearAddress: nearAddress
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
  }

  Future<Map<String, dynamic>> saveFavoriteLocations({
    required BuildContext context,
    required String location,
    required String latitude,
    required String longitude,
    required String addressType,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.recentSearches,
        requiresAuth: true,
        data: {
          "location": location,
          "latitude": latitude,
          "longitude": longitude,
          "addressType": addressType,
        },
      );
      return response;
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => saveFavoriteLocations(
            context: context,
            location: location,
            latitude: latitude,
            longitude: longitude,
              addressType:addressType
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => saveFavoriteLocations(
            context: context,
            location: location,
            latitude: latitude,
            longitude: longitude,
              addressType:addressType
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
  }  Future<Map<String, dynamic>> removeFavoriteLocations({
    required BuildContext context,
    required String id,

  }) async {
    try {
      final response = await _api.delete(
        "${ApiConstants.recentSearches}/$id",
        requiresAuth: true,

      );
      return response;
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => removeFavoriteLocations(
            context: context,
            id: id

          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => removeFavoriteLocations(

              context: context,
              id: id
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
  }

  Future<ShuttleShiftStopPageModel> getShuttleShiftStopApi({
    required BuildContext context,
    required String source,
    required String destination,
    required String date,
    required String travelType,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.shuttleShiftStoppage,
        queryParameters: {
          'source': source,
          'destination': destination,
          'date': date,
          'travelType':travelType
        },
        // "${ApiConstants.shuttleShiftStoppage}?source=$source&destination=$destination&date=$date",
        // data: {'mobile': phone,"countryCode":countryCode },

        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return ShuttleShiftStopPageModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return ShuttleShiftStopPageModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getShuttleShiftStopApi(
            context: context,
            source: source,
            destination: destination,
            date: date,
              travelType:travelType
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getShuttleShiftStopApi(
            context: context,
            source: source,
            destination: destination,            date: date,travelType:travelType
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
  }

  Future<AllUniqueStoppageModel> getStoppageNameApi({
    required BuildContext context,
    required String search,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.stoppageNames}?search=$search",
        // data: {'mobile': phone,"countryCode":countryCode },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return AllUniqueStoppageModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return AllUniqueStoppageModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getStoppageNameApi(context: context, search: search),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getStoppageNameApi(context: context, search: search),
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

  Future<ChoosePackageModel> getHourlyPackageApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.hourlyPackage,
        // data: {'mobile': phone,"countryCode":countryCode },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return ChoosePackageModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return ChoosePackageModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getHourlyPackageApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getHourlyPackageApi(context: context),
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
        // "regionId": "69b3aa39b73e22ea2eaa192f",
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
    } on DioException catch (e) {
      if (e.response?.data != null) {
        return OneWayBookingModel.fromJson(
          e.response!.data,
        );
      }

      rethrow;
    }
    // } catch (e) {
    //   rethrow;
    // }
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
