import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/editProfileModel.dart';
import '../model/getProfileModel.dart';

class ProfileRepo {
  final ApiService _api = ApiService();

  Future<EditProfileModel> editProfileApi({
    required String name,
    required String email,
    required String city,
    required String gender, //male,female,other,
    required String dob, //"1998-08-20",
    required String profilePic,
    required BuildContext context,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'name': name, //"1998-08-20",
        "gender": gender,
        "email": email,
        "dob": dob,
        "city": city,
      });
      if (profilePic.isNotEmpty) {
        formData.files.add(MapEntry(
          "profilePic",
          await MultipartFile.fromFile(profilePic, filename: profilePic.split('/').last),
        ));
      }
      final response = await _api.patchMultipart(
        ApiConstants.profile,
        data: formData,
        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return EditProfileModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry:
              () => editProfileApi(
                dob: dob,
                city: city,
                profilePic: profilePic,
                email: email,
                gender: gender,
                context: context,
                name: name,
              ),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry:
              () => editProfileApi(
                dob: dob,
                city: city,
                profilePic: profilePic,
                email: email,
                gender: gender,
                context: context,
                name: name,
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

  Future<GetProfileModel> getProfileApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.profile, requiresAuth: true);
      //   await SecureStorageService.saveToken(response['token']);
      return GetProfileModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getProfileApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getProfileApi(context: context),
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
