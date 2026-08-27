import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/presentaion/booking/booking/ui/widget/bookingCard.dart';

import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';


import '../../../../util/color/app_colors.dart';
import '../../../../widget/customShimmer.dart';
import '../../../../widget/custom_appBar.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../bottomBar/bottomBar.dart';

import '../../../home/provider/homeProvider.dart';
import 'bookingSummery.dart';
import 'package:carousel_slider/carousel_slider.dart';

class VehicleSelectionScreen extends StatefulWidget {
  final String pickupLat;
  final String pickupLng;
  final String dropLat;
  final String dropLng;
  final String scheduledDate;
  final String scheduledTime;
  final String returnDate;
  final String returnTime;
  final String selectedHours;

  // final String bookedKms;
  final String tripDays;
  final String toCity;

  // pickupLat: "28.5355161",
  // pickupLng: "77.3910265",
  // dropLat: "28.6109026",
  // dropLng: "77.1149472",
  const VehicleSelectionScreen({
    super.key,
    required this.pickupLng,
    required this.pickupLat,
    required this.dropLng,
    required this.dropLat,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.returnDate,
    required this.returnTime,
    required this.selectedHours,
    required this.tripDays,
    required this.toCity,
  });

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  int selectedIndex = 0;
  int? selectedCardIndex;

