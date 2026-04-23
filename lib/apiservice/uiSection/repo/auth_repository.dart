// Updated Repositories - WORKING WITH DIO 5.x

import 'dart:io';
import 'package:dio/dio.dart';  // <-- Yeh import add karna zaroori hai!
import 'package:flutter/material.dart';

import '../../constants/api_constants.dart';
import '../../exceptions/app_exceptions.dart';
import '../../network/api_service.dart';
import '../../network/network_utils.dart';
import '../../services/secure_storage_service.dart';
import '../models/user_model.dart';  // Adjust paths as per your structure

// 1. Auth Repository
class AuthRepository {
  final ApiService _api = ApiService();

  Future<UserModel> login(String email, String password, BuildContext context) async {
    try {
      final response = await _api.post(
        "ApiConstants.sendOtp",
        data: {'email': email, 'password': password},
        requiresAuth: false,
      );
      await SecureStorageService.saveToken(response['token']);
      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => login(email, password, context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => login(email, password, context));
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

  Future<UserModel> register(Map<String, dynamic> data, BuildContext context) async {
    try {
      final response = await _api.post(
        "ApiConstants.registerEndpoint",
        data: data,
        requiresAuth: false,
      );
      await SecureStorageService.saveToken(response['token']);
      return UserModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => register(data, context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => register(data, context));
        throw ServerException();
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }
}

// 2. Profile Repository
class ProfileRepository {
  final ApiService _api = ApiService();

  Future<ProfileModel> getProfile(BuildContext context) async {
    try {
      final response = await _api.get("ApiConstants.profileEndpoint");
      return ProfileModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => getProfile(context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => getProfile(context));
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

// 3. Dashboard Repository
class DashboardRepository {
  final ApiService _api = ApiService();

  Future<DashboardModel> getDashboard({String? filter, required BuildContext context}) async {
    try {
      final response = await _api.get(
        ApiConstants.dashboardEndpoint,
        queryParameters: filter != null ? {'filter': filter} : null,
      );
      return DashboardModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => getDashboard(filter: filter, context: context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => getDashboard(filter: filter, context: context));
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

// 4. Settings Repository
class SettingsRepository {
  final ApiService _api = ApiService();

  Future<SettingsModel> updateSettings(Map<String, dynamic> data, BuildContext context) async {
    try {
      final response = await _api.put(ApiConstants.settingsEndpoint, data: data);
      return SettingsModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => updateSettings(data, context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => updateSettings(data, context));
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

// 5. Upload Repository
class UploadRepository {
  final ApiService _api = ApiService();

  Future<UploadResponseModel> uploadFiles(
      List<File> files, Map<String, dynamic>? fields, BuildContext context) async {
    try {
      final response = await _api.uploadFiles(
        ApiConstants.uploadEndpoint,
        files: files,
        fields: fields,
      );
      return UploadResponseModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(context, onRetry: () => uploadFiles(files, fields, context));
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(context, onRetry: () => uploadFiles(files, fields, context));
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