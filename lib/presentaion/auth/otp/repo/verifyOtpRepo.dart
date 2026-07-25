import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/resendOtpModel.dart';
import '../model/verifyOtpModel.dart';

class VerifyOtpRepo {
  final ApiService _api = ApiService();

  Future<VerifyOtpModel> verifyOtp({
    required String phone,
    required String otp,
    required String fcmToken,
    required String deviceId,
    required String deviceType,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.verifyOtp,
        data: {
          'mobile': phone,
          "otp": otp,
          "fcmToken": fcmToken,
          "deviceId": deviceId,
          "deviceType": deviceType,
        },
        requiresAuth: false,
      );
      await SecureStorageService.saveToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhMTUzMDdiZmNlNTQyMjRmYjk3Y2JiNyIsImlhdCI6MTc4NDg5NDg3NH0.e28z5bgJIlH0uRIdeE58ak05wntiyICVaJKcIB05Xic");
      // await SecureStorageService.saveToken(response['token']);
      return VerifyOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => verifyOtp(
            phone: phone,
            otp: otp,
            context: context,
            fcmToken: fcmToken,
            deviceId: deviceId,
            deviceType: deviceType,
          ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => verifyOtp(
            phone: phone,
            otp: otp,
            context: context,
            fcmToken: fcmToken,
            deviceType: deviceType,
            deviceId: deviceId,
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

  Future<ResendOtpModel> resendOtpApi({
    required String phone,

    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.signUp,
        data: {'mobile': phone, "countryCode": "+91"},
        requiresAuth: false,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return ResendOtpModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => resendOtpApi(phone: phone, context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => resendOtpApi(phone: phone, context: context),
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
