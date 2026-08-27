import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../apiservice/services/appConfigService.dart';
import '../../provider/homeProvider.dart';
import '../location_selection_screen.dart';
import '../mapPickerScreen.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../apiservice/services/appConfigService.dart';
import '../../provider/homeProvider.dart';
import '../location_selection_screen.dart';
import '../mapPickerScreen.dart';

class LocationField extends StatefulWidget {
  final String label;
  final String? iconPath;
  final double? width;
  final double? height;
  final TextEditingController controller;
  final bool isPickup;
  final VoidCallback? onFocus;

  const LocationField({
    super.key,
    required this.label,
    this.iconPath,
    required this.controller,
    this.onFocus,
    this.isPickup = true,
    this.height = 18.0,
    this.width = 18.0,
  });

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  String? googleKey;
  final FocusNode _focusNode = FocusNode();
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    loadKey();
    _focusNode.addListener(_handleFocus);
  }

  Future<void> loadKey() async {
    if (!mounted) return;
    final key = await AppConfigService.getGoogleKey();
    if (!mounted) return;
    setState(() {
      googleKey = key;
    });
  }

  Future<void> _handleFocus() async {
    if (!mounted) return;

    if (_focusNode.hasFocus) {
      widget.onFocus?.call();
      isFocused = true;
      setState(() {});

      final provider = Provider.of<HomeProvider>(context, listen: false);
      if (provider.recentLocationModel == null) {
        await provider.getRecentLocations(context: context);
      }
      if (mounted) setState(() {});
    } else {
      isFocused = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocus);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final recentList = provider.recentLocationModel ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.7)
            // color: Color(0xff94A3B8),
          ),
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: () async {
            widget.onFocus?.call();
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LocationSelectionScreen(
                  isPickup: widget.isPickup,
                  initialAddress: widget.controller.text,
                ),
              ),
            );
            if (result != null && mounted) {
              setState(() {});
            }
          },
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.7)),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                if (widget.iconPath != null) ...[
                  Image.asset(widget.iconPath!, height: widget.height, width: widget.width),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    widget.controller.text.isEmpty ? "Search location" : widget.controller.text,
                    style:  TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.7)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),

        // Recent Search List
        if (isFocused && widget.controller.text.isEmpty && recentList.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10),
              ],
            ),
            child: Column(
              children: List.generate(recentList.length, (index) {
                final item = recentList[index];
                return locationTile(
                  icon: Icons.history,
                  favoriteIcon: item.source == "recent_search" ? Icons.favorite : Icons.favorite_border,
                  isRed: item.source == "recent_search",
                  title: item.address ?? '',
                  showDivider: index != recentList.length - 1,
                  onTapSaved: () {
                    // save logic
                  },
                  onTap: () {
                    widget.controller.text = item.address ?? '';
                    isFocused = false;
                    FocusScope.of(context).unfocus();
                    if (mounted) setState(() {});

                    if (widget.isPickup) {
                      provider.setPickupFromMap(
                        address: item.address ?? '',
                        lat: item.lat ?? 0.0,
                        lng: item.lng ?? 0.0,
                          context: context
                      );
                    } else {
                      provider.setDropFromMap(
                        address: item.address ?? '',
                        lat: item.lat ?? 0.0,
                        lng: item.lng ?? 0.0,
                        context: context

                      );
                    }
                  },
                );
              }),
            ),
          ),
      ],
    );
  }

  // locationTile widget same rakho (ya thoda clean karke)
  Widget locationTile({
    required IconData icon,
    IconData? favoriteIcon,
    required String title,
    VoidCallback? onTap,
    VoidCallback? onTapSaved,
    bool showDivider = true,
    bool isRed = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                Icon(icon, color: Colors.blueGrey, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 12, color: Colors.black, fontWeight: FontWeight.w500),
                  ),
                ),
                if (favoriteIcon != null)
                  InkWell(
                    onTap: onTapSaved,
                    child: Icon(favoriteIcon, color: isRed ? Colors.red : Colors.blueGrey, size: 20),
                  ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1, color: Color(0xffE2E8F0)),
      ],
    );
  }
}

