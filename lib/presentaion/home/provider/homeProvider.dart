import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';

import '../../shuttleModule/shuttleList/model/allUniqueStoppageModel.dart';

import '../model/recent_location.dart';
import '../repo/homeRepo.dart';
import '../ui/model/bannerModel.dart';
import '../ui/model/choosePackageModel.dart';
import '../ui/model/oneWayBookingModel.dart';
import '../ui/model/shuttleShiftStopPageModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomeProvider extends ChangeNotifier {
  /// Controllers
  TextEditingController pickupController = TextEditingController();
  TextEditingController dropController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController returnDateController = TextEditingController();
  TextEditingController returnTimeController = TextEditingController();
  TextEditingController sourceLocationController = TextEditingController();
  TextEditingController destinationLocationController = TextEditingController();
  String selectedApiTime = "";
  String selectedReturnApiTime = "";
  String selectedReturnApiDate = "";
  final api = HomeRepo();

  BannerModel? bannerModel;
  OneWayBookingModel? oneWayBookingModel;
  ShuttleShiftStopPageModel? shuttleShiftStopPageModel;
  AllUniqueStoppageModel? allUniqueStoppageModel;
  ChoosePackageModel? choosePackageModel;
  List<RecentLocationData>? recentLocationModel;
  bool isLoading = false;
  String? pickupPlaceId;
  double? pickupLat;
  double? pickupLng;
  double? pickupLatShuttle;
  double? pickupLngShuttle;
  Map<String, String>? pickupAddressComponents;

  // Drop
  String? dropPlaceId;
  double? dropLat;
  double? dropLng;
  double? dropLatShuttle;
  double? dropLngShuttle;
  Map<String, String>? dropAddressComponents;

  void setPickupFromMap({
    required String address,
    required double lat,
    required double lng,
  }) {
    pickupController.text = address;
    pickupLat = lat;
    pickupLng = lng;
    notifyListeners();
  }

  void setDropFromMap({
    required String address,
    required double lat,
    required double lng,
  }) {
    dropController.text = address;
    dropLat = lat;
    dropLng = lng;
    notifyListeners();
  }

  void setPickupFromPrediction(
    Prediction p, {
    double? lat,
    double? lng,
    Map<String, String>? components,
  }) {
    pickupController.text = p.description ?? '';
    pickupPlaceId = p.placeId;
    pickupLat = lat;
    pickupLng = lng;
    pickupAddressComponents = components;
    notifyListeners();
  }

  void setDropFromPrediction(
    Prediction p, {
    double? lat,
    double? lng,
    Map<String, String>? components,
  }) {
    dropController.text = p.description ?? '';
    dropPlaceId = p.placeId;
    dropLat = lat;
    dropLng = lng;
    dropAddressComponents = components;
    notifyListeners();
  }

  AllUniqueStoppageData? selectedSource;
  AllUniqueStoppageData? selectedDestination;

  void setSource(AllUniqueStoppageData data) {
    selectedSource = data;
    sourceLocationController.text = data.name ?? "";
    pickupLatShuttle = data.lat;
    pickupLngShuttle = data.lng;
    notifyListeners();
  }

  void setDestination(AllUniqueStoppageData data) {
    selectedDestination = data;
    destinationLocationController.text = data.name ?? "";
    dropLatShuttle = data.lat;
    dropLngShuttle = data.lng;
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

  Future<void> getRecentLocations({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getRecentLocations(context: context);
      if (res != null) {
        recentLocationModel = res.data;
        print("Recent Successfully");
      }
    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveFavoriteLocations({
    required BuildContext context,
    required String location,
    required String latitude,
    required String longitude,
    required String addressType,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.saveFavoriteLocations(
        context: context,
        location: location,
        latitude: latitude,
        longitude: longitude,
        addressType: addressType
      );
      if (res != null) {
        print("Recent Location Saved Successfully");
        getRecentLocations(context: context);
        print("Recent Location Saved Successfully Get red");
      }
    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getHourlyPackageApi({required BuildContext context}) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getHourlyPackageApi(context: context);
      choosePackageModel = res;
      if (res != null || res.status == true) {
        print("choosePackageModel Successfully");
      }
    } catch (e) {
      debugPrint("Error in choosePackageModel: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getShuttleShiftStopApi({
    required BuildContext context,
    required String destination,
    required String source,
    required String         date
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getShuttleShiftStopApi(
        context: context,
        destination: destination,
        source: source,
        date: date,
      );
      shuttleShiftStopPageModel = res;
      if (res != null || res.status == true) {
        print("getShuttleShiftStopApi");
      }
    } catch (e) {
      debugPrint("Error in sendOtp: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getStoppageNameApi({
    required BuildContext context,
    required String search,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getStoppageNameApi(
        context: context,
        search: search,
      );
      allUniqueStoppageModel = res;
      if (res != null || res.status == true) {
        print("getShuttleShiftStopApi");
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
        selectedHours: selectedHours, // dynamic kar lena
        tripDays: 1,
      );
      // saveFavoriteLocations(
      //   context: context,
      //   location: dropController.text,
      //   latitude: dropLat.toString(),
      //   longitude: dropLng.toString(),
      //   addressType: "Home"
      // );
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
      initialEntryMode: TimePickerEntryMode.input,
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
      returnTimeController.text = TimeOfDay.fromDateTime(
        selectedDateTime,
      ).format(context);

      /// ✅ API (24-hour)
      selectedReturnApiTime = DateFormat('HH:mm').format(selectedDateTime);

      notifyListeners();
    }
  }

  int? selectedHours;
  String? selectedPackageId; // optional
  void setHours(int hours) {
    selectedHours = hours;
    // selectedPackageId = ... agar chahiye toh
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

  List<String> tabsWay = ["One Way", "Round Trip", "Hourly"];
  // List<String> tabsWay = ["One Way", "Round Trip", "Hourly", "Intercity"];

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
  }

  /// Time Picker
  // Future<void> pickTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     initialEntryMode: TimePickerEntryMode.input,
  //   );
  //
  //   if (picked != null) {
  //     final now = DateTime.now();
  //
  //     // Selected date parse karo (jo tumne date picker se liya hai)
  //     DateTime selectedDate = selectedApiDate.isNotEmpty
  //         ? DateTime.parse(selectedApiDate)
  //         : now;
  //
  //     final selectedDateTime = DateTime(
  //       selectedDate.year,
  //       selectedDate.month,
  //       selectedDate.day,
  //       picked.hour,
  //       picked.minute,
  //     );
  //
  //     /// ❌ Sirf tab block karo jab date aaj ki ho
  //     bool isToday =
  //         selectedDate.year == now.year &&
  //         selectedDate.month == now.month &&
  //         selectedDate.day == now.day;
  //
  //     if (isToday && selectedDateTime.isBefore(now)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select future time")),
  //       );
  //       return;
  //     }
  //
  //     /// ✅ UI
  //     timeController.text = TimeOfDay.fromDateTime(
  //       selectedDateTime,
  //     ).format(context);
  //
  //     /// ✅ API
  //     selectedApiTime = DateFormat('HH:mm').format(selectedDateTime);
  //
  //     notifyListeners();
  //   }
  // }
  Future<void> pickTime1(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();

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

      /// UI → 24 hour
      timeController.text = DateFormat('HH:mm').format(selectedDateTime);

      /// API → 24 hour
      selectedApiTime = DateFormat('HH:mm').format(selectedDateTime);

      notifyListeners();
    }
  }

  Future<void> pickTime(BuildContext context) async {
    int selectedHour = DateTime.now().hour;
    int selectedMinute = DateTime.now().minute;

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final now = DateTime.now();

                        DateTime selectedDate = selectedApiDate.isNotEmpty
                            ? DateTime.parse(selectedApiDate)
                            : now;

                        final selectedDateTime = DateTime(
                          selectedDate.year,
                          selectedDate.month,
                          selectedDate.day,
                          selectedHour,
                          selectedMinute,
                        );

                        bool isToday =
                            selectedDate.year == now.year &&
                            selectedDate.month == now.month &&
                            selectedDate.day == now.day;

                        if (isToday && selectedDateTime.isBefore(now)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select future time"),
                            ),
                          );
                          return;
                        }

                        timeController.text = DateFormat(
                          'HH:mm',
                        ).format(selectedDateTime);

                        selectedApiTime = DateFormat(
                          'HH:mm',
                        ).format(selectedDateTime);

                        notifyListeners();

                        Navigator.pop(context);
                      },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      "HH",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      "MM",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// HH
                        SizedBox(
                          width: 100,
                          height: 120,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            useMagnifier: true,
                            magnification: 1.15,
                            diameterRatio: 20,
                            squeeze: 1,
                            selectionOverlay: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.withOpacity(.15),
                              ),
                            ),
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedHour,
                            ),
                            onSelectedItemChanged: (value) {
                              selectedHour = value;
                            },
                            children: List.generate(
                              24,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// MM
                        SizedBox(
                          width: 100,
                          height: 120,
                          child: CupertinoPicker(
                            itemExtent: 40,
                            useMagnifier: true,
                            magnification: 1.15,
                            diameterRatio: 20,
                            squeeze: 1,

                            selectionOverlay: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey.withOpacity(.15),
                              ),
                            ),
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedMinute,
                            ),
                            onSelectedItemChanged: (value) {
                              selectedMinute = value;
                            },
                            children: List.generate(
                              60,
                              (index) => Center(
                                child: Text(
                                  index.toString().padLeft(2, '0'),
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> setCurrentLocation() async {
    try {
      /// Permission Check
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      /// Current Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      pickupLat = position.latitude;
      pickupLng = position.longitude;

      /// Address Fetch
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String address =
            "${place.name ?? ''}, "
            "${place.locality ?? ''}, "
            "${place.administrativeArea ?? ''}, "
            "${place.country ?? ''}";

        pickupController.text = address;

        pickupAddressComponents = {
          "city": place.locality ?? "",
          "state": place.administrativeArea ?? "",
          "pincode": place.postalCode ?? "",
        };
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Current Location Error: $e");
    }
  }

  void clearPickupLocation() {
    pickupController.clear();
    pickupLat =null;
    pickupLng = null;
    notifyListeners();
  }

  void clearDropLocation() {
    dropController.clear();
    dropLat =null;
    dropLng =null;
    notifyListeners();
  }
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
