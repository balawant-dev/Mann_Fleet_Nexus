import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../../apiservice/constants/api_constants.dart';
import '../../../apiservice/exceptions/app_exceptions.dart';
import '../../../apiservice/network/api_service.dart';
import '../../../apiservice/network/network_utils.dart';
import '../../../apiservice/services/secure_storage_service.dart';

import '../model/checkMandatoryUpdate.dart';


class PlatformDependenciesRepo {

  final ApiService _api = ApiService();



  Future<PlatformDependenciesModel> getPlatformDependenciesApi({required BuildContext context}) async {
    try {
      final response = await _api.get(ApiConstants.platformDependencies, requiresAuth: false);

      return PlatformDependenciesModel.fromJson(response);

    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => getPlatformDependenciesApi(context: context),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => getPlatformDependenciesApi(context: context),
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
 // Future<CheckMandatoryUpdateModel> checkMandatoryUpdateApi(var data) async {
 //    try {
 //      final response = await _apiService.postApiWithToken(data,AppUrl.checkMandatoryUpdate);
 //      print('resssposssnscee:$response');
 //      return CheckMandatoryUpdateModel.fromJson(response);
 //    } catch (e) {
 //      rethrow;
 //    }
 //  }
}