// class LocationField extends StatefulWidget {
//   final String label;
//   final String? iconPath;
//   final double? width;
//   final double? height;
//   final TextEditingController controller;
//   final bool isPickup;
//   final VoidCallback? onFocus;
//
//   const LocationField({
//     super.key,
//     required this.label,
//     this.iconPath,
//     required this.controller,
//     this.onFocus,
//     this.isPickup = true,
//     this.height = 18.0,
//     this.width = 18.0,
//   });
//
//   @override
//   State<LocationField> createState() => _LocationFieldState();
// }
//
// class _LocationFieldState extends State<LocationField> {
//   String? googleKey;
//
//   final FocusNode _focusNode = FocusNode();
//
//   bool isFocused = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     loadKey();
//     _focusNode.addListener(_handleFocus);
//   }
//
//   Future<void> _handleFocus() async {
//     if (!mounted) return;
//
//     if (_focusNode.hasFocus) {
//       widget.onFocus?.call(); // 👈 ye missing hai
//
//       isFocused = true;
//
//       setState(() {});
//
//       final provider = Provider.of<HomeProvider>(context, listen: false);
//       if(provider.recentLocationModel == null){
//         await provider.getRecentLocations(context: context);
//       }
//
//       // await provider.getRecentLocations(context: context);
//
//       if (mounted) {
//         setState(() {});
//       }
//     } else {
//       isFocused = false;
//
//       if (mounted) {
//         setState(() {});
//       }
//     }
//   }
//
//
//   Future<void> loadKey() async {
//     final key = await AppConfigService.getGoogleKey();
//
//     setState(() {
//       googleKey = key;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<HomeProvider>(context);
//
//     final recentList = provider.recentLocationModel ?? [];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.label,
//           style: const TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//             // color: Colors.red,
//             color: Color(0xff94A3B8),
//           ),
//         ),
//
//         const SizedBox(height: 2),
//         GestureDetector(
//           onTap: () async {
//             print("Click here");
//             widget.onFocus?.call();
//
//             final result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => LocationSelectionScreen(
//                   isPickup: widget.isPickup,
//                   initialAddress: widget.controller.text,
//                 ),
//               ),
//             );
//
//             if (result != null) {
//               // Optional: handle any result if needed
//               setState(() {});
//             }
//           },
//           // child: SizedBox(
//           //   height: 45,
//           //   child: GooglePlaceAutoCompleteTextField(
//           //
//           //     focusNode: _focusNode,
//           //     textEditingController: widget.controller,
//           //
//           //     googleAPIKey: googleKey ?? "",
//           //
//           //     debounceTime: 300,
//           //
//           //     countries: const ['in'],
//           //
//           //     isLatLngRequired: true,
//           //
//           //     showError: false,
//           //
//           //     isCrossBtnShown: false,
//           //
//           //     boxDecoration: const BoxDecoration(
//           //       border: Border.fromBorderSide(
//           //         BorderSide(color: Colors.transparent),
//           //       ),
//           //     ),
//           //
//           //     textStyle: const TextStyle(
//           //       fontSize: 14,
//           //       color: Colors.black,
//           //     ),
//           //
//           //     containerVerticalPadding: 0,
//           //     containerHorizontalPadding: 0,
//           //
//           //
//           //     itemBuilder: (context, index, prediction) {
//           //       return Container(
//           //         color: Colors.white,
//           //         padding: const EdgeInsets.symmetric(
//           //           horizontal: 12,
//           //           vertical: 12,
//           //         ),
//           //         child: Row(
//           //           children: [
//           //             const Icon(
//           //               Icons.location_on_outlined,
//           //               color: Colors.grey,
//           //               size: 20,
//           //             ),
//           //
//           //             const SizedBox(width: 10),
//           //
//           //             Expanded(
//           //               child: Text(
//           //                 prediction.description ?? "",
//           //                 maxLines: 2,
//           //                 overflow: TextOverflow.ellipsis,
//           //                 style: const TextStyle(
//           //                   fontSize: 13,
//           //                   fontWeight: FontWeight.w500,
//           //                 ),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       );
//           //     },
//           //
//           //     seperatedBuilder: const Divider(
//           //       height: 1,
//           //       color: Color(0xffE2E8F0),
//           //     ),
//           //
//           //     inputDecoration: InputDecoration(
//           //
//           //       border: InputBorder.none,
//           //       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//           //       // contentPadding: EdgeInsets.zero,
//           //       hintText: "Search location",
//           //           suffixIcon: SizedBox(
//           //             width: 60,
//           //             child: Row(
//           //               mainAxisAlignment: MainAxisAlignment.end,
//           //               mainAxisSize: MainAxisSize.min,
//           //               crossAxisAlignment: CrossAxisAlignment.start,
//           //               children: [
//           //                 GestureDetector(
//           //                   onTap: () {
//           //                     widget.controller.clear();
//           //
//           //                     if (widget.isPickup) {
//           //                       provider.clearPickupLocation();
//           //                     } else {
//           //                       provider.clearDropLocation();
//           //                     }
//           //
//           //                     setState(() {
//           //                       isFocused = false;
//           //                     });
//           //                   },
//           //                   child: Padding(
//           //                     padding: EdgeInsets.only(top: 12),
//           //                     child: Icon(
//           //                       Icons.cancel,
//           //                       color: ColorResource.primary,
//           //                       size: 18,
//           //                     ),
//           //                   ),
//           //                 ),
//           //                 // SizedBox(width: 2,),
//           //                 if (Platform.isAndroid)
//           //                   GestureDetector(
//           //                     onTap: () async {
//           //
//           //                       print("When open map lat lng1 pickup");
//           //                       print(provider.pickupLat);
//           //                       print(provider.pickupLng);
//           //                       print("When open map lat lng2 drop location");
//           //                       print(provider.dropLat);
//           //                       print(provider.dropLng);
//           //                       final result = await Navigator.push(
//           //                         context,
//           //                         MaterialPageRoute(
//           //                           builder: (_) => MapPickerScreen(
//           //                             initialLat: widget.isPickup
//           //                                 ? provider.pickupLat
//           //                                 : provider.dropLat,
//           //                             initialLng: widget.isPickup
//           //                                 ? provider.pickupLng
//           //                                 : provider.dropLng,
//           //                           ),
//           //                         ),
//           //                       );
//           //
//           //                       print("MAP RESULT => $result");
//           //
//           //                       if (result != null &&
//           //                           result["lat"] != null &&
//           //                           result["lng"] != null) {
//           //
//           //                         final double lat = result["lat"] is double
//           //                             ? result["lat"]
//           //                             : double.parse(result["lat"].toString());
//           //
//           //                         final double lng = result["lng"] is double
//           //                             ? result["lng"]
//           //                             : double.parse(result["lng"].toString());
//           //
//           //                         final String address =
//           //                             result["address"]?.toString() ?? "";
//           //
//           //                         widget.controller.text = address;
//           //
//           //                         if (widget.isPickup) {
//           //                           provider.setPickupFromMap(
//           //                             address: address,
//           //                             lat: lat,
//           //                             lng: lng,
//           //                           );
//           //
//           //                           debugPrint(
//           //                             "PICKUP SAVED => $lat , $lng",
//           //                           );
//           //                         } else {
//           //                           provider.setDropFromMap(
//           //                             address: address,
//           //                             lat: lat,
//           //                             lng: lng,
//           //                           );
//           //
//           //                           debugPrint(
//           //                             "DROP SAVED => $lat , $lng",
//           //                           );
//           //                         }
//           //
//           //                         setState(() {});
//           //                       }
//           //
//           //                     },
//           //
//           //                     child: Padding(
//           //                       padding: EdgeInsets.only(top: 8, left: 5,right: 5),
//           //                       child: const Icon(
//           //                         Icons.add_location_alt_sharp,
//           //                         color: ColorResource.primary,
//           //                         size: 24,
//           //                       ),
//           //                     ),
//           //                   ),
//           //               ],
//           //             ),
//           //           ),),
//           //
//           //       // getPlaceDetailWithLatLng: (Prediction prediction) {
//           //       //   _fetchAndSetPlaceDetails(
//           //       //     context,
//           //       //     prediction,
//           //       //     isPickup: widget.isPickup,
//           //       //   );
//           //       // },
//           //
//           //     itemClick: (Prediction prediction) async {
//           //
//           //       widget.controller.text =
//           //           prediction.description ?? "";
//           //
//           //       widget.controller.selection =
//           //           TextSelection.fromPosition(
//           //             TextPosition(
//           //               offset: widget.controller.text.length,
//           //             ),
//           //           );
//           //
//           //       FocusScope.of(context).unfocus();
//           //
//           //       await _fetchAndSetPlaceDetails(
//           //         context,
//           //         prediction,
//           //         isPickup: widget.isPickup,
//           //       );
//           //       print("PLACE ID => ${prediction.placeId}");
//           //
//           //
//           //       setState(() {
//           //         isFocused = false;
//           //       });
//           //     },
//           //
//           //
//           //   ),
//           //
//           //
//           //
//           //
//           //
//           // ),
//           child: // In _LocationFieldState > build()
//
//           GestureDetector(
//             onTap: () async {
//               widget.onFocus?.call();
//
//               final result = await Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => LocationSelectionScreen(
//                     isPickup: widget.isPickup,
//                     initialAddress: widget.controller.text,
//                   ),
//                 ),
//               );
//
//               if (result != null) {
//                 // Optional: handle any result if needed
//                 setState(() {});
//               }
//             },
//             child: Container(
//               height: 45,
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black.withOpacity(0.7)),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 12),
//               child: Row(
//                 children: [
//                   // Icon
//                   if (widget.iconPath != null) ...[
//                     Image.asset(widget.iconPath!, height: widget.height, width: widget.width),
//                     const SizedBox(width: 8),
//                   ],
//                   Expanded(
//                     child: Text(
//                       widget.controller.text.isEmpty
//                           ? "Search location"
//                           : widget.controller.text,
//                       style: const TextStyle(fontSize: 14),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         // SizedBox(height: 10,),
//         /// RECENT SEARCH LIST
//         if (isFocused &&
//             widget.controller.text.isEmpty &&
//             recentList.isNotEmpty)
//           Container(
//             margin: const EdgeInsets.only(top: 5),
//
//             decoration: BoxDecoration(
//               color: Colors.white,
//
//               borderRadius: BorderRadius.circular(12),
//
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.08),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//
//             child: Column(
//               children: List.generate(recentList.length, (index) {
//                 final item = recentList[index];
//
//                 return locationTile(
//                   icon: Icons.history,
//                   favoriteIcon:
//                       item.source == "recent_search"
//                           ? Icons.favorite
//                           : Icons.favorite_border,
//                   isRed: item.source == "recent_search",
//
//                   title: item.address ?? '',
//                   showDivider: index != recentList.length - 1,
//                   onTapSaved: () async {
//
//
//                     if (item.source == "recent_search") {
//                       return;
//                     }
//                     showSaveLocationBottomSheet(
//                       context,
//                       provider,
//                       item.address ?? '',
//                       item.lat.toString(),
//                       item.lng.toString(),
//                     );
//
//
//                   },
//                   onTap: () {
//                     print("new changes like repido");
//                     widget.controller.text = item.address ?? '';
//
//                     isFocused = false;
//
//                     FocusScope.of(context).unfocus();
//
//                     setState(() {});
//
//                     if (widget.isPickup) {
//                       provider.setPickupFromMap(
//                         address: item.address ?? '',
//                         lat: item.lat ?? 0.0,
//                         lng: item.lng ?? 0.0,
//                         // context: context
//                       );
//                     } else {
//                       provider.setDropFromMap(
//                         address: item.address ?? '',
//                         lat: item.lat ?? 0.0,
//                         lng: item.lng ?? 0.0,
//                         // context: context
//                       );
//                     }
//                   },
//                 );
//               }),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget locationTile({
//     required IconData icon,
//     IconData? favoriteIcon,
//     required String title,
//     VoidCallback? onTap,
//     VoidCallback? onTapSaved,
//     bool showDivider = true,
//     bool isRed = false,
//   }) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//             child: Row(
//               children: [
//                 Icon(icon, color: Colors.blueGrey, size: 20),
//
//                 const SizedBox(width: 12),
//
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 12,
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//
//                 if (icon != null)
//                   InkWell(
//                     onTap: onTapSaved,
//                     child: Icon(
//                       favoriteIcon,
//                       color: isRed ? Colors.red : Colors.blueGrey,
//                       size: 20,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//
//         const Divider(height: 1, color: Color(0xffE2E8F0)),
//       ],
//     );
//   }
//
//   Future<void> _fetchAndSetPlaceDetails(
//     BuildContext context,
//     Prediction prediction, {
//     required bool isPickup,
//   }) async {
//     try {
//       final provider = Provider.of<HomeProvider>(context, listen: false);
//
//       final response = await http.get(
//         Uri.parse(
//           'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=$googleKey&fields=address_components,formatted_address,geometry',
//         ),
//       );
//       print("API RESPONSE => ${response.body}");
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//
//         if (data['status'] == 'OK') {
//           final result = data['result'];
//
//           final lat = result['geometry']?['location']?['lat'];
//
//           final lng = result['geometry']?['location']?['lng'];
//
//           Map<String, String> components = {};
//
//           for (var comp in result['address_components'] ?? []) {
//             final types = comp['types'] as List<dynamic>?;
//
//             final name = comp['long_name'] as String?;
//
//             if (name == null) continue;
//
//             if (types?.contains('postal_code') == true) {
//               components['pincode'] = name;
//             }
//
//             if (types?.contains('locality') == true) {
//               components['city'] = name;
//             }
//
//             if (types?.contains('administrative_area_level_1') == true) {
//               components['state'] = name;
//             }
//           }
//
//           if (isPickup) {
//             provider.setPickupFromPrediction(
//               prediction,
//               lat: lat,
//               lng: lng,
//               components: components,
//               context: context
//             );
//           } else {
//             provider.setDropFromPrediction(
//               prediction,
//               lat: lat,
//               lng: lng,
//               components: components,
//               context: context
//             );
//           }
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('Error fetching details: $e')));
//     }
//   }
// }

