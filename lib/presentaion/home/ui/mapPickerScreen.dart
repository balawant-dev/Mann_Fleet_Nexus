import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;
  const MapPickerScreen({super.key,  this.initialLat,
    this.initialLng,});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  GoogleMapController? mapController;

  LatLng selectedLatLng = const LatLng(28.6139, 77.2090);

  String address = "Loading location...";
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _getCurrentLocation();
  // }
  @override
  void initState() {
    super.initState();

    if (widget.initialLat != null && widget.initialLng != null) {
      selectedLatLng = LatLng(
        widget.initialLat!,
        widget.initialLng!,
      );

      _getAddress();
    } else {
      _getCurrentLocation();
    }
  }
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    final pos = await Geolocator.getCurrentPosition();

    selectedLatLng = LatLng(pos.latitude, pos.longitude);

    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(selectedLatLng, 16),
    );

    _getAddress();
  }

  Future<void> _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        selectedLatLng.latitude,
        selectedLatLng.longitude,
      );

      final place = placemarks.first;

      setState(() {
        address =
            "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
      });
    } catch (e) {
      setState(() {
        address = "Unable to fetch address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: Stack(
        children: [
          /// MAP
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLatLng,
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            // onMapCreated: (controller) {
            //   mapController = controller;
            // },
            onMapCreated: (controller) {
              mapController = controller;

              mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(
                  selectedLatLng,
                  16,
                ),
              );
            },
            onCameraMove: (position) {
              selectedLatLng = position.target;
            },
            onCameraIdle: _getAddress,
          ),

          /// TOP SAFE HEADER
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
          ),

          /// CENTER PIN
          IgnorePointer(
            child: const Center(
              child: Icon(Icons.location_pin, size: 52, color: Colors.red),
            ),
          ),

          /// CURRENT LOCATION BUTTON
          Positioned(
            right: 16,
            bottom: 150 + bottomInset,
            child: FloatingActionButton(
              mini: true,
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),

          /// BOTTOM SHEET
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black12)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    Text(
                      address,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            "lat": selectedLatLng.latitude,
                            "lng": selectedLatLng.longitude,
                            "address": address,
                          });
                        },
                        child: const Text("Confirm Location"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