  // final List<String> tabs = [
  //   "All",
  //   "Airport Cab",
  //   "Airport Shuttle",
  //   "Mann taj Express"
  // ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        if (homeProvider.oneWayBookingModel == null ||
            homeProvider.oneWayBookingModel!.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            isBack: true,
            // isBack: false,
            title: 'Choose Your Ride',
            onActionTap: () {
              print("Setting clicked");
            },
            // onBackTap: () {
            //   MainScreen.changeTab(context, 0); // ✅ FIXED
            // },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  bannerSection(
                    provider: homeProvider,
                    screenHeight: screenHeight,
                    screenWidth: screenWidth,
                  ),

                  const SizedBox(height: 15),

                  CustomText(
                    'Available Taxis',
                    size: 16,
                    weight: FontWeight.w700,
                    color: ColorResource.black,
                  ),

                  const SizedBox(height: 10),

                  /// TAB CONTENT
                  SizedBox(height: 10),

                  Builder(
                    builder: (context) {
                      switch (selectedIndex) {
                        case 0:
                          return Column(
                            children: List.generate(
                              homeProvider
                                  .oneWayBookingModel!
                                  .data!
                                  .segments!
                                  .length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    final segment =
                                        homeProvider
                                            .oneWayBookingModel!
                                            .data!
                                            .segments![index];

                                    // ✅ Only check distanceCharge for non-hourly bookings
                                    if (homeProvider
                                            .oneWayBookingModel!
                                            .data!
                                            .bookingType
                                            .toLowerCase() !=
                                        "hourly") {
                                      if (segment
                                              .fareBreakdown
                                              ?.distanceCharge ==
                                          null) {
                                        ToastHelper.show(
                                          context,
                                          message:
                                              "Pickup and drop-off location cannot be the same.",
                                          type: ToastType.warning,
                                        );
                                        return;
                                      }
                                    }

                                    // if (segment.fareBreakdown!.distanceCharge == null) {//yaar yha par ek issue hai ki ager booking type hourly hoga to distance charge null hi aayega hourly
                                    //   ToastHelper.show(context, message:  "Pickup and drop-off location cannot be the same.",type: ToastType.warning);
                                    //
                                    //   return; // ❗ stop further execution
                                    // }

                                    if (segment.estimatedFare == null) {
                                      ToastHelper.show(
                                        context,
                                        message: "${segment.message}",
                                        type: ToastType.warning,
                                      );

                                      return; // ❗ stop further execution
                                    }

                                    //////////////////////////////////////////iske upar ka code remove kar do ager warning hatan ahai to

                                    setState(() {
                                      selectedCardIndex = index;
                                    });

                                    print(
                                      "${homeProvider.oneWayBookingModel!.data!.bookingTime}",
                                    );
                                    String bookingTime =
                                        homeProvider
                                            .oneWayBookingModel!
                                            .data!
                                            .bookingTime
                                            .toString();

                                    DateTime parsedDate = DateTime.parse(
                                      bookingTime,
                                    );

                                    String formattedDate = DateFormat(
                                      "dd-MM-yyyy",
                                    ).format(parsedDate);
                                    String formattedTime = DateFormat(
                                      "hh:mm a",
                                    ).format(parsedDate);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            selectedCardIndex == index
                                                ? ColorResource.primary
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: BookingCard2(
                                      bookingType:
                                          homeProvider
                                              .oneWayBookingModel!
                                              .data!
                                              .bookingType,
                                      // image:
                                      //     homeProvider
                                      //         .oneWayBookingModel!
                                      //         .data!
                                      //         .segments![index]
                                      //         .segmentImage,
                                      title:
                                          homeProvider
                                              .oneWayBookingModel!
                                              .data!
                                              .segments![index]
                                              .segmentName,
                                      // subTitle:
                                      //     homeProvider
                                      //         .oneWayBookingModel!
                                      //         .data!
                                      //         .distanceText
                                      //         .toString(),
                                      finalPayableAmount:
                                          homeProvider
                                              .oneWayBookingModel!
                                              .data!
                                              .segments![index]
                                              .finalPayableAmount
                                              .toString(),
                                      totalAmount:
                                          homeProvider
                                              .oneWayBookingModel!
                                              .data!
                                              .segments![index]
                                              .estimatedFare
                                              .toString(),
                                      // walletDiscount:
                                      //     homeProvider
                                      //         .oneWayBookingModel!
                                      //         .data!
                                      //         .segments![index]
                                      //         .walletDiscount
                                      //         .toString(),
                                      //
                                      // away: "6 seats • 8 mins away",
                                      time:
                                          "ETA: ${homeProvider.oneWayBookingModel!.data!.durationText} • ${homeProvider.oneWayBookingModel!.data!.distanceText} to destination ",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );

                        case 1:
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CustomText(
                                "Airport Cab Coming Soon",
                                size: 18,
                                weight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          );

                        case 2:
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CustomText(
                                "Airport Shuttle Coming Soon",
                                size: 18,
                                weight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          );

                        case 3:
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CustomText(
                                "Mann Taj Express Coming Soon",
                                size: 18,
                                weight: FontWeight.w700,
                                color: Colors.grey,
                              ),
                            ),
                          );

                        default:
                          return Container();
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                  homeProvider
                              .oneWayBookingModel
                              ?.data
                              ?.walletBonusRestriction
                              ?.message ==
                          null
                      ? SizedBox()
                      : Text(
                        "Note: ${homeProvider.oneWayBookingModel!.data!.walletBonusRestriction!.message}",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  const SizedBox(height: 20),

                  /// PAYMENT ROW
                  const SizedBox(height: 25),

                  /// BUTTON

                  // CustomButton(
                  //     title: 'Book Comfort Sedan',
                  //     backgroundColor: ColorResource.buttonBackground,
                  //     onTap: () {
                  //
                  //     })
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: CustomButton(
                title: 'Continue',
                backgroundColor:
                    selectedCardIndex == null
                        ? Colors.grey
                        : ColorResource.buttonBackground,
                onTap:
                    selectedCardIndex == null
                        ? null
                        : () {
                          final suggestion =
                              homeProvider
                                  .oneWayBookingModel!
                                  .data!
                                  .intercitySuggestion;

                          /// ✅ CASE 1: If suggestion exists → STOP navigation + show message
                          if (suggestion != null) {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        /// TOP ICON
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withOpacity(
                                              0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.info_outline,
                                            color: Colors.orange,
                                            size: 30,
                                          ),
                                        ),

                                        const SizedBox(height: 15),

                                        /// TITLE
                                        Text(
                                          "Booking Suggestion",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        /// MESSAGE
                                        Text(
                                          suggestion.message ??
                                              "Something went wrong",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),

                                        const SizedBox(height: 15),

                                        /// SUGGESTED TYPE CARD
                                        Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.local_taxi,
                                                color: Colors.green,
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text(
                                                  suggestion
                                                          .suggestedBookingType ??
                                                      "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        /// REASON
                                        Text(
                                          suggestion.reason ?? "",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),

                                        const SizedBox(height: 20),

                                        /// BUTTONS
                                        Row(
                                          children: [
                                            /// CANCEL
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.pop(context),
                                                child: Text("Cancel"),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            /// ACCEPT BUTTON
                                            Expanded(
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorResource
                                                          .buttonBackground,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  final homeProvider = Provider.of<HomeProvider>(context, listen: false);
                                                  homeProvider.applyIntercitySuggestion();   // ← Important

                                                  navPushReplace(
                                                    context: context,
                                                    action: MainScreen(currentIndex: 0),
                                                  );
                                                },
                                                // onPressed: () {
                                                //   navPushReplace(
                                                //     context: context,
                                                //     action: MainScreen(
                                                //       currentIndex: 0,
                                                //     ),
                                                //   );
                                                //   // Navigator.pop(context);
                                                //
                                                //   /// 👉 Yaha tum chahe to suggested booking type apply kar sakte ho
                                                // },
                                                child: Text("OK"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );

                            return; // ❌ STOP navigation
                          }

                          /// ✅ CASE 2: If NULL → Continue normally

                          int index = selectedCardIndex!;

                          String bookingTime =
                              homeProvider.oneWayBookingModel!.data!.bookingTime
                                  .toString();

                          DateTime parsedDate = DateTime.parse(bookingTime);

                          String formattedDate = DateFormat(
                            "dd-MM-yyyy",
                          ).format(parsedDate);

                          String formattedTime = DateFormat(
                            "hh:mm a",
                          ).format(parsedDate);
                          final roundTrip =
                              homeProvider
                                  .oneWayBookingModel
                                  ?.data
                                  ?.roundTripEffective;
                          navPush(
                            context: context,
                            action: BookingSummary(
                              nightCount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .nightCount
                                      .toString(),
                              dateApi: homeProvider.selectedApiDate,
                              timeApi: homeProvider.selectedApiTime,
                              returnDateApi: homeProvider.selectedReturnApiDate,
                              returnTimeApi: homeProvider.selectedReturnApiTime,
                              isAirportTrip:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .isAirportTrip,
                              isDropAirport:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .isDropAirport,
                              isGrayMatter:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .isGrayMatter,
                              isPickupAirport:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .isPickupAirport,
                              estimatedTimeContent:
                                  "ETA: ${homeProvider.oneWayBookingModel!.data!.durationText} • ${homeProvider.oneWayBookingModel!.data!.distanceText} to destination ",
                              estimatedDistance:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .distanceText,
                              estimatedTime:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .durationText,
                              airportFare:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments!
                                      .first
                                      .fareBreakdown!
                                      .airportFare
                                      .toString(),
                              nightFare:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments!
                                      .first
                                      .fareBreakdown!
                                      .nightFare
                                      .toString(),
                              surchargeAmount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments!
                                      .first
                                      .fareBreakdown!
                                      .surchargeAmount
                                      .toString(),
                              mcdTollCharge:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments!
                                      .first
                                      .fareBreakdown!
                                      .mcdTollCharge
                                      .toString(),
                              bookingType:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .bookingType,
                              scheduledTime: widget.scheduledTime,
                              scheduledDate: widget.scheduledDate,

                              pickupLat: widget.pickupLat,
                              pickupLng: widget.pickupLng,
                              dropLat: widget.dropLat,
                              dropLng: widget.dropLng,
                              surgeMultiplier: "null",
                              surgeLabel: "null",
                              gatewayRef: "UPI_TXN_20241024_001",
                              regionId:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .regionId
                                      .toString(),
                              segmentId:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .segmentId
                                      .toString(),
                              tollAmount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .tollAmount
                                      .toString(),
                              polyline: "Poly line is static data",
                              // polyline: homeProvider.oneWayBookingModel!.data!
                              //     .polyline
                              //     .toString(),
                              paymentMethod: "upi",
                              finalPayableAmount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .finalPayableAmount
                                      .toString(),
                              walletDiscount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .walletDiscount
                                      .toString(),
                              estimatedFare:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .estimatedFare
                                      .toString(),
                              estimatedKm:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .distanceKm
                                      .toString(),
                              estimatedMins:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .durationMins
                                      .toString(),
                              timeType:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .timeType
                                      .toString(),

                              vehicleImage:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .segmentImage
                                      .toString(),
                              away: "6 seats • 8 mins away",
                              baseFare:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .baseFare
                                      .toString(),
                              cancellationFee:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .cancellationFee
                                      .toString(),
                              date: formattedDate,
                              distanceCharge:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .distanceCharge
                                      .toString(),
                              dropLocation:
                                  homeProvider.oneWayBookingModel!.data!.dropoff
                                      .toString(),
                              gstAmount:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .gstAmount
                                      .toString(),
                              gstPercent:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .gstPercent
                                      .toString(),
                              minFareApplied:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .minFareApplied
                                      .toString(),
                              pickUpLocation:
                                  homeProvider.oneWayBookingModel!.data!.pickup
                                      .toString(),
                              segmentName:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .segmentName
                                      .toString(),
                              subtotal:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .subtotal
                                      .toString(),
                              surgeCharge:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .surgeCharge
                                      .toString(),
                              time: formattedTime,
                              timeCharge:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .timeCharge
                                      .toString(),
                              tollCharge:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .tollCharge
                                      .toString(),
                              totalFare:
                                  homeProvider
                                      .oneWayBookingModel!
                                      .data!
                                      .segments![index]
                                      .fareBreakdown!
                                      .totalFare
                                      .toString(),
                              vehicleName: "BMW X1 Series",
                              bookedKms: "40",
                              returnDate: widget.returnDate,
                              returnTime: widget.returnTime,
                              selectedHours: widget.selectedHours,
                              toCity: widget.toCity,
                              tripDays: widget.tripDays,
                              //New Added section ok
                              effectiveDistanceKm:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments?[index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.effectiveDistanceKm
                                      .toString() ??
                                  "",
                              effectiveTotalMins:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments?[index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.effectiveTotalMins
                                      .toString() ??
                                  "",
                              idleMinsBetweenLegs:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments?[index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.idleMinsBetweenLegs
                                      .toString() ??
                                  "",
                              returnTravelMins:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments?[index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.returnTravelMins
                                      .toString() ??
                                  "",
                              oneWayDistanceKm:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments?[index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.oneWayDistanceKm
                                      .toString() ??
                                  "",
                              oneWayTravelMins:
                                  homeProvider
                                      .oneWayBookingModel
                                      ?.data
                                      ?.segments![index]
                                      .fareBreakdown
                                      ?.roundTripDetail
                                      ?.oneWayTravelMins
                                      .toString() ??
                                  "",
                            ),
                          );
                        },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget bannerSection({
    required HomeProvider provider,
    required double screenHeight,
    required double screenWidth,
  }) {
    /// Loader
    if (provider.bannerModel == null) {
      return CustomShimmer(
        width: screenWidth,
        height: screenHeight * 0.18875,
        radius: 14,
      );
    }

    /// No Data
    if (provider.bannerModel!.data == null ||
        provider.bannerModel!.data!.isEmpty) {
      return SizedBox(
        height: screenHeight * 0.18875,
        child: const Center(child: Text("No Data Found")),
      );
    }

    /// Carousel Banner
    return CarouselSlider(
      options: CarouselOptions(
        height: screenHeight * 0.18875,
        viewportFraction: 1,
        autoPlay: true,
      ),
      items:
          provider.bannerModel!.data!.map((banner) {
            return Image.network(
              banner.image.toString(),
              height: screenHeight * 0.18875,
              width: screenWidth,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/bannerError.jpg",
                  height: screenHeight * 0.18875,
                  width: screenWidth,
                );
              },
            );
          }).toList(),
    );
  }

  /// TAXI LIST

  /// BOOKING CARD
}
