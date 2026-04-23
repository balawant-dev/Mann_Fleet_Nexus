import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/signinModel.dart';
class SignInRepo{
  final ApiService _api = ApiService();

  Future<SignInModel> sendOtp({
    required String phone,
    required String countryCode ,
    required BuildContext context,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.signUp,
        data: {'mobile': phone,"countryCode":countryCode },
        requiresAuth: false,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return SignInModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => sendOtp(phone: phone, context: context,countryCode :countryCode ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => sendOtp(phone: phone, context: context,countryCode :countryCode ),
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