// lib/features/home/ui/location_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:mannfleet/presentaion/home/ui/widget/locationField.dart';
import 'package:mannfleet/util/color/app_colors.dart';

import 'package:provider/provider.dart';
import '../../../apiservice/services/appConfigService.dart';
import '../provider/homeProvider.dart';
import 'location_tile.dart';
import 'mapPickerScreen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;



class LocationSelectionScreen extends StatefulWidget {
  final bool isPickup;
  final String? initialAddress;

  const LocationSelectionScreen({
    super.key,
    required this.isPickup,
    this.initialAddress,
  });

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? googleKey;
  bool isLoading = false;
  final FocusNode _focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    _loadGoogleKey();
    _loadRecentLocations();

    if (widget.initialAddress != null) {
      _searchController.text = widget.initialAddress!;
    }

    // ✅ Listener to handle keyboard clear button properly
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {}); // This ensures suffixIcon updates instantly
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadGoogleKey() async {
    final key = await AppConfigService.getGoogleKey();
    setState(() => googleKey = key);
  }

  Future<void> _loadRecentLocations() async {
    final provider = Provider.of<HomeProvider>(context, listen: false);
    await provider.getRecentLocations(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final recentList = provider.recentLocationModel ?? [];

    return Scaffold(
      backgroundColor: ColorResource.white,
      // backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text(
          widget.isPickup ? "Pickup Location" : "Drop Location",
          style:  TextStyle(fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.7),fontSize: 16),
        ),
        backgroundColor: ColorResource.white,
        elevation: 0,
        leading: IconButton(
          icon:  Icon(Icons.arrow_back, color:  Colors.black.withOpacity(0.7),),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:  Text("Cancel", style: TextStyle(color: ColorResource.primary)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Field (Improved)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: googleKey ?? "AIzaSyAw5iIsWyZnq8Ejy8jLC2jcKvNRxI5Ll3w",
              debounceTime: 300,
              countries: const ['in'],
              isLatLngRequired: true,
              showError: false,
              focusNode: _focusNode,
              textStyle: TextStyle(color:  Colors.black.withOpacity(0.7),),



              inputDecoration: InputDecoration(

                hintText: "Search ${widget.isPickup ? "pickup" : "drop"} location",
                hintStyle: TextStyle(color:  Colors.black.withOpacity(0.7),),


                // hintStyle: ,
                filled: true,
                fillColor: Colors.transparent,
                // fillColor: Colors.grey[100],
                // border: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(12),
                //   borderSide: BorderSide.none,
                //
                // ),
                border: InputBorder.none,
                focusedErrorBorder:  InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                prefixIcon:  Icon(Icons.search, color:  Colors.black.withOpacity(0.7),),
                // suffixIcon: _searchController.text.isNotEmpty
                //     ? IconButton(
                //   icon: const Icon(Icons.clear),
                //   onPressed: () => _searchController.clear(),
                // )
                //     : null,
              ),
              // itemBuilder: (context, index, prediction) {
              //   return ListTile(
              //     leading: const Icon(Icons.location_on_outlined, color: Colors.grey),
              //     title: Text(prediction.description ?? ""),
              //   );
              // },

              itemBuilder: (context, index, prediction) {
                return Container(
                  color: ColorResource.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color:  Colors.black.withOpacity(0.7),
                            size: 20,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              prediction.description ?? "",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color:  Colors.black.withOpacity(0.7), fontSize: 13),
                              // style: const TextStyle(
                              //   fontSize: 13,
                              //   fontWeight: FontWeight.w500,
                              // ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8,),
                      const Divider(height: 1, indent: 25, color: Color(0xffE2E8F0)),
                    ],
                  ),
                );
              },
              itemClick: (Prediction prediction) async {
                await _fetchPlaceDetails(prediction, provider);
              },
            ),
          ),

          // Map + Add Stops Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MapPickerScreen(
                          initialLat: widget.isPickup ? provider.pickupLat : provider.dropLat,
                          initialLng: widget.isPickup ? provider.pickupLng : provider.dropLng,
                        ),
                      ),
                    );
                    if (result != null && result["address"] != null) {
                      _handleMapResult(result, provider,context);
                    }
                  },

                  icon:  Icon(Icons.map_outlined,color:  Colors.white.withOpacity(0.7),),
                  label: const Text("Select on map",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResource.primarySec,
                    foregroundColor:  Colors.black.withOpacity(0.7),
                    elevation: 0,
                    side: const BorderSide(color: Colors.grey),
                    padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       // Add stops logic if needed
                //     },
                //     icon: const Icon(Icons.add, color: Colors.black87),
                //     label: const Text("Add stops"),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Colors.white,
                //       foregroundColor: Colors.black87,
                //       elevation: 0,
                //       side: const BorderSide(color: Colors.grey),
                //       padding: const EdgeInsets.symmetric(vertical: 12),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),

          // const Divider(height: 1, color: Color(0xffE2E8F0)),

          // Recent Locations List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              itemCount: recentList.length,
              itemBuilder: (context, index) {
                final item = recentList[index];
                return LocationTile(
                  item: item,
                  isFavorite: item.model??"SearchHistory",
                  // isFavorite: item.source == "recent_search" || item.source != null,
                  onTap: () => _selectLocation(item, provider,context),
                  onSave: () {
                    if( item.model == "RecentSearch"  ){
                      provider.removeFavoriteLocations(id: item.id ?? "No Recent Id Found",context: context);

                    }else{
                      showSaveLocationBottomSheet(
                        context,
                        provider,
                        item.address ?? '',
                        (item.lat ?? 0.0).toString(),
                        (item.lng ?? 0.0).toString(),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Fetch Place Details (same as before)
  Future<void> _fetchPlaceDetails(Prediction prediction, HomeProvider provider) async {
    setState(() => isLoading = true);

    try {
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
            final types = comp['types'] as List?;
            final name = comp['long_name'] as String?;
            if (name == null) continue;

            if (types?.contains('postal_code') == true) components['pincode'] = name;
            if (types?.contains('locality') == true) components['city'] = name;
            if (types?.contains('administrative_area_level_1') == true) components['state'] = name;
          }

          if (widget.isPickup) {
            provider.setPickupFromPrediction(prediction, lat: lat, lng: lng, components: components,context: context);
          } else {
            provider.setDropFromPrediction(prediction, lat: lat, lng: lng, components: components,context: context);
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching place details: $e");
    }

    if (mounted) Navigator.pop(context);
  }

  void _handleMapResult(Map<String, dynamic> result, HomeProvider provider,BuildContext context) {
    final address = result["address"].toString();
    final lat = double.parse(result["lat"].toString());
    final lng = double.parse(result["lng"].toString());

    if (widget.isPickup) {
      provider.setPickupFromMap(address: address, lat: lat, lng: lng,context: context);
    } else {
      provider.setDropFromMap(address: address, lat: lat, lng: lng,context: context);
    }
    Navigator.pop(context);
  }

  void _selectLocation(dynamic item, HomeProvider provider,BuildContext context) {
    if (widget.isPickup) {
      provider.setPickupFromMapRecent(
          address: item.address ?? '',
          lat: item.lat ?? 0.0,
          lng: item.lng ?? 0.0,
          context: context
      );
    } else {
      provider.setDropFromMapRecent(
          address: item.address ?? '',
          lat: item.lat ?? 0.0,
          lng: item.lng ?? 0.0,
          context: context
      );
    }
    Navigator.pop(context);
  }
}