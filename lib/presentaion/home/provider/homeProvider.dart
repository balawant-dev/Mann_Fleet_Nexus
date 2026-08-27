import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/util/color/app_colors.dart';

import '../../../shuttleModule/shuttleList/model/allUniqueStoppageModel.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/motionToastHelper.dart';


import '../model/getNewRecentSearchModel.dart';
import '../model/recent_location.dart';
import '../repo/homeRepo.dart';
import '../ui/model/bannerModel.dart';
import '../ui/model/choosePackageModel.dart';
import '../ui/model/oneWayBookingModel.dart';
import '../ui/model/shuttleShiftStopPageModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../widgets/customMessageDialog.dart';

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

  bool preserveLocationsOnReload = false;

  String _travelType="single";
  String get travelType => _travelType;
  void setTravelType(String type) {
    _travelType = type;
    notifyListeners();
  }


  // ==================== BOTTOM SHEET ====================
  // Widget _locationOption({
  //   required String title,
  //   required IconData icon,
  //   required bool selected,
  //   required VoidCallback onTap,
  // }) {
  //   return InkWell(
  //     onTap: onTap,
  //     borderRadius: BorderRadius.circular(12),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  //       decoration: BoxDecoration(
  //         color: selected ?  ColorResource.primary.withOpacity(0.1) : Colors.black.shade100,
  //         borderRadius: BorderRadius.circular(12),
  //         border: Border.all(
  //           color: selected ?  ColorResource.primary : Colors.black,
  //         ),
  //       ),
  //       child: Row(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(icon, size: 18, color: selected ?  ColorResource.primary: Colors.black),
  //           const SizedBox(width: 8),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               color: selected ? ColorResource.primary : Colors.black,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Future<void> showAddressTypeBottomSheet({
  //   required BuildContext context,
  //   required String location,
  //   required double lat,
  //   required double lng,
  //   required bool isPickup,
  // }) async {
  //   if (!context.mounted) return;
  //   String selectedType = "Home";
  //   final TextEditingController nearAddressController = TextEditingController();
  //   final TextEditingController customTypeController = TextEditingController();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       useRootNavigator: true,           // Important
  //       barrierColor: Colors.black.withOpacity(0.7),
  //       backgroundColor: Colors.transparent,
  //       builder: (BuildContext bottomSheetContext) {
  //         return StatefulBuilder(
  //           builder: (context, setState) {
  //
  //
  //
  //             return Container(
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
  //               ),
  //               child: Padding(
  //                 padding: EdgeInsets.only(
  //                   left: 20,
  //                   right: 20,
  //                   top: 20,
  //                   bottom: MediaQuery.of(context).viewInsets.bottom + 20,
  //                 ),
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Center(
  //                       child: Text("Confirm Location",
  //                           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //                     ),
  //                     const SizedBox(height: 20),
  //
  //                     Container(
  //                       padding: const EdgeInsets.all(12),
  //                       decoration: BoxDecoration(
  //                         color: Colors.black.shade100,
  //                         borderRadius: BorderRadius.circular(12),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           const Icon(Icons.location_on, color: Colors.red),
  //                           const SizedBox(width: 10),
  //                           Expanded(
  //                             child: Text(location, style: const TextStyle(fontSize: 14)),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 20),
  //                     const Text("Near Address (Optional)", style: TextStyle(fontWeight: FontWeight.w600)),
  //                     const SizedBox(height: 8),
  //                     TextField(
  //                       controller: nearAddressController,
  //                       decoration: InputDecoration(
  //                         contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
  //                         hintStyle: TextStyle(color: Colors.black,fontSize: 12),
  //                         hintText: "e.g. Near Metro Station, Opposite Temple",
  //                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 20),
  //                     const Text("Save as", style: TextStyle(fontWeight: FontWeight.w600)),
  //                     const SizedBox(height: 12),
  //
  //                     Wrap(
  //                       spacing: 10,
  //                       runSpacing: 10,
  //                       children: [
  //                         _locationOption(
  //                           title: "Home",
  //                           icon: Icons.home,
  //                           selected: selectedType == "Home",
  //                           onTap: () {
  //                             setState(() {
  //                               selectedType = "Home";
  //                             });
  //                           },
  //                         ),
  //
  //                         _locationOption(
  //                           title: "Work",
  //                           icon: Icons.work,
  //                           selected: selectedType == "Work",
  //                           onTap: () {
  //                             setState(() {
  //                               selectedType = "Work";
  //                             });
  //                           },
  //                         ),
  //
  //                         // _locationOption(
  //                         //   title: "Office",
  //                         //   icon: Icons.business,
  //                         //   selected: selectedType == "Office",
  //                         //   onTap: () {
  //                         //     setState(() {
  //                         //       selectedType = "Office";
  //                         //     });
  //                         //   },
  //                         // ),
  //
  //                         _locationOption(
  //                           title: "Other",
  //                           icon: Icons.edit_location_alt,
  //                           selected: selectedType == "Other",
  //                           onTap: () {
  //                             setState(() {
  //                               selectedType = "Other";
  //                             });
  //                           },
  //                         ),
  //                       ],
  //                     ),
  //
  //                     if (selectedType == "Other") ...[
  //                       const SizedBox(height: 15),
  //
  //                       TextField(
  //                         controller: customTypeController,
  //                         decoration: InputDecoration(
  //                           contentPadding: EdgeInsets.symmetric(horizontal: 12,vertical: 3),
  //                           hintStyle: TextStyle(color: Colors.black,fontSize: 12),
  //                           hintText: "Enter custom name",
  //
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(12),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //
  //                     // Wrap(
  //                     //   spacing: 10,
  //                     //   runSpacing: 10,
  //                     //   children: ["Home", "Work", "Other"].map((type) {
  //                     //     bool isSelected = selectedType == type;
  //                     //     return GestureDetector(
  //                     //       onTap: () {
  //                     //         setState(() => selectedType = type);   // ← Fixed
  //                     //       },
  //                     //       child: Chip(
  //                     //         label: Text(type),
  //                     //         backgroundColor: isSelected ? Colors.blue.shade50 : Colors.black.shade100,
  //                     //         side: BorderSide(
  //                     //           color: isSelected ? Colors.blue : Colors.black,
  //                     //           width: isSelected ? 1.5 : 1,
  //                     //         ),
  //                     //       ),
  //                     //     );
  //                     //   }).toList(),
  //                     // ),
  //                     //
  //                     // if (selectedType == "Other") ...[
  //                     //   const SizedBox(height: 15),
  //                     //   TextField(
  //                     //     controller: customTypeController,
  //                     //     decoration: InputDecoration(
  //                     //       hintText: "Enter custom type",
  //                     //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //                     //     ),
  //                     //   ),
  //                     // ],
  //
  //                     const SizedBox(height: 30),
  //                     CustomButton(
  //                       title: "Confirm Location",
  //                       onTap: () {
  //                         final addressType = selectedType == "Other"
  //                             ? customTypeController.text.trim()
  //                             : selectedType;
  //
  //                         final nearAddr = nearAddressController.text.trim();
  //
  //                         if (isPickup) {
  //                           pickupController.text = location;
  //                           pickupLat = lat;
  //                           pickupLng = lng;
  //                         } else {
  //                           dropController.text = location;
  //                           dropLat = lat;
  //                           dropLng = lng;
  //                         }
  //
  //                         api.postRecentSearchHistoryNew(
  //                           nearAddress: nearAddr.isEmpty ? "" : nearAddr,
  //                           addressType: addressType,
  //                           location: location,
  //                           latitude: lat.toString(),
  //                           longitude: lng.toString(),
  //                           context: context,
  //                         );
  //
  //                         Navigator.pop(context);
  //                         notifyListeners();
  //                       },
  //                     ),
  //
  //                     // SizedBox(
  //                     //   width: double.infinity,
  //                     //   height: 52,
  //                     //   child: ElevatedButton(
  //                     //     style: ElevatedButton.styleFrom(
  //                     //       backgroundColor: Colors.blue,
  //                     //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                     //     ),
  //                     //     onPressed: () {
  //                     //       final addressType = selectedType == "Other"
  //                     //           ? customTypeController.text.trim()
  //                     //           : selectedType;
  //                     //
  //                     //       final nearAddr = nearAddressController.text.trim();
  //                     //
  //                     //       if (isPickup) {
  //                     //         pickupController.text = location;
  //                     //         pickupLat = lat;
  //                     //         pickupLng = lng;
  //                     //       } else {
  //                     //         dropController.text = location;
  //                     //         dropLat = lat;
  //                     //         dropLng = lng;
  //                     //       }
  //                     //
  //                     //       api.postRecentSearchHistoryNew(
  //                     //         nearAddress: nearAddr.isEmpty ? "" : nearAddr,
  //                     //         addressType: addressType,
  //                     //         location: location,
  //                     //         latitude: lat.toString(),
  //                     //         longitude: lng.toString(),
  //                     //         context: context,
  //                     //       );
  //                     //
  //                     //       Navigator.pop(context);
  //                     //       notifyListeners();
  //                     //     },
  //                     //     child: const Text("Confirm Location", style: TextStyle(fontSize: 16)),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     );
  //   });
  // }

  // Add this method
  void applyIntercitySuggestion() {
    selectedIndex = 0;        // Airport/City main tab
    selectedWayIndex = 1;     // Intercity sub-tab
    preserveLocationsOnReload = true;
    notifyListeners();
  }

  void setDropLocationFromDeepLink({
    required String address,
    required double lat,
    required double lng,
  }) {
    print("🔥 setDropLocationFromDeepLink called successfully No");
    print("🔥 dropLat:$lat");
    print("🔥 dropLng:$lng");
    print("🔥 address:$address");
    dropController.text = address;
    dropLat = lat;
    dropLng = lng;

    // Extra force notify + clear any previous state
    dropPlaceId = null;
    dropAddressComponents = null;

    notifyListeners();

    // Important: Home screen ko refresh karne ke liye
    preserveLocationsOnReload = true;
    print("🔥 dropLatApi:$dropLat");
    print("🔥 dropLngApi:$dropLng");
    print("🔥 setDropLocationFromDeepLink called successfully Yes");
  }

  // void setDropLocationFromDeepLink({
  //   required String address,
  //   required double lat,
  //   required double lng,
  // }) {
  //   dropController.text = address;
  //   dropLat = lat;
  //   dropLng = lng;
  //
  //   notifyListeners();
  // }

  void setPickupFromMap({
    required String address,
    required double lat,
    required double lng,
    required BuildContext context,
  }) {
    print("PICKUP SAVING");
    print(lat);
    print(lng);

    // showAddressTypeBottomSheet(
    //   context: context,
    //   location: address,
    //   lat: lat,
    //   lng: lng,
    //   isPickup: true,
    // );

    pickupController.text = address;
    pickupLat = lat;
    pickupLng = lng;

    print("AFTER SAVE");
    print(pickupLat);
    print(pickupLng);
    api.postRecentSearchHistoryNew(location:address ,latitude: lat.toString(),longitude:lng.toString(), context: context);

    notifyListeners();
  }

  void setDropFromMap({
    required String address,
    required double lat,
    required double lng,
    required BuildContext context,
  }) {
    print("DROP SAVING");
    print(lat);
    print(lng);

    // showAddressTypeBottomSheet(
    //   context: context,
    //   location: address,
    //   lat: lat,
    //   lng: lng,
    //   isPickup: false,
    // );

    dropController.text = address;
    dropLat = lat;
    dropLng = lng;

    print("AFTER SAVE");
    print(dropLat);
    print(dropLng);
   // api.postRecentSearchHistoryNew(location:address ,latitude: lat.toString(),longitude:lng.toString(), context: context);

    notifyListeners();
  }
  void setPickupFromMapRecent({
    required String address,
    required double lat,
    required double lng,
    required BuildContext context,
  }) {
    print("PICKUP SAVING");
    print(lat);
    print(lng);

    // showAddressTypeBottomSheet(
    //   context: context,
    //   location: address,
    //   lat: lat,
    //   lng: lng,
    //   isPickup: true,
    // );

    pickupController.text = address;
    pickupLat = lat;
    pickupLng = lng;

    print("AFTER SAVE");
    print(pickupLat);
    print(pickupLng);
    //api.postRecentSearchHistoryNew(location:address ,latitude: lat.toString(),longitude:lng.toString(), context: context);

    notifyListeners();
  }
  void setDropFromMapRecent({
    required String address,
    required double lat,
    required double lng,
    required BuildContext context,
  }) {
    print("DROP SAVING");
    print(lat);
    print(lng);

    // showAddressTypeBottomSheet(
    //   context: context,
    //   location: address,
    //   lat: lat,
    //   lng: lng,
    //   isPickup: false,
    // );

    dropController.text = address;
    dropLat = lat;
    dropLng = lng;

    print("AFTER SAVE");
    print(dropLat);
    print(dropLng);
   // api.postRecentSearchHistoryNew(location:address ,latitude: lat.toString(),longitude:lng.toString(), context: context);

    notifyListeners();
  }



  void setPickupFromPrediction(
    Prediction p, {
    double? lat,
    double? lng,
    Map<String, String>? components,
        required BuildContext context,
  }) async{
    pickupController.text = p.description ?? '';
    pickupPlaceId = p.placeId;
    pickupLat = lat;
    pickupLng = lng;
    pickupAddressComponents = components;
    // 🔥 API Call
    if (lat != null && lng != null) {
      // await showAddressTypeBottomSheet(
      // context: context,
      // location: p.description ?? '',
      // lat: lat,
      // lng: lng,
      // isPickup: true,
      // );
      api.postRecentSearchHistoryNew(
        location: p.description ?? '',
        latitude: lat.toString(),
        longitude: lng.toString(),
        context: context,
      );
    }
    notifyListeners();
  }

  void setDropFromPrediction(
    Prediction p, {
    double? lat,
    double? lng,
    Map<String, String>? components,
        required BuildContext context,
  }) async{
    dropController.text = p.description ?? '';
    dropPlaceId = p.placeId;
    dropLat = lat;
    dropLng = lng;
    dropAddressComponents = components;
    // 🔥 API Call
    if (lat != null && lng != null) {
      // await showAddressTypeBottomSheet(
      // context: context,
      // location: p.description ?? '',
      // lat: lat,
      // lng: lng,
      // isPickup: false,
      // );
      api.postRecentSearchHistoryNew(
        location: p.description ?? '',
        latitude: lat.toString(),
        longitude: lng.toString(),
        context: context,
      );
    }
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
  // GetNewRecentSearchModel? getNewRecentSearchModel;
  // Future<void> getRecentLocationsNew({required BuildContext context}) async {
  //   try {
  //     isLoading = true;
  //     notifyListeners();
  //
  //     final res = await api.getRecentSearchHistoryNew(context: context);
  //     if (res != null) {
  //       getNewRecentSearchModel = res;
  //       print("getNewRecentSearchModel Successfully");
  //     }
  //   } catch (e) {
  //     debugPrint("Error in sendOtp: $e");
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

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
  }  Future<void> removeFavoriteLocations({
    required BuildContext context,
    required String id,

  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.removeFavoriteLocations(
        context: context,
        id: id,

      );
      if (res != null) {
        print("Recent Location Remove Successfully");
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
    required String         date,
    required String         travelType
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final res = await api.getShuttleShiftStopApi(
        context: context,
        destination: destination,
        source: source,
        date: date,
        travelType: travelType
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
bool showPop=false;
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
      notifyListeners();
      if(res.status==true){
        showPop=false;
        notifyListeners();
      }else{
        showPop=true;
        notifyListeners();

      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      isLoading = false;
      showPop=false;
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
    // Default to current time or previously selected return time
    int selectedReturnHour = DateTime.now().hour;
    int selectedReturnMinute = DateTime.now().minute;

    // If return time is already selected, use it as initial value
    if (selectedReturnApiTime.isNotEmpty) {
      final parts = selectedReturnApiTime.split(':');
      if (parts.length == 2) {
        selectedReturnHour = int.tryParse(parts[0]) ?? DateTime.now().hour;
        selectedReturnMinute = int.tryParse(parts[1]) ?? DateTime.now().minute;
      }
    }

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

                        // Parse return date
                        DateTime selectedReturnDate = selectedReturnApiDate.isNotEmpty
                            ? DateTime.parse(selectedReturnApiDate)
                            : now;

                        final selectedReturnDateTime = DateTime(
                          selectedReturnDate.year,
                          selectedReturnDate.month,
                          selectedReturnDate.day,
                          selectedReturnHour,
                          selectedReturnMinute,
                        );

                        // === 1. Today check (minimum 3 minutes from now) ===
                        bool isTodayReturn = selectedReturnDate.year == now.year &&
                            selectedReturnDate.month == now.month &&
                            selectedReturnDate.day == now.day;

                        final minAllowedTime = now.add(const Duration(minutes: 3));

                        if (isTodayReturn && selectedReturnDateTime.isBefore(minAllowedTime)) {
                          // ToastHelper.show(
                          //   context,
                          //   message: "Please select a time at least 3 minutes from now",
                          //   type: ToastType.warning,
                          // );
                          CustomMessageDialog.show(
                            context: context,
                            title: "Warning",
                            message: "Please select a time at least 2 minutes from now",
                            type: MessageType.warning,
                          );
                          return;
                        }

                        // === 2. Return time must be AFTER Pickup time ===
                        if (selectedApiDate.isNotEmpty && selectedApiTime.isNotEmpty) {
                          DateTime pickupDateTime;
                          try {
                            final pickupDate = DateTime.parse(selectedApiDate);
                            final timeParts = selectedApiTime.split(':');
                            pickupDateTime = DateTime(
                              pickupDate.year,
                              pickupDate.month,
                              pickupDate.day,
                              int.parse(timeParts[0]),
                              int.parse(timeParts[1]),
                            );

                            if (selectedReturnDateTime.isBefore(pickupDateTime)) {
                              ToastHelper.show(
                                context,
                                message: "Return time must be after pickup time",
                                type: ToastType.warning,
                              );
                              return;
                            }
                          } catch (e) {
                            // If parsing fails, skip this check
                          }
                        }

                        // === Save values ===
                        returnTimeController.text =
                            DateFormat('HH:mm').format(selectedReturnDateTime);

                        selectedReturnApiTime =
                            DateFormat('HH:mm').format(selectedReturnDateTime);

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
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      "MM",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
                        // HH Picker
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
                                color: Colors.black.withOpacity(.15),
                              ),
                            ),
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedReturnHour,
                            ),
                            onSelectedItemChanged: (value) {
                              selectedReturnHour = value;
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

                        // MM Picker
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
                                color: Colors.black.withOpacity(.15),
                              ),
                            ),
                            scrollController: FixedExtentScrollController(
                              initialItem: selectedReturnMinute,
                            ),
                            onSelectedItemChanged: (value) {
                              selectedReturnMinute = value;
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

  // Future<void> pickReturnTime(BuildContext context) async {
  //   TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //     initialEntryMode: TimePickerEntryMode.input,
  //   );
  //
  //   if (picked != null) {
  //     final now = DateTime.now();
  //
  //     // ✅ Return date parse karo
  //     DateTime selectedDate = selectedReturnApiDate.isNotEmpty
  //         ? DateTime.parse(selectedReturnApiDate)
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
  //     /// ✅ Check karo kya selected date aaj ki hai
  //     bool isToday =
  //         selectedDate.year == now.year &&
  //         selectedDate.month == now.month &&
  //         selectedDate.day == now.day;
  //
  //     /// ❌ Sirf aaj ke case me past time block karo
  //     if (isToday && selectedDateTime.isBefore(now)) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Please select future time")),
  //       );
  //       return;
  //     }
  //
  //     /// ✅ UI (12-hour)
  //     returnTimeController.text = TimeOfDay.fromDateTime(
  //       selectedDateTime,
  //     ).format(context);
  //
  //     /// ✅ API (24-hour)
  //     selectedReturnApiTime = DateFormat('HH:mm').format(selectedDateTime);
  //
  //     notifyListeners();
  //   }
  // }

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

  List<String> tabs = ["AIRPORT/CITY", "AIRPORT SHUTTLE"];
  // List<String> tabs = ["AIRPORT/CITY", "AIRPORT SHUTTLE", "MANN TAJ EXPRESS"];
  // In HomeProvider class
  List tabsWay = ["One Way", "Intercity", "Round Trip", "Hourly"];

  // List<String> tabsWay = ["One Way", "Round Trip", "Hourly"];
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
      backgroundColor: ColorResource.white,
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

                        // Current time + 5 minutes
                        final minAllowedTime = now.add(const Duration(minutes: 2));

                        if (isToday && selectedDateTime.isBefore(minAllowedTime)) {
                          // ToastHelper.show(
                          //   context,
                          //   message:      "Please select a time at least 2 minutes from now",
                          //   type: ToastType.warning,
                          // );

                          CustomMessageDialog.show(
                            context: context,
                            title: "Warning",
                            message: "Please select a time at least 2 minutes from now",
                            type: MessageType.warning,
                          );

                          return;
                        }

                        timeController.text =
                            DateFormat('HH:mm').format(selectedDateTime);

                        selectedApiTime =
                            DateFormat('HH:mm').format(selectedDateTime);

                        notifyListeners();

                        Navigator.pop(context);
                      },
                      // onPressed: () {
                      //   final now = DateTime.now();
                      //
                      //   DateTime selectedDate = selectedApiDate.isNotEmpty
                      //       ? DateTime.parse(selectedApiDate)
                      //       : now;
                      //
                      //   final selectedDateTime = DateTime(
                      //     selectedDate.year,
                      //     selectedDate.month,
                      //     selectedDate.day,
                      //     selectedHour,
                      //     selectedMinute,
                      //   );
                      //
                      //   bool isToday =
                      //       selectedDate.year == now.year &&
                      //       selectedDate.month == now.month &&
                      //       selectedDate.day == now.day;
                      //
                      //   if (isToday && selectedDateTime.isBefore(now)) {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //         content: Text("Please select future time"),
                      //       ),
                      //     );
                      //     return;
                      //   }
                      //
                      //   timeController.text = DateFormat(
                      //     'HH:mm',
                      //   ).format(selectedDateTime);
                      //
                      //   selectedApiTime = DateFormat(
                      //     'HH:mm',
                      //   ).format(selectedDateTime);
                      //
                      //   notifyListeners();
                      //
                      //   Navigator.pop(context);
                      // },
                      child: const Text("Done"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:  [
                    Text(
                      "HH",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:  Colors.black,
                      ),
                    ),
                    SizedBox(width: 80),
                    Text(
                      "MM",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:  Colors.black,
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
                                color: Colors.black.withOpacity(.15),
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
                                  style:  TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color:  Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                         Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            ":",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color:  Colors.black,
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
                                color: Colors.black.withOpacity(.15),
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
                                  style:  TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w600,
                                    color:  Colors.black,
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
    if (preserveLocationsOnReload) {
      preserveLocationsOnReload = false;
      notifyListeners();
      return; // Do NOT clear locations
    }
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
