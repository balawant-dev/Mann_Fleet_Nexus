import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';
import '../model/GetComplaintsDetailModel.dart';
import '../model/createComplaintsModel.dart';
import '../model/getComplaintsModel.dart';

class ComplaintsRepo {
  final ApiService _api = ApiService();

  Future<CreateComplaintsModel> createComplaintsApi({
    required BuildContext context,
    required String issueCategory,
    required String description,
    required List<String> imageFiles,
    required String videoFiles,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'issueCategory': issueCategory,
        "description": description,
      });

      // ✅ MULTIPLE IMAGES
      for (var path in imageFiles) {
        formData.files.add(MapEntry(
          "imageFiles",
          await MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }

      // ✅ SINGLE VIDEO
      if (videoFiles.isNotEmpty) {
        formData.files.add(MapEntry(
          "videoFiles",
          await MultipartFile.fromFile(videoFiles, filename: videoFiles.split('/').last),
        ));
      }

      final response = await _api.postMultipart(
        ApiConstants.complaints,
        requiresAuth: true,
        data: formData,
      );

      return CreateComplaintsModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<GetComplaintsModel> getComplaintsApi({
    required BuildContext context,
  }) async {
    try {
      final response = await _api.get(
        ApiConstants.myComplaints,
        requiresAuth: true,
      );

      return GetComplaintsModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getComplaintsApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getComplaintsApi(context: context),
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

  Future<GetComplaintsDetailModel> getComplaintsDetailApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.complaints}/${id}",
        requiresAuth: true,
      );

      return GetComplaintsDetailModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getComplaintsApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getComplaintsApi(context: context),
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
