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

  Future<void> _handleFocus() async {
    if (!mounted) return;

    if (_focusNode.hasFocus) {
      widget.onFocus?.call(); // 👈 ye missing hai

      isFocused = true;

      setState(() {});

      final provider = Provider.of<HomeProvider>(context, listen: false);

      await provider.getRecentLocations(context: context);

      if (mounted) {
        setState(() {});
      }
    } else {
      isFocused = false;

      if (mounted) {
        setState(() {});
      }
    }
  }
  // Future<void> _handleFocus() async {
  //   if (!mounted) return;
  //
  //   if (_focusNode.hasFocus) {
  //     isFocused = true;
  //
  //     setState(() {});
  //
  //     final provider = Provider.of<HomeProvider>(context, listen: false);
  //
  //     await provider.getRecentLocations(context: context);
  //
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   } else {
  //     isFocused = false;
  //
  //     if (mounted) {
  //       setState(() {});
  //     }
  //   }
  // }

  Future<void> loadKey() async {
    final key = await AppConfigService.getGoogleKey();

    setState(() {
      googleKey = key;
    });
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
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xff94A3B8),
          ),
        ),

        // const SizedBox(height: 2),
        SizedBox(
          height: 40,
          child: GooglePlaceAutoCompleteTextField(
            focusNode: _focusNode,
            textEditingController: widget.controller,

            googleAPIKey: googleKey ?? "",

            debounceTime: 400,

            countries: const ['in'],

            isLatLngRequired: true,

            showError: false,

            isCrossBtnShown: false,

            boxDecoration: BoxDecoration(
              border: Border.all(color: Colors.transparent, width: 0),
            ),
            textStyle: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              // height: 4,
            ),

            containerVerticalPadding: 0,
            containerHorizontalPadding: 0,

            inputDecoration: InputDecoration(
              border: InputBorder.none,

              suffixIcon: SizedBox(
                width: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        widget.controller.clear();

                        if (widget.isPickup) {
                          provider.clearPickupLocation();
                        } else {
                          provider.clearDropLocation();
                        }

                        setState(() {
                          isFocused = false;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Icon(
                          Icons.cancel,
                          color: ColorResource.primary,
                          size: 18,
                        ),
                      ),
                    ),
                    // SizedBox(width: 2,),
                    if (Platform.isAndroid)
                      GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              // builder: (_) => const MapPickerScreen(),
                              builder:
                                  (_) => MapPickerScreen(
                                    initialLat:
                                        widget.isPickup
                                            ? provider.pickupLat
                                            : provider.dropLat,
                                    initialLng:
                                        widget.isPickup
                                            ? provider.pickupLng
                                            : provider.dropLng,
                                  ),
                            ),
                          );

                          if (result != null) {
                            widget.controller.text = result['address'];

                            if (widget.isPickup) {
                              provider.setPickupFromMap(
                                address: result['address'],
                                lat: result['lat'],
                                lng: result['lng'],
                              );
                            } else {
                              provider.setDropFromMap(
                                address: result['address'],
                                lat: result['lat'],
                                lng: result['lng'],
                              );
                            }
                          }
                        },

                        child: Padding(
                          padding: EdgeInsets.only(top: 5, left: 5),
                          child: const Icon(
                            Icons.add_location_alt_sharp,
                            color: ColorResource.primary,
                            size: 24,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              enabledBorder: InputBorder.none,

              focusedBorder: InputBorder.none,

              disabledBorder: InputBorder.none,

              errorBorder: InputBorder.none,

              focusedErrorBorder: InputBorder.none,

              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),

              fillColor: Colors.white,
            ),

            getPlaceDetailWithLatLng: (Prediction prediction) {
              _fetchAndSetPlaceDetails(
                context,
                prediction,
                isPickup: widget.isPickup,
              );
            },

            itemClick: (Prediction prediction) {},
            itemBuilder: (context, index, Prediction prediction) {
              return Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: locationTile(
                  icon: Icons.location_on_outlined,
                  //    favoriteIcon: Icons.favorite_border,
                  isRed: false,
                  title: prediction.description ?? '',
                  showDivider: true,
                  onTapSaved: () {
                    //   yha par clcik karte hi ek bottom sheet se pop aayega jisme likha hoga tile add to favorites ,uske niche conatner me address hoga bole to location fir ek title hoga Save location as like work , office, other other par clcik karte hi manual enter karega ok
                  },
                  // onTap: () {
                  //   isFocused = false;
                  //
                  //   FocusScope.of(context).unfocus();
                  //
                  //   setState(() {});
                  // },
                ),
              );
            },

            seperatedBuilder: const Divider(
              height: 1,
              color: Color(0xff94A3B8),
            ),
          ),
        ),
        // SizedBox(height: 10,),
        /// RECENT SEARCH LIST
        if (isFocused &&
            widget.controller.text.isEmpty &&
            recentList.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 5),

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(12),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                ),
              ],
            ),

            child: Column(
              children: List.generate(recentList.length, (index) {
                final item = recentList[index];

                return locationTile(
                  icon: Icons.history,
                  favoriteIcon:
                      item.source == "recent_search"
                          ? Icons.favorite
                          : Icons.favorite_border,
                  isRed: item.source == "recent_search",

                  title: item.address ?? '',
                  showDivider: index != recentList.length - 1,
                  onTapSaved: () async {
                    //   yha par clcik karte hi ek bottom sheet se pop aayega jisme likha hoga tile add to favorites ,uske niche conatner me address hoga bole to location fir ek title hoga Save location as like work , office, other other par clcik karte hi manual enter karega ok

                    // provider.         saveFavoriteLocations(
                    //     context: context,
                    //     location: item.address ?? '',
                    //     latitude:item.lat.toString(),
                    //     longitude:item.lng.toString(),
                    //     addressType: "Home"
                    // );
                    // setState(() {
                    //   item.isFavorite = !(item.isFavorite ?? false);
                    // });

                    if (item.source == "recent_search") {
                      return;
                    }
                    showSaveLocationBottomSheet(
                      context,
                      provider,
                      item.address ?? '',
                      item.lat.toString(),
                      item.lng.toString(),
                    );

                    // if (item.isFavorite ?? false) {
                    //   showSaveLocationBottomSheet(
                    //     context,
                    //     provider,
                    //     item.address ?? '',
                    //     item.lat.toString(),
                    //     item.lng.toString(),
                    //   );
                    // }

                    // showSaveLocationBottomSheet(
                    //   context,
                    //   provider,
                    //   item.address ?? '',
                    //   item.lat.toString(),
                    //   item.lng.toString(),
                    // );
                  },
                  onTap: () {
                    print("new changes like repido");
                    widget.controller.text = item.address ?? '';

                    isFocused = false;

                    FocusScope.of(context).unfocus();

                    setState(() {});

                    if (widget.isPickup) {
                      provider.setPickupFromMap(
                        address: item.address ?? '',
                        lat: item.lat ?? 0.0,
                        lng: item.lng ?? 0.0,
                      );
                    } else {
                      provider.setDropFromMap(
                        address: item.address ?? '',
                        lat: item.lat ?? 0.0,
                        lng: item.lng ?? 0.0,
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                if (icon != null)
                  InkWell(
                    onTap: onTapSaved,
                    child: Icon(
                      favoriteIcon,
                      color: isRed ? Colors.red : Colors.blueGrey,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        ),

        const Divider(height: 1, color: Color(0xffE2E8F0)),
      ],
    );
  }

  Future<void> _fetchAndSetPlaceDetails(
    BuildContext context,
    Prediction prediction, {
    required bool isPickup,
  }) async {
    try {
      final provider = Provider.of<HomeProvider>(context, listen: false);

      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=$googleKey&fields=address_components,formatted_address,geometry',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];

          final lat = result['geometry']?['location']?['lat'];

          final lng = result['geometry']?['location']?['lng'];

          Map<String, String> components = {};

          for (var comp in result['address_components'] ?? []) {
            final types = comp['types'] as List<dynamic>?;

            final name = comp['long_name'] as String?;

            if (name == null) continue;

            if (types?.contains('postal_code') == true) {
              components['pincode'] = name;
            }

            if (types?.contains('locality') == true) {
              components['city'] = name;
            }

            if (types?.contains('administrative_area_level_1') == true) {
              components['state'] = name;
            }
          }

          if (isPickup) {
            provider.setPickupFromPrediction(
              prediction,
              lat: lat,
              lng: lng,
              components: components,
            );
          } else {
            provider.setDropFromPrediction(
              prediction,
              lat: lat,
              lng: lng,
              components: components,
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching details: $e')));
    }
  }
}

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
    backgroundColor: Colors.white,
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
                const Center(
                  child: Text(
                    "Add to Favorites",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Save location as",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

                    _locationOption(
                      title: "Office",
                      icon: Icons.business,
                      selected: selectedType == "Office",
                      onTap: () {
                        setState(() {
                          selectedType = "Office";
                        });
                      },
                    ),

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
                    decoration: InputDecoration(
                      hintText: "Enter custom name",
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
        color: selected ? Colors.blue.withOpacity(0.1) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected ? Colors.blue : Colors.grey.shade300,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: selected ? Colors.blue : Colors.grey),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    ),
  );
}
