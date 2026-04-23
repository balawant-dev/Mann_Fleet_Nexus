import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';

import '../model/notificationDetailModel.dart';
import '../model/notificationModel.dart';


class NotificationRepo {
  final ApiService _api = ApiService();



  Future<GetNotificationModel> getNotificationApi({required BuildContext context}) async {
    try {
      final response = await _api.get(
          ApiConstants.notification
          // "${ApiConstants.notification}?type=user"
          , requiresAuth: true);

      return GetNotificationModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getNotificationApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getNotificationApi(context: context),
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
  Future<NotificationDetailModel> getNotificationDetailApi({required BuildContext context,required String id}) async {
    try {
      final response = await _api.get("${ApiConstants.notification}/${id}", requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return NotificationDetailModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getNotificationDetailApi(context: context,id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getNotificationDetailApi(context: context,id: id),
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
