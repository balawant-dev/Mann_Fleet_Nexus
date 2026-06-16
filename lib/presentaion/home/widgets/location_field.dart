import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../apiservice/services/appConfigService.dart';
import '../provider/homeProvider.dart';

class LocationField extends StatefulWidget {
  final String label;
  final String? iconPath;
  final double? width;
  final double? height;
  final TextEditingController controller;
  final bool isPickup; // true → pickup, false → drop
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
  @override
  void initState() {
    super.initState();
    loadKey();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        // Wait for keyboard to open properly
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onFocus?.call();
          }
        });
      }
    });
  }

  Future<void> loadKey() async {
    final key = await AppConfigService.getGoogleKey();
    setState(() {
      googleKey = key;
    });
    print("Google Api Key1 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑: $googleKey");
  }
  // String apiKey = 'AIzaSyAw5iIsWyZnq8Ejy8jLC2jcKvNRxI5Ll3w';

  @override
  Widget build(BuildContext context) {
    print("Google Api Key2 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑: $googleKey");
    final provider = Provider.of<HomeProvider>(context, listen: false);
    // if (googleKey == null || googleKey!.isEmpty) {
    //   return const SizedBox(
    //     height: 60,
    //     child: Center(child: CircularProgressIndicator()),
    //   );
    // }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff94A3B8),
          ),
        ),
        const SizedBox(height: 6),
        GooglePlaceAutoCompleteTextField(
          focusNode: _focusNode,

          boxDecoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 0),
          ),

          textStyle: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 3,
          ),

          googleAPIKey: googleKey ?? "AIzaSyAw5iIsWyZnq8Ejy8jLC2jcKvNRxI5Ll3w",
          // googleAPIKey: ApiConstants.googleApiKey,
          containerVerticalPadding: 0,
          // or 0 for minimal height
          containerHorizontalPadding: 0,
          inputDecoration: InputDecoration(
            // labelText: widget.label,
            hintText: widget.label,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xff94A3B8)),
            prefixIcon: widget.iconPath != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      top: 0.0,
                      left: 10,
                      right: 10,
                    ),
                    child: Image.asset(
                      widget.iconPath!,
                      width: widget.width,
                      height: widget.height,
                    ),
                  )
                : null,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 1,
              horizontal: 0,
            ),

            // filled: true,
            fillColor: Colors.white,
          ),

          debounceTime: 400,
          countries: const ['in'],
          // India bias
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            // Yeh call hota hai jab user place select karta hai
            _fetchAndSetPlaceDetails(
              context,
              prediction,
              isPickup: widget.isPickup,
            );
          },
          itemClick: (Prediction prediction) {
            // Optional: preview mein click pe bhi kuch kar sakte ho
          },
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.blueGrey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prediction.description ?? '',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          },
          seperatedBuilder: Divider(height: 1, color: Color(0xff94A3B8)),

          textEditingController: widget.controller,
        ),
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

      // Same logic as your _selectPlace
      final response = await http.get(
        Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=${prediction.placeId}&key=${googleKey}&fields=address_components,formatted_address,geometry',
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

            if (types?.contains('postal_code') == true)
              components['pincode'] = name;
            if (types?.contains('locality') == true) components['city'] = name;
            if (types?.contains('administrative_area_level_1') == true)
              components['state'] = name;
            // aur jitne chahiye utne add kar lo
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
