import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mannfleet/widget/motionToastHelper.dart';
import 'package:mannfleet/widget/navigator_method.dart';

import '../../../widget/showLoaderFunction.dart';
import '../model/bookingCancelModel.dart';
import '../model/bookingHistoryDetailModel.dart';
import '../model/myBookingHistoryModel.dart';
import '../model/payment_retry_model.dart';
import '../model/ratingModel.dart';
import '../repo/bookingHistoryRepo.dart';

class BookingHistoryProvider extends ChangeNotifier {
  final api = BookingHistoryRepo();
  List<BookingHistoryData> bookingList = [];

  MyBookingHistoryModel? myBookingHistoryModel;
  BookingHistoryDetailModel? bookingHistoryDetailModel;
  BookingCancelModel? bookingCancelModel;

  bool isLoading = false;

  bool isRefreshing = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  bool hasMore = true;

  bool isSubmittingRating = false;

  RatingModel? ratingModel;

  PaymentRetryModel? paymentRetryModel;
  bool isRetryingPayment = false;

  void resetPagination() {
    currentPage = 1;
    bookingList.clear();

    myBookingHistoryModel = null;
    bookingHistoryDetailModel = null;
    ratingModel = null;

    hasMore = true;

    isLoading = false;
    isRefreshing = false;
    isLoadingMore = false;
    isSubmittingRating = false;

    notifyListeners();
  }

  Future<bool> retryPayment({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      isRetryingPayment = true;
      notifyListeners();

      final res = await api.retryPaymentApi(
        context: context,
        bookingId: bookingId,
      );

      paymentRetryModel = res;

      return res.status == true;
    } catch (e) {
      return false;
    } finally {
      isRetryingPayment = false;
      notifyListeners();
    }
  }

  // Future<void> myBookingHistoryApi({
  //   required BuildContext context,
  //   bool isRefresh = false,
  // }) async {
  //   try {
  //     if (isRefresh) {
  //       isRefreshing = true;
  //       resetPagination();
  //     } else if (currentPage == 1) {
  //       isLoading = true;
  //     } else {
  //       isLoadingMore = true;
  //     }
  //     notifyListeners();
  //
  //     final res = await api.myBookingHistoryApi(
  //       context: context,
  //       currentPage: currentPage,
  //     );
  //     myBookingHistoryModel = res;
  //     if (res != null || res.status == true) {
  //       bookingList.addAll(res.data!);
  //       hasMore = res.data!.length >= 10;
  //       if (hasMore) currentPage++;
  //
  //       print("myBookingHistoryApi Create Successfully");
  //     }
  //   } catch (e) {
  //     debugPrint("Error in oneWayBooking: $e");
  //   } finally {
  //     isLoading = false;
  //     isLoadingMore = false;
  //     isRefreshing = false;
  //     notifyListeners();
  //   }
  // }
  Future<void> myBookingHistoryApi({
    required BuildContext context,
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        isRefreshing = true;
        resetPagination();
      } else if (currentPage == 1) {
        isLoading = true;
      } else {
        isLoadingMore = true;
      }

      notifyListeners();

      final res = await api.myBookingHistoryApi(
        context: context,
        currentPage: currentPage,
      );

      myBookingHistoryModel = res;

      /// FIXED
      if (res.status == true && res.data != null) {
        /// first page
        if (currentPage == 1) {
          bookingList = List.from(res.data!);
        }
        /// pagination
        else {
          bookingList.addAll(res.data!);
        }

        hasMore = res.data!.length >= 10;

        if (hasMore) {
          currentPage++;
        }

        debugPrint("Bookings Loaded: ${bookingList.length}");
      }
    } catch (e) {
      debugPrint("Booking Error: $e");
    } finally {
      isLoading = false;
      isLoadingMore = false;
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> myBookingHistoryDetailApi({
    required BuildContext context,
    required String id,
    bool isRefresh = false,
  }) async {
    try {
      if (isRefresh) {
        isRefreshing = true;
      } else {
        isLoading = true;
      }
      notifyListeners();

      final res = await api.myBookingHistoryDetailApi(context: context, id: id);
      bookingHistoryDetailModel = res;
      if (res != null || res.status == true) {
        print("myBookingHistoryApi Detail Successfully");
      }
    } catch (e) {
      debugPrint("Error in oneWayBooking: $e");
    } finally {
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }  Future<bool> bookingCancelApi({
    required BuildContext context,
    required String id,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.bookingCancelApi(
        context: context,
        id: id,
      );

      bookingCancelModel = res;

      if (res.status == true) {
        await myBookingHistoryApi(
          context: context,
          isRefresh: true,
        );
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Error in bookingCancelApi: $e");
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<bool> submitRating({
    required BuildContext context,
    required String bookingId,
    required double rating,
    required String comment,
  }) async {
    try {
      isSubmittingRating = true;
      notifyListeners();

      final res = await api.submitRatingApi(
        context: context,
        bookingId: bookingId,
        rating: rating,
        comment: comment,
      );

      ratingModel = res;

      return res.status == true;
    } catch (e) {
      return false;
    } finally {
      isSubmittingRating = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> generateInvoice({
    required BuildContext context,
    required String bookingId,
  }) async {
    try {
      isSubmittingRating = true;
      notifyListeners();

      final res = await api.generateInvoice(
        context: context,
        bookingId: bookingId,
      );

      return res;
    } catch (e) {
      return null;
    } finally {
      isSubmittingRating = false;
      notifyListeners();
    }
  }
}
