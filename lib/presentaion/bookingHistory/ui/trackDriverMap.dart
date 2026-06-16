import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mannfleet/widget/custom_appBar.dart';

class TrackDriverMap extends StatefulWidget {
  final double driverLat;
  final double driverLng;
  final double pickUpLat;
  final double pickUpLng;
  final double dropLat;
  final double dropLng;
  final String googleApiKey;
  final bool startOtp;//bas aapko ek ternatory operater check lagana hai ki ager start otp false hai to us time driver lat lang and pickup lat lat lng ka drw ho jo yhi ho rha ahi ager ager true ho to driver lat lang and drop lat latlng ka drop line bana hai ok

  const TrackDriverMap({
    super.key,
    required this.driverLat,
    required this.driverLng,
    required this.dropLng,
    required this.dropLat,
    required this.pickUpLat,
    required this.pickUpLng,
    required this.googleApiKey,
    required this.startOtp,
  });

  @override
  State<TrackDriverMap> createState() => _TrackDriverMapState();
}

class _TrackDriverMapState extends State<TrackDriverMap> {
  final Completer<GoogleMapController> _mapController = Completer();

  LatLng? currentLatLng;
  LatLng? driverLatLng;

  ScreenCoordinate? driverScreen;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  List<dynamic> routeSteps = [];

  String distanceText = "";
  String durationText = "";

  Timer? timer;

  BitmapDescriptor? carIcon;

  @override
  void initState() {
    super.initState();

    driverLatLng = LatLng(widget.driverLat, widget.driverLng);

    init();
  }
  Future<void> updateDriverScreenPosition() async {
    final controller = await _mapController.future;

    driverScreen = await controller.getScreenCoordinate(
      LatLng(widget.driverLat, widget.driverLng),
    );

    print("X = ${driverScreen?.x}");
    print("Y = ${driverScreen?.y}");

    if (mounted) {
      setState(() {});
    }
  }
  // Future<void> updateDriverScreenPosition() async {
  //   final controller = await _mapController.future;
  //
  //   driverScreen = await controller.getScreenCoordinate(
  //     LatLng(widget.driverLat, widget.driverLng),
  //   );
  //
  //   if (mounted) setState(() {});
  // }
  Future<void> init() async {
    await loadCarIcon();

    await getCurrentLocation();

    await drawRoute();

    startLiveTracking();
  }

  Future<void> loadCarIcon() async {
    carIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/icon/car.png",
    );
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    currentLatLng = LatLng(position.latitude, position.longitude);

    setMarkers();

