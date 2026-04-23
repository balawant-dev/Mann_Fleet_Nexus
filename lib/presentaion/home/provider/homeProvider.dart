import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';

import '../../../widget/navigator_method.dart';
import '../../booking/ui/vehicleSelectionScreen.dart';
import '../../splash/ui/splashScreen.dart';
import '../repo/homeRepo.dart';
import '../ui/model/bannerModel.dart';
import '../ui/model/oneWayBookingModel.dart';

class HomeProvider extends ChangeNotifier {
  /// Controllers
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController returnTimeController = TextEditingController();
  String selectedApiTime = "";
  String selectedReturnApiTime = "";
  String selectedReturnApiDate = "";
  final api = HomeRepo();

  BannerModel? bannerModel;
  OneWayBookingModel? oneWayBookingModel;

  bool isLoading = false;
  String? pickupPlaceId;
  double? pickupLat;
  double? pickupLng;
  Map<String, String>? pickupAddressComponents; // optional: street, city, pin etc.

  // Drop
  String? dropPlaceId;
  double? dropLat;
  double? dropLng;
  Map<String, String>? dropAddressComponents;

  void setPickupFromPrediction(Prediction p, {double? lat, double? lng, Map<String, String>? components}) {
    pickupController.text = p.description ?? '';
    pickupPlaceId = p.placeId;
    pickupLat = lat;
    pickupLng = lng;
    pickupAddressComponents = components;
    notifyListeners();
  }

  void setDropFromPrediction(Prediction p, {double? lat, double? lng, Map<String, String>? components}) {
    dropController.text = p.description ?? '';
    dropPlaceId = p.placeId;
    dropLat = lat;
    dropLng = lng;
    dropAddressComponents = components;
    notifyListeners();
  }
  Future<void> getBannerApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getBannerApi(context: context);
      bannerModel = res;
      if (res != null || res.status == true) {
        print("Banner Successfully");
      }
    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBooking({
    required BuildContext context,
    required String bookingType,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.createBooking(
        context: context,
        bookingType: bookingType,

        pickupAddress: pickupController.text,
        dropoffAddress: dropController.text,

        pickupLat: pickupLat!.toString(),
        pickupLng: pickupLng!.toString(),
        dropLat: dropLat?.toString(),
        dropLng: dropLng?.toString(),

        date: selectedApiDate,
        time: selectedApiTime,
        // time: timeController.text,

        /// 🔥 Extra fields
        returnDate: selectedReturnApiDate, // tum alag bhi rakh sakte ho
        returnTime: selectedReturnApiTime,
        // returnTime: returnTimeController.text,
        selectedHours: 4, // dynamic kar lena
        tripDays: 1,
      );

      oneWayBookingModel = res;

    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<void> pickReturnDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedReturnApiDate = DateFormat('yyyy-MM-dd').format(picked);
      returnDateController.text = DateFormat('dd MMM yyyy').format(picked);
      notifyListeners();
    }
  }
  Future<void> pickReturnTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();

      // ✅ Return date parse karo
      DateTime selectedDate = selectedReturnApiDate.isNotEmpty
          ? DateTime.parse(selectedReturnApiDate)
          : now;

      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      /// ✅ Check karo kya selected date aaj ki hai
      bool isToday =
          selectedDate.year == now.year &&
              selectedDate.month == now.month &&
              selectedDate.day == now.day;

      /// ❌ Sirf aaj ke case me past time block karo
      if (isToday && selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select future time")),
        );
        return;
      }

      /// ✅ UI (12-hour)
      returnTimeController.text =
          TimeOfDay.fromDateTime(selectedDateTime).format(context);

      /// ✅ API (24-hour)
      selectedReturnApiTime =
          DateFormat('HH:mm').format(selectedDateTime);

      notifyListeners();
    }
  }
  // Future<void> pickReturnTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (picked != null) {
  //     final now = DateTime.now();
  //
  //     final selectedDateTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       picked.hour,
  //       picked.minute,
  //     );
  //
  //     /// ❌ Past time block
  //     if (selectedDateTime.isBefore(now)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select future time")),
  //       );
  //       return;
  //     }
  //
  //     /// UI
  //     returnTimeController.text =
  //         TimeOfDay.fromDateTime(selectedDateTime).format(context);
  //
  //     /// API (24-hour)
  //     selectedReturnApiTime = DateFormat('HH:mm').format(selectedDateTime);
  //
  //     notifyListeners();
  //   }
  // }

  int selectedHours = 4;

  void setHours(int hours) {
    selectedHours = hours;
    notifyListeners();
  }
  int tripDays = 1;

  void setTripDays(int days) {
    tripDays = days;
    notifyListeners();
  }
  /// Tab Index
  int selectedIndex = 0;
  int selectedWayIndex = 0;

  bool isSwapped = false;

  List<String> tabs = ["AIRPORT/CITY", "AIRPORT SHUTTLE", "MANN TAJ EXPRESS"];

  List<String> tabsWay = ["One Way", "Round Trip", "Hourly", "Intercity"];

  /// Swap Pickup & Drop
  void swapLocation() {
    isSwapped = !isSwapped;
    notifyListeners();
  }

  /// Change Top Tabs
  void changeTab(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  /// Change Way Tabs
  void changeWayTab(int index) {
    selectedWayIndex = index;
    notifyListeners();
  }
  String selectedApiDate = "";
  /// Date Picker
  Future<void> pickDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      selectedApiDate = DateFormat('yyyy-MM-dd').format(picked); // API
      dateController.text = DateFormat('dd MMM yyyy').format(picked); // UI
      notifyListeners();
    }

    // if (picked != null) {
    //   dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    //   // dateController.text = "${picked.day}/${picked.month}/${picked.year}";
    //   notifyListeners();
    // }
  }

  /// Time Picker
  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();

      // Selected date parse karo (jo tumne date picker se liya hai)
      DateTime selectedDate = selectedApiDate.isNotEmpty
          ? DateTime.parse(selectedApiDate)
          : now;

      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      /// ❌ Sirf tab block karo jab date aaj ki ho
      bool isToday =
          selectedDate.year == now.year &&
              selectedDate.month == now.month &&
              selectedDate.day == now.day;

      if (isToday && selectedDateTime.isBefore(now)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select future time")),
        );
        return;
      }

      /// ✅ UI
      timeController.text =
          TimeOfDay.fromDateTime(selectedDateTime).format(context);

      /// ✅ API
      selectedApiTime = DateFormat('HH:mm').format(selectedDateTime);

      notifyListeners();
    }
  }
  // Future<void> pickTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   );
  //
  //   if (picked != null) {
  //     final now = DateTime.now();
  //
  //     final selectedDateTime = DateTime(
  //       now.year,
  //       now.month,
  //       now.day,
  //       picked.hour,
  //       picked.minute,
  //     );
  //
  //     /// ❌ Past time block
  //     if (selectedDateTime.isBefore(now)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select future time")),
  //       );
  //       return;
  //     }
  //
  //     /// ✅ UI (12-hour)
  //     timeController.text = TimeOfDay.fromDateTime(selectedDateTime).format(context);
  //
  //     /// ✅ API (24-hour)
  //     selectedApiTime = DateFormat('HH:mm').format(selectedDateTime);
  //
  //     notifyListeners();
  //   }
  // }

  void clearAllFields() {
    pickupController.clear();
    dropController.clear();
    dateController.clear();
    timeController.clear();
    //
    pickupLat = null;
    pickupLng = null;
    dropLat = null;
    dropLng = null;

    isSwapped = false;

    // agar koi aur state hai to wo bhi reset karo
    notifyListeners();
  }
}