void showSaveLocationBottomSheet(
  BuildContext context,
  HomeProvider provider,
  String address,
  String lat,
  String lng,
) {
  String selectedType = "Home";
  final TextEditingController customController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: ColorResource.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Center(
                  child: Text(
                    "Add to Favorites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color:  Colors.black.withOpacity(0.7)),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorResource.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color:  Colors.black.withOpacity(0.7),width: 1)
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          address,
                          style:  TextStyle(fontSize: 14,color:  Colors.black.withOpacity(0.7)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                 Text(
                  "Save location as",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600,color:  Colors.black.withOpacity(0.7),),
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _locationOption(
                      title: "Home",
                      icon: Icons.home,
                      selected: selectedType == "Home",
                      onTap: () {
                        setState(() {
                          selectedType = "Home";
                        });
                      },
                    ),

                    _locationOption(
                      title: "Work",
                      icon: Icons.work,
                      selected: selectedType == "Work",
                      onTap: () {
                        setState(() {
                          selectedType = "Work";
                        });
                      },
                    ),

                    // _locationOption(
                    //   title: "Office",
                    //   icon: Icons.business,
                    //   selected: selectedType == "Office",
                    //   onTap: () {
                    //     setState(() {
                    //       selectedType = "Office";
                    //     });
                    //   },
                    // ),

                    _locationOption(
                      title: "Other",
                      icon: Icons.edit_location_alt,
                      selected: selectedType == "Other",
                      onTap: () {
                        setState(() {
                          selectedType = "Other";
                        });
                      },
                    ),
                  ],
                ),

                if (selectedType == "Other") ...[
                  const SizedBox(height: 15),

                  TextField(
                    controller: customController,
                    cursorColor: Colors.black.withOpacity(0.7),
                    style: TextStyle(color:Colors.black.withOpacity(0.7)),
                    decoration: InputDecoration(
                      hintText: "Enter custom name",
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.7)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final type =
                          selectedType == "Other"
                              ? customController.text.trim()
                              : selectedType;

                      provider.saveFavoriteLocations(
                        context: context,
                        location: address,
                        latitude: lat,
                        longitude: lng,
                        addressType: type,
                      );

                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _locationOption({
  required String title,
  required IconData icon,
  required bool selected,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: selected ? ColorResource.primary : ColorResource.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? ColorResource.primary : Colors.black.withOpacity(0.7),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ?Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ?Colors.black.withOpacity(0.7): Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ),
  );
}
