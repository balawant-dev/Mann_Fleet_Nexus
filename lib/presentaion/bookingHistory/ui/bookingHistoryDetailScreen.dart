import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../apiservice/constants/api_constants.dart';
import '../../../util/FontResource/FontResource.dart'; // adjust if needed
import '../../../widget/custom_appBar.dart';
import '../../../widget/custom_button.dart';
import '../../../widget/showLoaderFunction.dart';
import '../model/bookingHistoryDetailModel.dart'; // ← your model file
import '../provider/bookingHistoryProvider.dart'; // ← your provider
import 'package:url_launcher/url_launcher.dart';
class BookingHistoryDetailScreen extends StatefulWidget {
  final String id;

  const BookingHistoryDetailScreen({super.key, required this.id});

  @override
  State<BookingHistoryDetailScreen> createState() =>
      _BookingHistoryDetailScreenState();
}

class _BookingHistoryDetailScreenState
    extends State<BookingHistoryDetailScreen> {
  GoogleMapController? mapController;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  LatLng? pickupLatLng;
  LatLng? dropLatLng;

  // @override
  @override
  void initState() {
    super.initState();
    _loadBookingAndMap();
  }

  Future<void> _loadBookingAndMap() async {
    final provider = context.read<BookingHistoryProvider>();

    await provider.myBookingHistoryDetailApi(context: context, id: widget.id);

    final booking = provider.bookingHistoryDetailModel?.data;

    if (booking == null) return;

    double pickupLat =
        double.tryParse(booking.pickup?.lat?.toString() ?? '0') ?? 0;

    double pickupLng =
        double.tryParse(booking.pickup?.lng?.toString() ?? '0') ?? 0;

    double dropLat =
        double.tryParse(booking.dropoff?.lat?.toString() ?? '0') ?? 0;

    double dropLng =
        double.tryParse(booking.dropoff?.lng?.toString() ?? '0') ?? 0;

    pickupLatLng = LatLng(pickupLat, pickupLng);
    dropLatLng = LatLng(dropLat, dropLng);

    _setMarkers();
    _drawPolyline();
  }

  void _setMarkers() {
    markers.clear();

    if (pickupLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: pickupLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: const InfoWindow(title: "Pickup"),
        ),
      );
    }

    if (dropLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("drop"),
          position: dropLatLng!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: "Drop"),
        ),
      );
    }

    setState(() {});
  }

  void _drawPolyline() {
    if (pickupLatLng == null || dropLatLng == null) return;

    polylines.clear();

    polylines.add(
      Polyline(
        polylineId: const PolylineId("route"),
        points: [pickupLatLng!, dropLatLng!],
        width: 5,
        color: Colors.blue,
      ),
    );

    setState(() {});
    _fitMap();
  }

  void _fitMap() {
    if (mapController == null ||
        pickupLatLng == null ||
        dropLatLng == null) return;

    double minLat = pickupLatLng!.latitude < dropLatLng!.latitude
        ? pickupLatLng!.latitude
        : dropLatLng!.latitude;

    double maxLat = pickupLatLng!.latitude > dropLatLng!.latitude
        ? pickupLatLng!.latitude
        : dropLatLng!.latitude;

    double minLng = pickupLatLng!.longitude < dropLatLng!.longitude
        ? pickupLatLng!.longitude
        : dropLatLng!.longitude;

    double maxLng = pickupLatLng!.longitude > dropLatLng!.longitude
        ? pickupLatLng!.longitude
        : dropLatLng!.longitude;

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 80),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Booking Details", isBack: true),
      body: Consumer<BookingHistoryProvider>(
        builder: (context, provider, child) {
          final model = provider.bookingHistoryDetailModel;

          return Stack(
            children: [
              /// ✅ First time loading
              if (provider.isLoading && model == null)
                const Center(child: CircularProgressIndicator())
              else if (model == null)
                const Center(child: Text("Failed to load details"))
              else
                /// ✅ Main Content + Pull to refresh
                RefreshIndicator(
                  onRefresh: () async {
                    await provider.myBookingHistoryDetailApi(
                      context: context,
                      id: widget.id,
                      isRefresh: true,
                    );
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 220,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:
                                pickupLatLng == null
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        target: pickupLatLng!,
                                        zoom: 13,
                                      ),
                                      markers: markers,

                                      polylines: polylines,
                                      onMapCreated: (controller) {
                                        mapController = controller;
                                        if (pickupLatLng != null && dropLatLng != null) {
                                          _fitMap();
                                        }
                                      },
                                    ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Booking Header
                        _buildHeader(model.data!),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              /// 🔹 Booking Type Chip
                              if (model.data!.bookingType != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF03045E).withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    formatBookingType(model.data!.bookingType),
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF03045E),
                                    ),
                                  ),
                                ),

                              /// 🔹 OTP Section (Start + End)
                              Row(
                                children: [

                                  /// ✅ Start OTP
                                  _otpBox(
                                    context,
                                    label: "Start",
                               // otp: "4345"
                                 otp:model.data?.tripStartOtp ?? "1234",
                                  ),

                                  const SizedBox(width: 12),

                                  /// 🔥 Divider Line (Premium touch)
                                  Container(
                                    height: 30,
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),

                                  const SizedBox(width: 12),

                                  /// ✅ End OTP
                                  _otpBox(
                                    context,
                                    label: "End",
                                    otp:model.data?.tripEndOtp ?? "1234",
                                    // otp:booking.tripEndOtp ?? "4345",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        model.data!.driver != null &&
                            model.data!.vehicle != null &&
                            model.data!.assignedBy != null
                            ? Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0C000000),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// TITLE
                              const Text(
                                'Driver & Vehicle',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF94A3B8),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 10),

                              /// DRIVER ROW
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Driver Profile Image
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          model.data?.driver?.profilePic ?? "",
                                          width: 52,
                                          height: 52,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/icon/driverProfile.png',
                                              width: 52,
                                              height: 52,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),   SizedBox(height: 5,),    Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.star,
                                                size: 16, color: Colors.amber),
                                            const SizedBox(width: 4),
                                            Text(
                                              model.data?.driver?.rating?.toStringAsFixed(1) ?? "0.0",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),


                                  const SizedBox(width: 14),

                                  /// Driver & Vehicle Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        /// Name + Rating
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                model.data?.driver?.name ?? "Driver",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            /// Rating

                                          ],
                                        ),


                                        const SizedBox(height: 6),

                                        /// Phone Number
                                        Text(
                                          model.data?.driver?.phone ?? "",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        /// Vehicle Details - Better Layout
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${model.data?.vehicle?.brand ?? ""} ${model.data?.vehicle?.model ?? ""}",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "${model.data?.vehicle?.color ?? ""} • ${model.data?.vehicle?.carNumber ?? ""}",
                                                style: TextStyle(
                                                  fontSize: 13.5,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  /// Call Button
                                  InkWell(
                                    onTap: () {
                                      if (model.data?.driver?.phone != null) {
                                        launchUrl(Uri.parse("tel:${model.data!.driver!.phone}"));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.call,
                                        color: Colors.green,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                            : const SizedBox(),



                        const SizedBox(height: 20),

                        // Pickup & Dropoff
                        _buildLocationSection(model.data!),

                        const Divider(height: 32),

                        // Status & Dates
                        _buildStatusAndDates(model.data!),

                        const Divider(height: 32),

                        // Fare & Payment
                        _buildFareAndPayment(model.data!),

                        const SizedBox(height: 24),

                        // Extra Info (Segment, Region, Type, etc.)
                        _buildAdditionalInfo(model.data!),


                        const SizedBox(height: 20),
                        Row(
                            children: [

                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    showLoader(context);
                                    try {
                                      String url = "${ApiConstants.baseUrl}/${model.data?.invoice}";

                                      final dir = await getApplicationDocumentsDirectory();
                                      String fileName = model.data?.invoice?.split('/').last ?? "invoice.pdf";
                                      String filePath = "${dir.path}/$fileName";

                                      Dio dio = Dio();
                                      await dio.download(url, filePath);
                                      Navigator.pop(context);

                                      await OpenFilex.open(filePath);

                                    } catch (e) {
                                      print("Error: $e");
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFF1F5F9),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.download, size: 18,),
                                        SizedBox(width: 2,),

                                        Text(
                                          'Download Invoice',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: const Color(0xFF0F172A),
                                            fontSize: 14,
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontWeight: FontWeight.w600,
                                            height: 1.43,
                                          ),
                                        ),


                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              //
                              // SizedBox(width: 10),
                              //
                              // Expanded(
                              //   child: Container(
                              //     padding: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                              //
                              //     decoration: ShapeDecoration(
                              //       color: const Color(0xFFF1F5F9),
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(16),
                              //       ),
                              //     ),
                              //     child: Row(
                              //       children: [
                              //         Icon(Icons.help_outline, size: 18, ),
                              //         SizedBox(width: 2,),
                              //
                              //         Text(
                              //           'Get Support',
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //             color: const Color(0xFF0F172A),
                              //             fontSize: 14,
                              //             fontFamily: 'Plus Jakarta Sans',
                              //             fontWeight: FontWeight.w600,
                              //             height: 1.43,
                              //           ),
                              //         ),
                              //
                              //
                              //       ],
                              //     ),
                              //   ),
                              // ),

                            ]
                        ),        const SizedBox(height: 10),
                        // CustomButton(onTap: (){},title: "Rate Your Trip",)
                      ],
                    ),
                  ),
                ),

              /// ✅ Top Linear Loader (same as list screen)
              if (provider.isRefreshing)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2,),
                ),
            ],
          );
        },
      ),

    );
  }

  Widget _buildHeader(BookingHistoryDetailData booking) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Booking ID Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  "Booking ID: ${booking.bookingNumber ?? '—'}",
                  style: const TextStyle(
                    fontFamily: FontResource.plusJakartaSans,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 Status Badges Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [

              /// Trip Status
              _buildTripStatusBadge(
                booking.tripStatus ?? "unknown",
              ),

              /// Payment Status
              _buildPaymentStatusBadge(
                booking.paymentStatus ?? "unknown",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTripStatusBadge(String status) {
    Color bgColor, textColor;

    switch (status.toLowerCase()) {

      case "not_started":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;

      case "driver_enroute":
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;

      case "arrived":
        bgColor = Colors.teal.shade100;
        textColor = Colors.teal.shade800;
        break;

      case "in_progress":
        bgColor = Colors.indigo.shade100;
        textColor = Colors.indigo.shade800;
        break;

      case "completed":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;

      case "cancelled":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;

      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatTripStatus(status),
        style: TextStyle(
          fontFamily: FontResource.plusJakartaSans,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 13,
        ),
      ),
    );
  }
  String _formatTripStatus(String status) {
    switch (status.toLowerCase()) {
      case "not_started":
        return "NOT STARTED";
      case "driver_enroute":
        return "DRIVER ON THE WAY";
      case "arrived":
        return "DRIVER ARRIVED";
      case "in_progress":
        return "IN PROGRESS";
      case "completed":
        return "COMPLETED";
      case "cancelled":
        return "CANCELLED";
      default:
        return status.replaceAll("_", " ").toUpperCase();
    }
  }
  Widget _buildPaymentStatusBadge(String status) {
    Color bgColor, textColor;

    switch (status.toLowerCase()) {

    /// ✅ BOOKING STATUS
      case "completed":
      case "finished":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;

      case "cancelled":
      case "canceled":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;

      case "ongoing":
      case "inprogress":
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;

      case "not_started":
      case "upcoming":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        break;

    /// ✅ PAYMENT STATUS
      case "pending":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;

      case "paid":
      case "payment_done":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;

      case "failed":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade800;
        break;

      case "refunded":
        bgColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;

      default:
        bgColor = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _formatStatus(status),
        style: TextStyle(
          fontFamily: FontResource.plusJakartaSans,
          fontWeight: FontWeight.w600,
          color: textColor,
          fontSize: 13,
        ),
      ),
    );
  }
  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case "payment_done":
        return "PAID";
      case "not_started":
        return "UPCOMING";
      case "inprogress":
        return "ONGOING";
      default:
        return status.replaceAll("_", " ").toUpperCase();
    }
  }

  Widget _buildLocationSection(BookingHistoryDetailData booking) {
    print("${booking.pickup?.lat ?? "—"}");
    print("${booking.pickup?.lng ?? "—"}");
    print("${booking.dropoff?.lat ?? "—"}");
    print("${booking.dropoff?.lng ?? "—"}");
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.radio_button_checked,
              color: Color(0xFF03045E),
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Pickup",
                    style: TextStyle(
                      fontFamily: FontResource.plusJakartaSans,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.pickup?.address ?? "—",
                    style: const TextStyle(
                      fontFamily: FontResource.plusJakartaSans,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          child: Icon(
            Icons.arrow_downward_rounded,
            color: Colors.grey,
            size: 28,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.location_on, color: Color(0xFFD32F2F), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Drop-off",
                    style: TextStyle(
                      fontFamily: FontResource.plusJakartaSans,
                      fontWeight: FontWeight.w600,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.dropoff?.address ?? "—",
                    style: const TextStyle(
                      fontFamily: FontResource.plusJakartaSans,
                      fontSize: 13.5,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusAndDates(BookingHistoryDetailData booking) {
    final created = _formatDate(booking.createdAt);
    final paid = _formatDate(booking.paymentAt);
    final scheduled = _formatDate(booking.scheduledAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _infoRow("Booking Type", booking.bookingType?.toUpperCase() ?? "—"),
        const SizedBox(height: 12),
        _infoRow("Created", created),
        const SizedBox(height: 12),
        _infoRow("Scheduled", scheduled),
        const SizedBox(height: 12),
        _infoRow("Payment Time", paid),
        if (booking.estimatedKm != null || booking.estimatedMins != null) ...[
          const SizedBox(height: 12),
          _infoRow(
            "Estimated Distance",
            "${booking.estimatedKm?.toStringAsFixed(1) ?? '—'} km",
          ),
          const SizedBox(height: 8),
          _infoRow("Estimated Time", "${booking.estimatedMins ?? '—'} mins"),
        ],
      ],
    );
  }

  Widget _buildFareAndPayment(BookingHistoryDetailData booking) {
    final est = booking.pricingSnapshot;
    final fareBreak = booking.fareBreakup?.estimated;
    final payment = booking.payment;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Fare & Payment",
          style: TextStyle(
            fontFamily: FontResource.plusJakartaSans,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        _fareRow("Base Fare", fareBreak?.baseFare),
        _fareRow("Distance Charge", fareBreak?.distanceCharge),
        _fareRow("Time Charge", fareBreak?.timeCharge),
        _fareRow("Surge", fareBreak?.surgeCharge),
        _fareRow("Surge Charge Amount", fareBreak?.surchargeAmount),
        _fareRow("Airport Fare", fareBreak?.airportFare),
        _fareRow("Night Fare", fareBreak?.nightFare),
        _fareRow(
          "GST (${est?.gstPercent?.toStringAsFixed(1) ?? '5'}%)",
          fareBreak?.gstAmount,
        ),
        const Divider(),
        _fareRow("Total Fare", fareBreak?.totalFare, isBold: true),

        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Payment Status",
              style: TextStyle(
                fontFamily: FontResource.plusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              booking.paymentStatus?.toUpperCase() ?? "—",
              style: TextStyle(
                fontFamily: FontResource.plusJakartaSans,
                color:
                    booking.paymentStatus == "paid"
                        ? Colors.green
                        : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (payment != null) ...[
          _infoRow("Method", payment.method?.toUpperCase()),
          _infoRow(
            "Paid Amount",
            "₹ ${payment.paidAmount?.toStringAsFixed(2) ?? '—'}",
          ),
          _infoRow("Transaction ID", payment.gatewayRef ?? "—"),
        ],
      ],
    );
  }

  Widget _buildAdditionalInfo(BookingHistoryDetailData booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Additional Information",
          style: TextStyle(
            fontFamily: FontResource.plusJakartaSans,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        _infoRow("Segment", booking.segment?.name ?? "—"),
        _infoRow("Region", booking.region?.name ?? "—"),
        if (booking.intercity?.tripDays != null)
          _infoRow("Intercity Days", booking.intercity!.tripDays.toString()),
        if (booking.hourly?.extraHours != null ||
            booking.hourly?.extraKms != null) ...[
          _infoRow("Extra Hours", booking.hourly!.extraHours.toString()),
          _infoRow("Extra KMs", booking.hourly!.extraKms.toString()),
        ],
        if (booking.roundTrip?.returnStatus != null)
          _infoRow("Round Trip Return", booking.roundTrip!.returnStatus!),
      ],
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontResource.plusJakartaSans,
              color: Colors.grey[700],
              fontSize: 13.5,
            ),
          ),
          Text(
            value ?? "—",
            style: const TextStyle(
              fontFamily: FontResource.plusJakartaSans,
              fontWeight: FontWeight.w500,
              fontSize: 13.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fareRow(String label, double? amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: FontResource.plusJakartaSans,
              fontSize: 13.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount != null ? "₹ ${amount.toStringAsFixed(2)}" : "—",
            style: TextStyle(
              fontFamily: FontResource.plusJakartaSans,
              fontSize: 13.5,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: isBold ? const Color(0xFF03045E) : null,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "—";
    try {
      final date = DateTime.parse(iso).toLocal();
      return DateFormat("dd MMM yyyy • hh:mm a").format(date);
    } catch (e) {
      return iso.split('T')[0];
    }
  }

  String formatBookingType(String? type) {
    if (type == null || type.isEmpty) return "—";

    return type
        .replaceAll("_", " ")              // one_way → one way
        .split(" ")                        // ["one", "way"]
        .map((word) =>
    word[0].toUpperCase() + word.substring(1)) // One Way
        .join(" ");
  }
  Widget _otpBox(BuildContext context, {required String label, String? otp}) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "$label OTP",
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              otp ?? "----",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
          ],
        ),

        const SizedBox(width: 6),

        InkWell(
          onTap: () {
            if (otp == null) return;

            Clipboard.setData(ClipboardData(text: otp));

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("$label OTP Copied ✅"),
                duration: const Duration(seconds: 1),
              ),
            );
          },
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color(0xFF03045E).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.copy,
              size: 14,
              color: Color(0xFF03045E),
            ),
          ),
        ),
      ],
    );
  }
}