    setState(() {});
  }

  double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * pi / 180;

    double lon1 = start.longitude * pi / 180;

    double lat2 = end.latitude * pi / 180;

    double lon2 = end.longitude * pi / 180;

    double dLon = lon2 - lon1;

    double y = sin(dLon) * cos(lat2);

    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double bearing = atan2(y, x);

    bearing = bearing * 180 / pi;

    bearing = (bearing + 360) % 360;

    return bearing;
  }

  // void setMarkers() {
  //   markers = {
  //     Marker(
  //       markerId: const MarkerId("pickup"),
  //       position: LatLng(
  //         widget.pickUpLat,
  //         widget.pickUpLng,
  //       ),
  //       infoWindow: const InfoWindow(title: "Pickup"),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(
  //         BitmapDescriptor.hueBlue,
  //       ),
  //     ),
  //     Marker(
  //       markerId: const MarkerId("driver"),
  //       position: LatLng(
  //         widget.driverLat,
  //         widget.driverLng,
  //       ),
  //       anchor: const Offset(0.5, 0.5),
  //       flat: true,
  //       icon: carIcon ?? BitmapDescriptor.defaultMarker,
  //     ),
  //     // Marker(
  //     //   markerId: const MarkerId("driver"),
  //     //   position: LatLng(
  //     //     widget.driverLat,
  //     //     widget.driverLng,
  //     //   ),
  //     //   infoWindow: const InfoWindow(title: "Driver"),
  //     // ),
  //   };
  // }
  void setMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId("destination"),
        position: LatLng(
          widget.startOtp
              ? widget.dropLat
              : widget.pickUpLat,

          widget.startOtp
              ? widget.dropLng
              : widget.pickUpLng,
        ),
        infoWindow: InfoWindow(
          title: widget.startOtp
              ? "Drop Location"
              : "Pickup Location",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          widget.startOtp
              ? BitmapDescriptor.hueRed
              : BitmapDescriptor.hueBlue,
        ),
      ),

      Marker(
        markerId: const MarkerId("driver"),
        position: LatLng(
          widget.driverLat,
          widget.driverLng,
        ),
        anchor: const Offset(0.5, 0.5),
        flat: true,
        icon: carIcon ?? BitmapDescriptor.defaultMarker,
      ),
    };
  }
  // void setMarkers() {
  //   if (currentLatLng == null || driverLatLng == null) {
  //     return;
  //   }
  //
  //   double rotation = calculateBearing(currentLatLng!, driverLatLng!);
  //
  //   markers = {
  //     Marker(
  //       markerId: const MarkerId("user"),
  //
  //       position: currentLatLng!,
  //
  //       infoWindow: const InfoWindow(title: "Pickup"),
  //
  //       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
  //     ),
  //
  //     Marker(
  //       markerId: const MarkerId("driver"),
  //
  //       position: driverLatLng!,
  //
  //       flat: true,
  //
  //       rotation: rotation,
  //
  //       anchor: const Offset(0.5, 0.5),
  //
  //       infoWindow: const InfoWindow(title: "Driver"),
  //
  //       icon: carIcon ?? BitmapDescriptor.defaultMarker,
  //     ),
  //   };
  // }

  Future<void> drawRoute() async {
    if (currentLatLng == null || driverLatLng == null) {
      return;
    }

    try {
      final url = "https://routes.googleapis.com/directions/v2:computeRoutes";
      final body = {
        "origin": {
          "location": {
            "latLng": {
              "latitude": widget.driverLat,
              "longitude": widget.driverLng,
            },
          },
        },

        "destination": {
          "location": {
            "latLng": {
              "latitude": widget.startOtp
                  ? widget.dropLat
                  : widget.pickUpLat,

              "longitude": widget.startOtp
                  ? widget.dropLng
                  : widget.pickUpLng,
            },
          },
        },

        "travelMode": "DRIVE",
        "polylineQuality": "HIGH_QUALITY",
      };
      // final body = {
      //   "origin": {
      //     "location": {
      //       "latLng": {
      //         "latitude": widget.driverLat,
      //         "longitude": widget.driverLng,
      //       },
      //     },
      //   },
      //   "destination": {
      //     "location": {
      //       "latLng": {
      //         "latitude": widget.pickUpLat,
      //         "longitude": widget.pickUpLng,
      //       },
      //     },
      //   },
      //   "travelMode": "DRIVE",
      //   "polylineQuality": "HIGH_QUALITY",
      // };

      // final body = {
      //   "origin": {
      //     "location": {
      //       "latLng": {
      //         "latitude": driverLatLng!.latitude,
      //         "longitude": driverLatLng!.longitude,
      //       },
      //     },
      //   },
      //
      //   "destination": {
      //     "location": {
      //       "latLng": {
      //         "latitude": currentLatLng!.latitude,
      //         "longitude": currentLatLng!.longitude,
      //       },
      //     },
      //   },
      //
      //   "travelMode": "DRIVE",
      //
      //   "polylineQuality": "HIGH_QUALITY",
      // };

      final response = await http.post(
        Uri.parse(url),

        headers: {
          "Content-Type": "application/json",

          "X-Goog-Api-Key": widget.googleApiKey,

          "X-Goog-FieldMask":
              "routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline",
        },

        body: jsonEncode(body),
      );

      print(response.body);

      final data = jsonDecode(response.body);

      if (data["routes"] == null || data["routes"].isEmpty) {
        print("NO ROUTE FOUND");
        return;
      }

      final route = data["routes"][0];

      final encoded = route["polyline"]["encodedPolyline"];

      /// DISTANCE

      final distanceMeters = route["distanceMeters"];

      distanceText = "${(distanceMeters / 1000).toStringAsFixed(1)} km";

      /// DURATION
      durationText = formatDuration(route["duration"].toString());

      // durationText =
      //     route["duration"]
      //         .toString();

      /// DECODE

      List<PointLatLng> result = PolylinePoints.decodePolyline(encoded);

      List<LatLng> polylineCoordinates = [];

      for (var point in result) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      polylines.clear();

      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),

          points: polylineCoordinates,

          width: 8,

          color: Colors.blue,

          geodesic: true,
        ),
      );

      setMarkers();

      setState(() {});

      moveCamera();
      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      await updateDriverScreenPosition();
    } catch (e) {
      print(e);
    }
  }

  Future<void> moveCamera() async {
    final controller = await _mapController.future;

    final destLat =
    widget.startOtp ? widget.dropLat : widget.pickUpLat;

    final destLng =
    widget.startOtp ? widget.dropLng : widget.pickUpLng;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        min(destLat, widget.driverLat),
        min(destLng, widget.driverLng),
      ),
      northeast: LatLng(
        max(destLat, widget.driverLat),
        max(destLng, widget.driverLng),
      ),
    );

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }
  //
  // Future<void> moveCamera() async {
  //   final controller = await _mapController.future;
  //
  //   LatLngBounds bounds = LatLngBounds(
  //     southwest: LatLng(
  //       min(widget.pickUpLat, widget.driverLat),
  //       min(widget.pickUpLng, widget.driverLng),
  //     ),
  //     northeast: LatLng(
  //       max(widget.pickUpLat, widget.driverLat),
  //       max(widget.pickUpLng, widget.driverLng),
  //     ),
  //   );
  //
  //   controller.animateCamera(
  //     CameraUpdate.newLatLngBounds(bounds, 80),
  //   );
  // }

  // Future<void> moveCamera() async {
  //   final controller = await _mapController.future;
  //
  //   LatLngBounds bounds = LatLngBounds(
  //     southwest: LatLng(
  //       min(currentLatLng!.latitude, driverLatLng!.latitude),
  //       min(currentLatLng!.longitude, driverLatLng!.longitude),
  //     ),
  //     northeast: LatLng(
  //       max(currentLatLng!.latitude, driverLatLng!.latitude),
  //       max(currentLatLng!.longitude, driverLatLng!.longitude),
  //     ),
  //   );
  //
  //   controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  // }

  Future<void> animateDriver(LatLng newPosition) async {
    final controller = await _mapController.future;

    driverLatLng = newPosition;

    setMarkers();

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: newPosition, zoom: 16),
      ),
    );

    setState(() {});
  }

  void startLiveTracking() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      /// API se latest location lo

      // LatLng newDriverPosition = LatLng(
      //   driverLatLng!.latitude + 0.0003,
      //   driverLatLng!.longitude + 0.0003,
      // );

      // await animateDriver(newDriverPosition);

      await drawRoute();
    });
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentLatLng == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Track Driver", isBack: true),

      body: Stack(
        children: [

          GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.driverLat,
                  widget.driverLng,
                ),
                zoom: 15,
              ),

            myLocationEnabled: true,

            myLocationButtonEnabled: true,

            zoomControlsEnabled: false,

            compassEnabled: true,

            markers: markers,

            polylines: polylines,
              onMapCreated: (controller) async {
                _mapController.complete(controller);

                await updateDriverScreenPosition();
              }

            // onMapCreated: (controller) {
            //   _mapController.complete(controller);
            // },
          ),

          // if (driverScreen != null)
          //   Positioned(
          //     left: driverScreen!.x.toDouble() - 30,
          //     top: driverScreen!.y.toDouble() - 30,
          //     child: Image.asset(
          //       "assets/icon/car.png",
          //       width: 60,
          //       height: 60,
          //     ),
          //   ),

          /// TOP ROUTE CARD
          Positioned(
            top: 50,
            left: 16,
            right: 16,

            child: Container(
              padding: const EdgeInsets.all(14),

              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.1),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Container(
                        height: 42,
                        width: 42,

                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),

                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            const Text(
                              "Driver Tracking",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "$distanceText • $durationText",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      // Container(
                      //   padding: const EdgeInsets.all(10),
                      //
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.withOpacity(.1),
                      //     shape: BoxShape.circle,
                      //   ),
                      //
                      //   child: const Icon(Icons.call, color: Colors.green),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM ROUTE STEPS
        ],
      ),
    );
  }

  String formatDuration(String duration) {
    // "123s" → 123
    int seconds = int.parse(duration.replaceAll('s', ''));

    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    if (hours > 0) {
      return "${hours}h ${minutes}m ${remainingSeconds}s";
    } else if (minutes > 0) {
      return "${minutes}m ${remainingSeconds}s";
    } else {
      return "${remainingSeconds}s";
    }
  }
}
