import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';


import '../model/bookingHistoryDetailModel.dart';
import '../model/myBookingHistoryModel.dart';
import '../repo/bookingHistoryRepo.dart';
// import '../repo/bookingHistoryRepo.dart';


class BookingHistoryProvider extends ChangeNotifier {


  final api = BookingHistoryRepo();
  List<BookingHistoryData>bookingList=[];


  MyBookingHistoryModel? myBookingHistoryModel;
  BookingHistoryDetailModel? bookingHistoryDetailModel;


  bool isLoading = false;


  bool isRefreshing = false;
  bool isLoadingMore=false;
int currentPage=1;
bool hasMore=true;
void resetPagination(){
  currentPage=1;
  bookingList.clear();
  hasMore=true;
  notifyListeners();

}





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
        currentPage: currentPage//is section ko dynamic karo ok pagenation lag k acche se work kare ok





      );
      myBookingHistoryModel = res;
      if (res != null || res.status == true) {
        bookingList.addAll(res.data!);
        hasMore = res.data!.length >= 10;
        if (hasMore) currentPage++;

        print("myBookingHistoryApi Create Successfully");
      }
    } catch (e) {
      debugPrint("Error in oneWayBooking: $e");
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


      final res = await api.myBookingHistoryDetailApi(
        context: context,
        id: id





      );
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
  }




}
