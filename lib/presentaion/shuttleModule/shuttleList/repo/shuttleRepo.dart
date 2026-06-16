import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/generateQrModel.dart';
import '../model/getShuttlePassesModel.dart';
import '../model/purchaseShuttlePassModel.dart';


class ShuttleRepo {
  final ApiService _api = ApiService();




  Future<GetShuttlePassesModel> getShuttlePassesApi({required BuildContext context,required String source,required String destination,required String shuttleShiftId,required String bookingDate}) async {
    try {
      final response = await _api.get(
        "${ApiConstants.shuttlePassDestinationPricing}?source=$source&destination=$destination&shuttleShifId=$shuttleShiftId&bookingDate=$bookingDate",
        // data: {'mobile': phone,"countryCode":countryCode },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return GetShuttlePassesModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getShuttlePassesApi(context: context,source: source,destination: destination,bookingDate: bookingDate,shuttleShiftId: shuttleShiftId),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getShuttlePassesApi(context: context,source: source,destination: destination,shuttleShiftId: shuttleShiftId,bookingDate: bookingDate),
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


  Future<PurchaseShuttlePassModel> purchaseShuttlePassApi({required BuildContext context,required String source,required String destination,required String passId,required String bookingDate,required String shiftId }) async {
    try {
      final response = await _api.post(
  ApiConstants.purchaseShuttlePass,
        data: {'passId': passId,"source":source,"destination":destination,"bookingDate":bookingDate ,"shiftId":shiftId },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return PurchaseShuttlePassModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        final model = PurchaseShuttlePassModel.fromJson(
          e.response!.data,
        );
        print(">>>>>>>>>>>>>>>>>>>>>>>>okkk");

        print(model.status); // false
        print(model.message); // This time slot is fully booked...

        return model;
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => purchaseShuttlePassApi(context: context,source: source,destination: destination,passId: passId,bookingDate: bookingDate,shiftId: shiftId),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => purchaseShuttlePassApi(context: context,source: source,destination: destination,passId: passId,bookingDate: bookingDate,shiftId: shiftId),
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
  }  Future<GenerateQrModel> generateQrApi({required BuildContext context,required String transactionId,required String source,required String destination}) async {
    try {
      final response = await _api.post(
  ApiConstants.generateQr,
        data: {'transactionId': transactionId,"source":source,"destination":destination },
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return GenerateQrModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {

      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return GenerateQrModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => generateQrApi(context: context,transactionId: transactionId,destination: destination,source: source),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => generateQrApi(context: context,transactionId: transactionId,source: source,destination: destination),
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


}
