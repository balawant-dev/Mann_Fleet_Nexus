import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../apiservice/constants/api_constants.dart';
import '../../../../../apiservice/exceptions/app_exceptions.dart';
import '../../../../../apiservice/network/api_service.dart';
import '../../../../../apiservice/network/network_utils.dart';
import '../../../../../apiservice/services/secure_storage_service.dart';

import '../model/bookingCancelModel.dart';
import '../model/bookingHistoryDetailModel.dart';
import '../model/myBookingHistoryModel.dart';
import '../model/payment_retry_model.dart';
import '../model/ratingModel.dart';

class BookingHistoryRepo {
  final ApiService _api = ApiService();

  Future<MyBookingHistoryModel> myBookingHistoryApi({
    required BuildContext context,
    required int currentPage,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.booking}?page=${currentPage}",

        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return MyBookingHistoryModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () =>
              myBookingHistoryApi(context: context, currentPage: currentPage),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () =>
              myBookingHistoryApi(context: context, currentPage: currentPage),
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

  Future<PaymentRetryModel> retryPaymentApi({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      final response = await _api.post(
        "${ApiConstants.retryPayment}/$bookingId",
        requiresAuth: true,
      );

      return PaymentRetryModel.fromJson(response);
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      throw ApiException(0, e.toString());
    }
  }

  Future<RatingModel> submitRatingApi({
    required BuildContext context,
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    try {
      final response = await _api.post(
        ApiConstants.ratings,
        data: {"bookingId": bookingId, "rating": rating, "comment": comment},
        requiresAuth: true,
      );

      return RatingModel.fromJson(response);
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      }

      rethrow;
    }
  }

  Future<Map<String, dynamic>> generateInvoice({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.generateInvoice}/$bookingId",
        requiresAuth: true,
      );

      return response;
    } on DioException catch (e) {
      if (e.error is UnauthorizedException) {
        await SecureStorageService.logout(context);
        throw UnauthorizedException();
      }

      rethrow;
    }
  }

  Future<BookingHistoryDetailModel> myBookingHistoryDetailApi({
    required BuildContext context,
    required String id,
  }) async {
    final response = await _api.get(
      "${ApiConstants.booking}/${id}",

      requiresAuth: true,
    );
    //   await SecureStorageService.saveToken(response['token']);
    return BookingHistoryDetailModel.fromJson(response);
    try {

      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => myBookingHistoryDetailApi(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => myBookingHistoryDetailApi(context: context, id: id),
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
  }  Future<BookingCancelModel> bookingCancelApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      final response = await _api.get(
        "${ApiConstants.cancelBooking}/${id}",

        requiresAuth: true,
      );
      //   await SecureStorageService.saveToken(response['token']);
      return BookingCancelModel.fromJson(response);
      //  return LoginModel.fromJson(response['user']);
    } on DioException catch (e) {
      if (e.response != null) {
        // ✅ Yeh line important hai - 400 error ke bawajood body parse kar rahe hain
        try {
          return BookingCancelModel.fromJson(e.response!.data);
        } catch (_) {
          rethrow;
        }
      }
      if (e.error is NoInternetException) {
        showNoInternetScreen(
          context,
          onRetry: () => bookingCancelApi(context: context, id: id),
        );
        throw NoInternetException();
      } else if (e.error is ServerException) {
        showServerErrorScreen(
          context,
          onRetry: () => bookingCancelApi(context: context, id: id),
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
