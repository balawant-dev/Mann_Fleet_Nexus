import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/booking/booking/ui/widget/bookingProcessingWidget.dart';

import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../../../apiservice/payment/paymentService.dart';
import '../../../../apiservice/services/appConfigService.dart';
import '../../../../util/FontResource/FontResource.dart';
import '../../../../util/color/app_colors.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';

import '../../../bottomBar/bottomBar.dart';
import '../../../cms/ui/cMSContentScreen.dart';
import '../../../profile/model/getProfileModel.dart';
import '../../../profile/viewModel/profileViewModel.dart';

import '../provider/bookingSummaryProvider.dart';

class BookingSummary extends StatefulWidget {
  final String segmentName;
  final String vehicleName;
  final String mcdTollCharge;
  final String nightCount;
  final String bookingType;
  final String away;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String dateApi;
  final String returnDateApi;
  final String time;
  final String timeApi;
  final String returnTimeApi;
  final String baseFare;
  final String distanceCharge;
  final String timeCharge;
  final String surgeCharge;
  final String subtotal;
  final String gstPercent;
  final String gstAmount;
  final String tollCharge;
  final String totalFare;
  final String finalPayableAmount;
  final String walletDiscount;
  final String minFareApplied;
  final String cancellationFee;
  final String surchargeAmount;
  final String vehicleImage;
  final String pickupLat;
  final String pickupLng;
  final String dropLat;
  final String dropLng;
  final String surgeMultiplier;
  final String surgeLabel;
  final String gatewayRef;
  final String tollAmount;
  final String nightFare;
  final String polyline;
  final String paymentMethod;
  final String estimatedFare;
  final String estimatedKm;
  final String estimatedMins;
  final String timeType;
  final String segmentId;
  final String regionId;
  final String estimatedDistance;
  final String estimatedTime;
  final String estimatedTimeContent;
  final String scheduledDate;
  final String scheduledTime;
  final String returnDate;
  final String returnTime;
  final String selectedHours;
  final String bookedKms;
  final String tripDays;
  final String toCity;
  final String airportFare;
  final bool isPickupAirport;
  final bool isDropAirport;
  final bool isAirportTrip;
  final bool isGrayMatter;
  //New sectionaad
  final String? effectiveDistanceKm;
  final String? effectiveTotalMins;
  final String? idleMinsBetweenLegs;
  final String? returnTravelMins;
  final String? oneWayDistanceKm;
  final String? oneWayTravelMins;

  const BookingSummary({
    super.key,
    required this.away,
    required this.returnDateApi,
    required this.nightCount,
    required this.returnTimeApi,
    required this.time,
    required this.timeApi,
    required this.date,
    required this.dateApi,
    required this.airportFare,
    required this.baseFare,
    required this.bookingType,
    required this.cancellationFee,
    required this.walletDiscount,
    required this.distanceCharge,
    required this.dropLocation,
    required this.gstAmount,
    required this.nightFare,
    required this.finalPayableAmount,
    required this.gstPercent,
    required this.minFareApplied,
    required this.pickUpLocation,
    required this.segmentName,
    required this.surgeCharge,
    required this.surchargeAmount,
    required this.subtotal,
    required this.timeCharge,
    required this.tollCharge,
    required this.totalFare,
    required this.vehicleName,
    required this.vehicleImage,
    required this.regionId,
    required this.segmentId,
    required this.estimatedDistance,
    required this.mcdTollCharge,
    required this.estimatedTime,
    required this.estimatedTimeContent,
    required this.isAirportTrip,
    required this.isDropAirport,
    required this.isGrayMatter,
    required this.isPickupAirport,

    //////////////////
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.surgeMultiplier,
    required this.surgeLabel,
    required this.gatewayRef,
    required this.tollAmount,
    required this.polyline,
    required this.paymentMethod,
    required this.estimatedFare,
    required this.estimatedKm,
    required this.estimatedMins,
    required this.timeType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.returnDate,
    required this.returnTime,
    required this.bookedKms,
    required this.selectedHours,
    required this.tripDays,
    required this.toCity,

    this.effectiveDistanceKm,
    this.effectiveTotalMins,
    this.idleMinsBetweenLegs,
    this.returnTravelMins,
    this.oneWayDistanceKm,
    this.oneWayTravelMins,
  });

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  late TextEditingController travellerEmail;
  late TextEditingController travellerName;
  late TextEditingController travellerPhone;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late RazorpayService razorpayService;
  String travellerType = "self";

  @override
  void initState() {
    super.initState();

    print(
      ">>>>>>>>>>>>>>>oneWayDistanceKm>>>>>>>${widget.oneWayTravelMins} "
          ">>>>>>>>>>oneWayDistanceKm>>${widget.oneWayDistanceKm}",
    );

    travellerEmail = TextEditingController();
    travellerName = TextEditingController();
    travellerPhone = TextEditingController();

    razorpayService = RazorpayService();

    razorpayService.onSuccess = (response) async {
      print("Payment Success: ${response.paymentId}");
      await callBookingApi();
    };

    razorpayService.onError = (response) {
      print("Payment Failed: ${response.message}");
    };

    razorpayService.onExternalWallet = (response) {
      print("External Wallet: ${response.walletName}");
    };

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final pro = Provider.of<BookingSummaryProvider>(
        context,
        listen: false,
      );

      // Coupon reset
      pro.removeCoupon();

      // Initial fare API
      initSummary();

      // Profile API
      final profileProvider = Provider.of<ProfileDetailViewModel>(
        context,
        listen: false,
      );

      profileProvider.getProfileApi(context: context).then((_) {
        if (!mounted) return;

        _fillInitialData(profileProvider.getProfileModel);

        if (travellerPhone.text.length == 10) {
          Provider.of<BookingSummaryProvider>(
            context,
            listen: false,
          ).checkVerification(
            travellerPhone.text,
            context,
          );
        }
      });
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   print(
  //     ">>>>>>>>>>>>>>>oneWayDistanceKm>>>>>>>${widget.oneWayTravelMins} >>>>>>>>>>oneWayDistanceKm>>${widget.oneWayDistanceKm}",
  //   );
  //   final pro = Provider.of<BookingSummaryProvider>(context, listen: false);
  //   pro.removeCoupon();
  //   initSummary();
  //   travellerEmail = TextEditingController();
  //   travellerName = TextEditingController();
  //   travellerPhone = TextEditingController();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final provider = Provider.of<ProfileDetailViewModel>(
  //       context,
  //       listen: false,
  //     );
  //     provider.getProfileApi(context: context).then((_) {
  //       _fillInitialData(provider.getProfileModel);
  //       if (travellerPhone.text.length == 10) {
  //         Provider.of<BookingSummaryProvider>(
  //           context,
  //           listen: false,
  //         ).checkVerification(travellerPhone.text, context);
  //       }
  //     });
  //   });
  //
  //   razorpayService = RazorpayService();
  //
  //   razorpayService.onSuccess = (response) async {
  //     print("Payment Success: ${response.paymentId}");
  //
  //     // 👉 Payment success ke baad API call
  //     await callBookingApi();
  //   };
  //
  //   razorpayService.onError = (response) {
  //     print("Payment Failed: ${response.message}");
  //   };
  //
  //   razorpayService.onExternalWallet = (response) {
  //     print("External Wallet: ${response.walletName}");
  //   };
  // }

  void _fillInitialData(GetProfileModel? model) {
    if (model?.data?.user == null) return;

    final user = model!.data!.user!;

    travellerName.text = user.name ?? '';
    travellerEmail.text = user.email ?? '';

    travellerPhone.text = user.mobile ?? '';

    setState(() {});
  }

  void _callFareSummaryTabApi() {
    final pro = Provider.of<BookingSummaryProvider>(context, listen: false);


    pro.fareSummaryTabApi(
      context: context,
      date: widget.dateApi,
      travellerPhone: travellerPhone.text,
      time: widget.timeApi,
      pickupLng: widget.pickupLng,
      pickupLat: widget.pickupLat,
      pickupAddress: widget.pickUpLocation,
      bookingType: widget.bookingType,
      dropoffAddress: widget.dropLocation,
      dropLng: widget.dropLng,
      dropLat: widget.dropLat,
      returnDate: widget.returnDateApi,
      returnTime: widget.returnTimeApi,
      selectedHours: widget.selectedHours,
      tripDays: widget.tripDays,
      segmentId: widget.segmentId,
      couponCode: pro.appliedCouponCode, // optional
    );
  }

  initSummary() {
    Provider.of<BookingSummaryProvider>(context, listen: false).fareSummaryApi(
      context: context,
      date: widget.dateApi,
      travellerPhone: travellerPhone.text,
      time: widget.timeApi,
      pickupLng: widget.pickupLng,
      pickupLat: widget.pickupLat,
      pickupAddress: widget.pickUpLocation,
      bookingType: widget.bookingType,
      dropoffAddress: widget.dropLocation,
      dropLng: widget.dropLng,
      dropLat: widget.dropLat,
      returnDate: widget.returnDateApi,
      returnTime: widget.returnTimeApi,
      selectedHours: widget.selectedHours,
      tripDays: widget.tripDays,
      segmentId: widget.segmentId,
    );
  }

  void _refreshFareSummaryWithCoupon(String couponCode) {
    Provider.of<BookingSummaryProvider>(context, listen: false).fareSummaryApi(
      context: context,
      travellerPhone: travellerPhone.text,
      date: widget.dateApi,
      time: widget.timeApi,
      pickupLng: widget.pickupLng,
      pickupLat: widget.pickupLat,
      pickupAddress: widget.pickUpLocation,
      bookingType: widget.bookingType,
      dropoffAddress: widget.dropLocation,
      dropLng: widget.dropLng,
      dropLat: widget.dropLat,
      returnDate: widget.returnDateApi,
      returnTime: widget.returnTimeApi,
      selectedHours: widget.selectedHours,
      tripDays: widget.tripDays,
      segmentId: widget.segmentId,
      couponCode: couponCode,
    );
  }

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }

  Future<void> callBookingApi() async {
    final pro = Provider.of<BookingSummaryProvider>(context, listen: false);
    showBookingBottomSheet(context);

    print(
      "this mann==================+++++++++++++++++effectiveDistanceKm${widget.effectiveDistanceKm}  and effectiveDistanceKm ${widget.effectiveDistanceKm} and idleMinsBetweenLegs ${widget.idleMinsBetweenLegs}  and returnTravelMins ${widget.returnTravelMins}",
    );
    final summaryBreakDown = pro.fareSummaryModel?.data?.fareBreakdown;
    print("widget.nightFare:${widget.nightFare}==================");
    // showLoader(context);

    await pro.createOneWayBooking(
      mcdTollCharge: widget.mcdTollCharge,
      nightCount: widget.nightCount,
      surchargeAmount: widget.surchargeAmount,
      nightFare: summaryBreakDown?.nightFare.toString() ?? "0.0",

      // nightFare: widget.nightFare,
      airportFare: widget.airportFare,
      isPickupAirport: widget.isPickupAirport,
      isDropAirport: widget.isDropAirport,
      isAirportTrip: widget.isAirportTrip,
      isGrayMatter: widget.isGrayMatter,
      travellerEmail: travellerEmail.text,
      travellerName: travellerName.text,
      travellerPhone: travellerPhone.text,
      context: context,
      segmentId: widget.segmentId,
      regionId: widget.regionId,
      bookingType: widget.bookingType,
      // bookingType: "one_way",
      pickupAddress: widget.pickUpLocation,
      dropoffAddress: widget.dropLocation,
      pickupLat: widget.pickupLat,
      pickupLng: widget.pickupLng,
      dropLat: widget.dropLat,
      dropLng: widget.dropLng,
      surgeMultiplier: widget.surgeMultiplier,
      surgeLabel: widget.surgeLabel,
      gatewayRef: "UPI_TXN_20241024_001",
      tollAmount: widget.tollAmount,
      polyline: widget.polyline,
      paymentMethod: "upi",
      estimatedFare: widget.estimatedFare,
      estimatedKm: widget.estimatedKm,
      estimatedMins: widget.estimatedMins,
      timeCharge: widget.timeCharge,
      // totalFare: widget.totalFare,
      totalFare: summaryBreakDown?.finalPayableAmount.toString() ?? "0.0",
      // totalFare: widget.finalPayableAmount,
      timeType: widget.timeType,
      surgeCharge: widget.surgeCharge,
      subtotal: summaryBreakDown?.subtotal.toString() ?? "0.0",
      // subtotal: widget.subtotal,
      baseFare: widget.baseFare,
      distanceCharge: widget.distanceCharge,
      // gstAmount: widget.gstAmount,
      gstAmount: summaryBreakDown?.gstAmount.toString() ?? "0.0",
      gstPercent: widget.gstPercent,
      tollCharge: widget.tollCharge,
      scheduledDate: widget.scheduledDate,
      scheduledTime: widget.scheduledTime,
      returnDate: widget.returnDate,
      // scheduledTime:  "23:00",
      bookedKms: widget.bookedKms,
      returnTime: widget.returnTime,
      selectedHours: widget.selectedHours,
      tripDays: widget.tripDays,
      toCity: widget.toCity,
      //New Added
      effectiveDistanceKm: widget.effectiveDistanceKm,
      effectiveTotalMins: widget.effectiveTotalMins,
      idleMinsBetweenLegs: widget.idleMinsBetweenLegs,
      returnTravelMins: widget.returnTravelMins,
      oneWayTravelMins: widget.oneWayTravelMins,
      oneWayDistanceKm: widget.oneWayTravelMins,

      // scheduledTime:  widget.scheduledTime
    );

    /// STEP 2: Show SUCCESS animation

    bookingKey.currentState?.showPayment();

    /// ✅ IMPORTANT: wait 3 seconds
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pop(context); // close loader

    /// STEP 3: Close BottomSheet
    // Navigator.pop(context);
    final data = pro.createBookingSummeryModel?.data;
    print("<<<<<<<<<<<<<<<<Balawant kumar>>>>>>>>>>>>>>>>>>>>>>");
    print(
      "<<<<<<<<<<<<<<<<Enable of payment getway flow check 1>>>>>>>>>>>>>>>>>>>>>>",
    );

    final double payableAmount =
        double.tryParse(
          summaryBreakDown?.finalPayableAmount.toString() ?? "0.0",
        ) ??
        0.0;
    if (payableAmount <= 0) {
      bookingKey.currentState?.showSuccess();

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context); // close bottom sheet

      ToastHelper.show(
        context,
        message: "Booking Confirmed",
        type: ToastType.success,
      );

      navPush(context: context, action: MainScreen(currentIndex: 1));

      return; // 🚀 Razorpay flow skip
    }

    print("<<<<<<<<<<<<<<<< check isCorporate booking 1>>>>>>>>>>>>>>>>>>>>>>");

    if (pro.createBookingSummeryModel?.data?.isCorporate == true) {
      navPush(context: context, action: MainScreen(currentIndex: 1));
      print(
        "<<<<<<<<<<<<<<<< check isCorporate booking true>>>>>>>>>>>>>>>>>>>>>>",
      );
    }
    print("<<<<<<<<<<<<<<<< check isCorporate booking 2>>>>>>>>>>>>>>>>>>>>>>");
    print(
      "<<<<<<<<<<<<<<<<Enable of payment getway flow check 2>>>>>>>>>>>>>>>>>>>>>>",
    );
    // print("<<<<<<<<<<<<<<<<<<<<<${pro.purchaseShuttlePassModel?.message}>>>>>>>>>>>>>>>>>>>>>");
    if (data?.razorpay == null) {
      ToastHelper.show(
        context,
        message:
            pro.createBookingSummeryModel?.message ?? "Payment data not found",
        type: ToastType.error,
      );
      return;
    }
    final razorKey = await AppConfigService.getRazorKey();

    /// 🔥 Razorpay values
    String orderId = data!.razorpay!.orderId ?? "";
    int amount = data.razorpay!.amount ?? 0;
    String key = data.razorpay!.key ?? "";
    print("ORDER ID: $orderId");
    print("AMOUNT: $amount");
    print("Razor Pay Key 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑: $razorKey");

    /// ✅ अब Razorpay open करो
    razorpayService.openCheckoutWithOrderId(
      amount: amount,
      orderId: orderId,
      // key: key,
      key: razorKey,
      name: "Mann Fleet",
      description: "Cab Booking Payment",
      contact: travellerPhone.text,
      email: travellerEmail.text,
    );
    // Navigator.pop(context);

    // ToastHelper.show(
    //   context,
    //   message: "Booking Created Successfully",
    //   type: ToastType.success,
    // );
    razorpayService.onSuccess = (response) async {
      print("Payment Success: ${response.paymentId}");

      /// ✅ Show success UI
      bookingKey.currentState?.showSuccess();

      await Future.delayed(const Duration(seconds: 1));

      Navigator.pop(context); // close bottom sheet

      ToastHelper.show(
        context,
        message: "Booking Confirmed",
        type: ToastType.success,
      );
      // await FacebookEventService.instance.logBooking(
      //   amount: amount,
      // );

      navPush(context: context, action: MainScreen(currentIndex: 1));
    };

    // navPush(context: context, action: MainScreen(currentIndex: 1,));
  }

  Future<void> pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input,
    );

    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void showBookingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return BookingProcessingWidget(key: bookingKey);
      },
    );
  }

  double finalTotalBotton = 0.0;
  @override
  Widget build(BuildContext context) {
    print("estimatedTime>>>>>>>>>>>>>>>>>>>>>>>>>>${widget.estimatedTime}");
    String dateText =
        selectedDate == null
            ? "Select Date"
            : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}";

    String timeText =
        selectedTime == null ? "Select Time" : selectedTime!.format(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Booking Summary', isBack: true),
      body: Consumer<BookingSummaryProvider>(
        builder: (context, pro, child) {
          final summaryBreakDown = pro.fareSummaryModel?.data?.fareBreakdown;
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bookingCard(
                        image: widget.vehicleImage,
                        title: widget.vehicleName,
                        estimatedTime:
                            widget.bookingType == "hourly"
                                ? "Note: Charges depend on vehicle type and selected hours."
                                : widget.estimatedTimeContent,
                        ac: 'AC',
                        seat: "4 Seats",
                        sugementName: widget.segmentName,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'TRIP DETAILS',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14,
                          fontFamily: FontResource.plusJakartaSans,
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                          letterSpacing: 1.40,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFF1F5F9),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.bookingType == "hourly"
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "PICKUP LOCATION",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontFamily:
                                            FontResource.plusJakartaSans,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      widget.pickUpLocation,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily:
                                            FontResource.plusJakartaSans,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                )
                                : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.purple,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                          width: 2,
                                          height: 60,
                                          color: Colors.grey.shade300,
                                        ),
                                        Container(
                                          width: 12,
                                          height: 12,
                                          decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "PICKUP LOCATION",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontFamily:
                                                  FontResource.plusJakartaSans,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          SizedBox(height: 5),

                                          Text(
                                            widget.pickUpLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  FontResource.plusJakartaSans,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          SizedBox(height: 20),

                                          Text(
                                            "DROP-OFF LOCATION",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontFamily:
                                                  FontResource.plusJakartaSans,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),

                                          SizedBox(height: 6),

                                          Text(
                                            widget.dropLocation,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily:
                                                  FontResource.plusJakartaSans,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                            const SizedBox(height: 20),

                            const Divider(),
                            const SizedBox(height: 20),

                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : Row(
                                  children: [
                                    /// 📏 Distance
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFF1F5F9),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.blue
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons.route,
                                                size: 18,
                                                color: Colors.blue,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Distance",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  widget.bookingType ==
                                                          "round_trip"
                                                      ? "${widget.effectiveDistanceKm} Km"
                                                      : "${widget.estimatedDistance}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    /// ⏱ Time
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFF1F5F9),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 18,
                                              backgroundColor: Colors.orange
                                                  .withOpacity(0.1),
                                              child: const Icon(
                                                Icons.access_time,
                                                size: 18,
                                                color: Colors.orange,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Estimated Time",

                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  widget.bookingType ==
                                                          "round_trip"
                                                      ? "${widget.effectiveTotalMins} Min"
                                                      : "${widget.estimatedTime}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : const SizedBox(height: 20),

                            Row(
                              children: [
                                /// 📅 DATE
                                Expanded(
                                  child: GestureDetector(
                                    // onTap: pickDate,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: const Color(0xFFF1F5F9),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          /// Icon
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF03045E,
                                              ).withOpacity(0.08),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.calendar_month,
                                              size: 18,
                                              color: Color(0xFF03045E),
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          /// Text
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Pickup Date",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                widget.date,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                /// ⏱ TIME
                                Expanded(
                                  child: GestureDetector(
                                    // onTap: pickTime,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: const Color(0xFFF1F5F9),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          /// Icon
                                          Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.deepPurpleAccent
                                                  .withOpacity(0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.access_time,
                                              size: 18,
                                              color: Colors.deepPurpleAccent,
                                            ),
                                          ),

                                          const SizedBox(width: 8),

                                          /// Text
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Pickup Time",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                widget.time,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (widget.bookingType == "round_trip") ...[
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  /// 📅 DATE
                                  Expanded(
                                    child: GestureDetector(
                                      // onTap: pickDate,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFF1F5F9),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            /// Icon
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.pink.withOpacity(
                                                  0.1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.calendar_month,
                                                size: 18,
                                                color: Colors.pink,
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            /// Text
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Return Date",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  widget.returnDate,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  /// ⏱ TIME
                                  Expanded(
                                    child: GestureDetector(
                                      // onTap: pickTime,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(
                                            14,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFF1F5F9),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            /// Icon
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.green.withOpacity(
                                                  0.1,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.access_time,
                                                size: 18,
                                                color: Colors.green,
                                              ),
                                            ),

                                            const SizedBox(width: 8),

                                            /// Text
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  "Return Time",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  widget.returnTime,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // SizedBox(height: 10),

                      /// 👤 TRAVELER INFO TITLE
                      Text(
                        'TRAVELER DETAILS',
                        style: TextStyle(
                          color: const Color(0xFF94A3B8),
                          fontSize: 14,
                          fontFamily: FontResource.plusJakartaSans,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),

                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              value: "self",
                              activeColor: ColorResource.primary,
                              groupValue: travellerType,
                              title: const Text("Self"),
                              onChanged: (value) {
                                setState(() {
                                  travellerType = value!;

                                  // Profile data refill
                                  final provider =
                                      Provider.of<ProfileDetailViewModel>(
                                        context,
                                        listen: false,
                                      );

                                  _fillInitialData(provider.getProfileModel);
                                });
                              },
                            ),
                          ),

                          Expanded(
                            child: RadioListTile<String>(
                              activeColor: ColorResource.primary,
                              contentPadding: EdgeInsets.zero,
                              value: "other",
                              groupValue: travellerType,
                              title: const Text("Others"),
                              onChanged: (value) {
                                setState(() {
                                  travellerType = value!;

                                  // Clear all fields
                                  travellerName.clear();
                                  travellerEmail.clear();
                                  travellerPhone.clear();

                                  final bookingProvider =
                                      Provider.of<BookingSummaryProvider>(
                                        context,
                                        listen: false,
                                      );

                                  bookingProvider.isVerified = false;
                                  bookingProvider.isOtpSent = false;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      /// 👤 TRAVELER CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// NAME
                            _inputField(
                              readOnly: travellerType == "self" ? true : false,
                              controller: travellerName,
                              hint: "Enter Full Name",
                              icon: Icons.person,
                            ),

                            const SizedBox(height: 12),

                            /// EMAIL
                            _inputField(
                              readOnly: travellerType == "self" ? true : false,
                              controller: travellerEmail,
                              hint: "Enter Email",
                              icon: Icons.email,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child:
                                  /// PHONE
                                  _inputField(
                                    readOnly: false,
                                    controller: travellerPhone,
                                    hint: "Enter Mobile Number",
                                    icon: Icons.phone,
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    onChanged: (value) {
                                      if (value.length == 10) {
                                        pro
                                            .checkVerification(value, context)
                                            .then((_) {
                                              if (pro.isVerified) {
                                                _callFareSummaryTabApi(); // ← here
                                              }
                                            });
                                      }
                                    },
                                  ),
                                  // child: Container(
                                  //   decoration: BoxDecoration(
                                  //     color: Colors.grey.shade50,
                                  //     borderRadius: BorderRadius.circular(14),
                                  //     border: Border.all(color: const Color(0xFFF1F5F9)),
                                  //   ),
                                  //   child: TextFormField(
                                  //     controller: travellerPhone,
                                  //     decoration: InputDecoration(
                                  //       hintText: "Mobile Number",
                                  //       contentPadding: const EdgeInsets.symmetric(
                                  //         horizontal: 12,
                                  //         vertical: 14,
                                  //       ),
                                  //     ),
                                  //     keyboardType: TextInputType.phone,
                                  //
                                  //     onChanged: (value) {
                                  //       if (value.length == 10) {
                                  //         pro.checkVerification(value, context);
                                  //       }
                                  //     },
                                  //   ),
                                  // ),
                                ),

                                const SizedBox(width: 10),

                                /// VERIFY BUTTON / STATUS
                                pro.isVerified
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    )
                                    : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorResource.primary,
                                      ),
                                      onPressed: () {
                                        pro.sendOtp(
                                          travellerPhone.text,
                                          context,
                                        );
                                      },
                                      child: const Text("Verify"),
                                    ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            /// OTP FIELD
                            if (pro.isOtpSent)
                              Pinput(
                                length: 4,
                                onCompleted: (pin) {
                                  pro
                                      .verifyOtp(
                                        travellerPhone.text,
                                        pin,
                                        context,
                                      )
                                      .then((_) {
                                        if (pro.isVerified) {
                                          _callFareSummaryTabApi(); // ← here
                                        }
                                      });
                                },
                                // onCompleted: (pin) {
                                //   pro.verifyOtp(travellerPhone.text, pin, context);
                                // },
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 10),
                      // After Wallet Discount textCard...
                      // textCard(
                      //   title: 'Wallet Discount',
                      //   price: '- ₹ ${widget.walletDiscount}',
                      // ),

                      // ✅ NEW: COUPON SECTION
                      const SizedBox(height: 15),
                      // Text(
                      //   'APPLY COUPON',
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w700,
                      //     color: ColorResource.textBlack,
                      //   ),
                      // ),
                      // const SizedBox(height: 8),

                      // After Wallet Discount textCard...

                      // const SizedBox(height: 15),

                      // ================== COUPON SECTION ==================
                      Text(
                        'APPLY COUPON',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: ColorResource.textBlack,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Consumer<BookingSummaryProvider>(
                        builder: (context, pro, child) {
                          return Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // View Available Coupons Button
                                GestureDetector(
                                  onTap: () {
                                    print(
                                      "widget.finalPayableAmount ${widget.finalPayableAmount}",
                                    );
                                    final double amount =
                                        (double.tryParse(
                                              widget.distanceCharge,
                                            ) ??
                                            0.0) +
                                        (double.tryParse(widget.timeCharge) ??
                                            0.0) -
                                        (double.tryParse(
                                              widget.walletDiscount,
                                            ) ??
                                            0.0);
                                    pro.fetchAvailableCoupons(
                                      dropLat: widget.dropLat,
                                      dropLng: widget.dropLng,
                                      pickupLat: widget.pickupLat,
                                      pickupLng: widget.pickupLng,
                                      amount: amount.toString(),
                                      // amount: widget.finalPayableAmount,
                                      context: context,
                                    );
                                    _showCouponsBottomSheet(context, pro);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue.shade200,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.local_offer_outlined,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "View Available Coupons",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Manual Entry
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: "Enter Coupon Code",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14,
                                              ),
                                        ),
                                        onChanged:
                                            (value) =>
                                                pro.coupon =
                                                    value.trim().toUpperCase(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed:
                                          pro.isApplyCouponApi
                                              ? null
                                              : () async {
                                                if (pro.coupon.isEmpty) {
                                                  ToastHelper.show(
                                                    context,
                                                    message:
                                                        "Enter coupon code",
                                                    type: ToastType.warning,
                                                  );
                                                  return;
                                                }
                                                print(
                                                  "widget.finalPayableAmount ${widget.finalPayableAmount}",
                                                );
                                                final double amount =
                                                    (double.tryParse(
                                                          widget.distanceCharge,
                                                        ) ??
                                                        0.0) +
                                                    (double.tryParse(
                                                          widget.timeCharge,
                                                        ) ??
                                                        0.0) -
                                                    (double.tryParse(
                                                          widget.walletDiscount,
                                                        ) ??
                                                        0.0);
                                                pro.applyCouponApi(
                                                  isBack: false,
                                                  context: context,
                                                  amount: amount.toString(),
                                                  dropLat: widget.dropLat,
                                                  dropLng: widget.dropLng,
                                                  pickupLat: widget.pickupLat,
                                                  pickupLng: widget.pickupLng,
                                                  // dropLat: widget.dropLat,
                                                  // dropLng: widget.dropLng,
                                                  // pickupLat: widget.pickupLat,
                                                  // pickupLng: widget.pickupLng,
                                                  // amount: widget.finalPayableAmount,
                                                  couponCode: pro.coupon,
                                                );
                                                await Future.delayed(
                                                  const Duration(seconds: 3),
                                                );
                                                print(
                                                  "🔄 Refreshing fare summary with coupon: ${pro.coupon} and ${pro.appliedCouponCode}",
                                                );
                                                if (pro.appliedCouponCode !=
                                                    null) {
                                                  print(
                                                    "hhhhhhhhhhhhhhhhhhhhhh1",
                                                  );
                                                  _refreshFareSummaryWithCoupon(
                                                    pro.coupon,
                                                  );
                                                  print(
                                                    "hhhhhhhhhhhhhhhhhhhhhh3",
                                                  );
                                                }
                                                print(
                                                  "hhhhhhhhhhhhhhhhhhhhhh2",
                                                );
                                                // ToastHelper.show(
                                                //   context,
                                                //   message: pro.couponMessage
                                                //   ,
                                                //   type:pro.isCouponGreenMessage==true?ToastType.success: ToastType.error,
                                                // );
                                              },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child:
                                          pro.isApplyCouponApi
                                              ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                              : const Text("Apply"),
                                    ),
                                  ],
                                ),

                                // Applied Coupon Status
                                if (pro.appliedCouponCode != null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "✓ ${pro.appliedCouponCode} Applied",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green,
                                                fontSize: 15,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: pro.removeCoupon,
                                              icon: const Icon(
                                                Icons.cancel,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (pro.discountAmount != null)
                                          Text(
                                            "Discount: - ₹${pro.discountAmount}",
                                            style: const TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        // if (pro.finalAmountAfterCoupon != null)
                                        //   Text(
                                        //     "Final Amount: ₹${pro.finalAmountAfterCoupon}",
                                        //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        //   ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 10),

                      // Consumer<BookingSummaryProvider>(
                      //   builder: (context, pro, child) {
                      //     return Container(
                      //       padding: const EdgeInsets.all(12),
                      //       decoration: BoxDecoration(
                      //         color: Colors.grey.shade50,
                      //         borderRadius: BorderRadius.circular(12),
                      //         border: Border.all(color: const Color(0xFFF1F5F9)),
                      //       ),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           // Manual Input
                      //           Row(
                      //             children: [
                      //               Expanded(
                      //                 child: TextField(
                      //                   decoration: InputDecoration(
                      //                     hintText: "Enter Coupon Code",
                      //                     border: OutlineInputBorder(
                      //                       borderRadius: BorderRadius.circular(8),
                      //                     ),
                      //                     contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      //                   ),
                      //                   onChanged: (value) {
                      //                     pro.coupon = value.trim();
                      //                   },
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 8),
                      //               ElevatedButton(
                      //                 onPressed: pro.isApplyCouponApi
                      //                     ? null
                      //                     : () {
                      //                   if (pro.coupon.isEmpty) {
                      //                     ToastHelper.show(context, message: "Enter coupon code", type: ToastType.warning);
                      //                     return;
                      //                   }
                      //                   pro.applyCouponApi(
                      //                     context: context,
                      //                     amount: widget.finalPayableAmount,
                      //                     couponCode: pro.coupon,
                      //                   );
                      //                 },
                      //                 child: pro.isApplyCouponApi
                      //                     ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      //                     : const Text("Apply"),
                      //               ),
                      //             ],
                      //           ),
                      //
                      //           // Applied Coupon Info
                      //           if (pro.appliedCouponCode != null) ...[
                      //             const SizedBox(height: 12),
                      //             Container(
                      //               padding: const EdgeInsets.all(12),
                      //               decoration: BoxDecoration(
                      //                 color: Colors.green.shade50,
                      //                 borderRadius: BorderRadius.circular(8),
                      //                 border: Border.all(color: Colors.green.shade200),
                      //               ),
                      //               child: Column(
                      //                 crossAxisAlignment: CrossAxisAlignment.start,
                      //                 children: [
                      //                   Row(
                      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //                     children: [
                      //                       Text(
                      //                         "Coupon Applied: ${pro.appliedCouponCode}",
                      //                         style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green),
                      //                       ),
                      //                       IconButton(
                      //                         icon: const Icon(Icons.close, color: Colors.red, size: 20),
                      //                         onPressed: pro.removeCoupon,
                      //                       ),
                      //                     ],
                      //                   ),
                      //                   if (pro.discountAmount != null)
                      //                     Text(
                      //                       "Discount: - ₹ ${pro.discountAmount}",
                      //                       style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                      //                     ),
                      //                   if (pro.finalAmountAfterCoupon != null)
                      //                     Text(
                      //                       "Final Amount: ₹ ${pro.finalAmountAfterCoupon}",
                      //                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      //                     ),
                      //                 ],
                      //               ),
                      //             ),
                      //           ],
                      //         ],
                      //       ),
                      //     );
                      //   },
                      // ),
                      const SizedBox(height: 10),
                      SizedBox(height: 10),
                      CustomText(
                        'FARE BREAKDOWN',
                        size: 14,
                        weight: FontWeight.w700,
                        color: ColorResource.textBlack,
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: const Color(0xFFF1F5F9),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: Color(0x0C000000),
                              blurRadius: 2,
                              offset: Offset(0, 1),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            /// MAIN 3 ITEMS
                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : textCard(
                                  title: 'Base Fare',
                                  price:
                                      '₹ ${summaryBreakDown?.baseFare ?? "0"}',
                                  // price: '₹ ${widget.baseFare}',
                                ),
                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : const SizedBox(height: 10),

                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : textCard(
                                  title: 'Distance Charge',
                                  price:
                                      '₹ ${summaryBreakDown?.distanceCharge ?? "0"}',
                                  // price: '₹ ${widget.distanceCharge}',
                                ),
                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : const SizedBox(height: 10),

                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : textCard(
                                  title: 'Time Charge',
                                  price:
                                      '₹ ${summaryBreakDown?.timeCharge ?? "0"}',
                                  // price: '₹ ${widget.timeCharge}',
                                ),

                            widget.bookingType == "hourly"
                                ? SizedBox()
                                : const SizedBox(height: 10),

                            /// EXPANDABLE TILE
                            Theme(
                              data: Theme.of(
                                context,
                              ).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: const EdgeInsets.only(top: 10),

                                title: CustomText(
                                  "Expense Details",
                                  size: 16,
                                  weight: FontWeight.w600,
                                ),
                                children: [
                                  // Surge Charge (already had booking type check)
                                  if (widget.bookingType != "hourly" &&
                                      summaryBreakDown?.surgeCharge != null &&
                                      summaryBreakDown?.surgeCharge
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.surgeCharge
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Surge Charge',
                                      price:
                                          '₹ ${summaryBreakDown?.surgeCharge ?? "0"}',
                                    ),

                                  const SizedBox(height: 10),

                                  // MCD Toll Charge
                                  if (summaryBreakDown != null &&
                                      summaryBreakDown.mcdTollCharge
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown.mcdTollCharge
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'MCD Toll Charge',
                                      price:
                                          '₹ ${summaryBreakDown.mcdTollCharge ?? "0"}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Subtotal
                                  if (summaryBreakDown?.subtotal != null &&
                                      summaryBreakDown?.subtotal
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.subtotal
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Subtotal',
                                      price:
                                          '₹ ${summaryBreakDown?.subtotal ?? "0"}',
                                    ),
                                  const SizedBox(height: 10),

                                  // GST Percent
                                  if (summaryBreakDown?.gstPercent != null &&
                                      summaryBreakDown?.gstPercent
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.gstPercent
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'GST Percent',
                                      price:
                                          ' ${summaryBreakDown?.gstPercent} %',
                                    ),
                                  const SizedBox(height: 10),

                                  // ✅ Dynamic GST Amount (After Wallet + Coupon)
                                  if (summaryBreakDown?.gstAmount != null &&
                                      summaryBreakDown?.gstAmount
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.gstAmount
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'GST Amount',
                                      price: '₹ ${summaryBreakDown?.gstAmount}',
                                    ),

                                  const SizedBox(height: 10),

                                  // Toll Charge
                                  if (summaryBreakDown?.tollCharge != null &&
                                      summaryBreakDown?.tollCharge
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.tollCharge
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Toll Charge',
                                      price:
                                          '₹ ${summaryBreakDown?.tollCharge}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Surge Charge Amount
                                  if (summaryBreakDown?.surchargeAmount !=
                                          null &&
                                      summaryBreakDown?.surchargeAmount
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.surchargeAmount
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: "Surge Charge Amount",
                                      price:
                                          '₹ ${summaryBreakDown?.surchargeAmount ?? "0"}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Airport Fare
                                  if (summaryBreakDown?.airportFare != null &&
                                      summaryBreakDown?.airportFare
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.airportFare
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Airport Fare',
                                      price:
                                          '₹ ${summaryBreakDown?.airportFare}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Night Fare
                                  if (summaryBreakDown?.nightFare != null &&
                                      summaryBreakDown?.nightFare
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.nightFare
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Night Fare',
                                      price: '₹ ${summaryBreakDown?.nightFare}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Wallet Discount
                                  if (summaryBreakDown?.walletUsed != null &&
                                      summaryBreakDown?.walletUsed
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.walletUsed
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Wallet Discount',
                                      price:
                                          '- ₹ ${summaryBreakDown?.walletUsed}',
                                    ),
                                  const SizedBox(height: 10),

                                  // Coupon Discount
                                  if (summaryBreakDown?.couponDiscount !=
                                          null &&
                                      summaryBreakDown?.couponDiscount
                                              .toString()
                                              .trim() !=
                                          "0" &&
                                      summaryBreakDown?.couponDiscount
                                              .toString()
                                              .trim() !=
                                          "")
                                    textCard(
                                      title: 'Coupon Discount',
                                      price:
                                          '- ₹ ${summaryBreakDown?.couponDiscount}',
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// TOTAL
                            /// TOTAL
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  'Total Amount',
                                  size: 16,
                                  weight: FontWeight.w700,
                                ),
                                CustomText(
                                  '₹ ${summaryBreakDown?.finalPayableAmount}',
                                  // '₹ $displayTotal',
                                  size: 20,
                                  weight: FontWeight.w700,
                                  color: ColorResource.primary,
                                ),
                              ],
                            ),

                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     CustomText(
                            //       'Total Amount',
                            //       size: 16,
                            //       weight: FontWeight.w700,
                            //     ),
                            //     CustomText(
                            //       // '₹ ${widget.totalFare}',
                            //       '₹ ${widget.finalPayableAmount}',
                            //       size: 20,
                            //       weight: FontWeight.w700,
                            //       color: ColorResource.textColor,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            // width: 291.36,
                            // height: 39,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Disclaimer: By proceeding, you agree to Mann Fleet',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                    ),
                                  ),
                                  TextSpan(
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap = () {
                                            navPush(
                                              context: context,
                                              action: const CMSContentScreen(
                                                title: "Terms & Conditions",
                                                type: CMSContentType.terms,
                                              ),
                                            );
                                            print("Terms & Conditions");

                                            /// 👉 Navigate karo
                                            // navPush(context: context, action: PrivacyPolicyScreen());
                                          },
                                    text: 'Terms & Conditions. ',
                                    style: TextStyle(
                                      color: ColorResource.primary,
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        'Fare may vary based on traffic, route, or waiting time. Cancellation charges may apply. Pets are not permitted during the ride.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // Expanded(
                          //   child: Text(
                          //     "Disclaimer: By proceeding, you agree to Mann Fleet's Terms & Conditions. "
                          //     "Fare may vary based on traffic, route, or waiting time. "
                          //     "Cancellation charges may apply. "
                          //     "Pets are not permitted during the ride.",
                          //     style: TextStyle(
                          //       fontSize: 11,
                          //       color: Colors.grey.shade600,
                          //       height: 1.4,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              ),

              if (pro.isLoading)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.grey.shade200,
                    color: ColorResource.primary, // or your primary color
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Consumer<BookingSummaryProvider>(
            builder: (context, provider, _) {
              final summaryBreakDown =
                  provider.fareSummaryModel?.data?.fareBreakdown;
              // final displayTotal = provider.finalAmountAfterCouponStr ?? widget.finalPayableAmount;
              return CustomButton(
                title:
                    widget.finalPayableAmount == "0"
                        ? "Book Now"
                        : 'Proceed to Pay ₹ ${summaryBreakDown?.finalPayableAmount ?? ""}',
                // title:widget.finalPayableAmount=="0"?"Book Now": 'Proceed to Pay ₹ ${widget.finalPayableAmount}',
                // title: 'Proceed to Pay ₹ ${widget.totalFare}',
                onTap:
                    provider.isVerified
                        ? () async {
                          if (travellerName.text.trim().isEmpty) {
                            ToastHelper.show(
                              context,
                              message: "Please enter name",
                              type: ToastType.warning,
                            );
                            return;
                          }

                          if (travellerEmail.text.trim().isEmpty) {
                            ToastHelper.show(
                              context,
                              message: "Please enter email",
                              type: ToastType.warning,
                            );
                            return;
                          }

                          if (travellerPhone.text.trim().isEmpty ||
                              travellerPhone.text.length < 10) {
                            ToastHelper.show(
                              context,
                              message: "Please enter valid phone number",
                              type: ToastType.warning,
                            );
                            return;
                          }
                          await callBookingApi();
                          // razorpayService.openCheckout(
                          //   amount: widget.totalFare,
                          //   name: "Mann Fleet",
                          //   description: "Cab Booking Payment",
                          //   contact: "9161470607",
                          //   email: "test@gmail.com",
                          // );
                        }
                        : () {
                          ToastHelper.show(
                            context,
                            message: "Please verify your number",
                            type: ToastType.error,
                          );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text("Please verify your number"),
                          //   ),
                          // );
                        },
                backgroundColor:
                    provider.isVerified
                        ? ColorResource.buttonBackground
                        : Colors.grey,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget textCard({required String title, required String price}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          title,
          size: 14,
          weight: FontWeight.w400,
          color: ColorResource.textBlack,
        ),
        CustomText(
          price,
          size: 14,
          weight: FontWeight.w600,
          color: ColorResource.black,
        ),
      ],
    );
  }

  Widget bookingCard({
    required String image,
    required String title,
    required String seat,
    required String ac,
    required String sugementName,
    required String estimatedTime,
  }) {
    return Container(
      padding: EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      // padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   width: 64,
          //   height: 64,
          //   decoration: ShapeDecoration(
          //     color: const Color(0xFFF1F5F9),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: Center(
          //     child: CustomImageView(
          //       imagePath: image,
          //       // width: 24,
          //       // height: 24,
          //       fit: BoxFit.contain,
          //       imageType: ImageType.network,
          //     ),
          //   ),
          // ),
          // SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // color: ColorResource.homeOption,
                  color: Color(0xfff2dfe0),
                ),
                child: CustomText(
                  sugementName,

                  size: 10,
                  weight: FontWeight.w700,
                  color: ColorResource.primary,
                  // color: ColorResource.textColor,
                ),
              ),
              SizedBox(height: 4),
              // Text(
              //   title,
              //   style: TextStyle(
              //     color: const Color(0xFF0F172A),
              //     fontSize: 16,
              //     fontFamily:  FontResource.plusJakartaSans,
              //     fontWeight: FontWeight.w700,
              //     height: 1.40,
              //   ),
              // ),SizedBox(height: 6,),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  estimatedTime,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorResource.viewText,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCouponsBottomSheet(
    BuildContext context,
    BookingSummaryProvider pro,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<BookingSummaryProvider>(
          builder: (context, provider, child) {
            final coupons = provider.getCouponsModel?.data ?? [];

            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  const Text(
                    "Available Coupons",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child:
                        provider.isGetCouponApi
                            ? const Center(child: CircularProgressIndicator())
                            : coupons.isEmpty
                            ? const Center(child: Text("No coupons available"))
                            : ListView.builder(
                              itemCount: coupons.length,
                              itemBuilder: (context, index) {
                                final coupon = coupons[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      coupon.code ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Up to ₹${coupon.maxDiscountAmount} off",
                                    ),
                                    trailing: ElevatedButton(
                                      onPressed: () {
                                        print(
                                          "widget.finalPayableAmount ${widget.finalPayableAmount}",
                                        );
                                        final double amount =
                                            (double.tryParse(
                                                  widget.distanceCharge,
                                                ) ??
                                                0.0) +
                                            (double.tryParse(
                                                  widget.timeCharge,
                                                ) ??
                                                0.0) -
                                            (double.tryParse(
                                                  widget.walletDiscount,
                                                ) ??
                                                0.0);

                                        // pro.applyCouponApi(
                                        //   context: context,
                                        //   amount: widget.finalPayableAmount,
                                        //   couponCode: coupon.code ?? "",
                                        // );
                                        pro
                                            .applyCouponApi(
                                              dropLat: widget.dropLat,
                                              dropLng: widget.dropLng,
                                              pickupLat: widget.pickupLat,
                                              pickupLng: widget.pickupLng,

                                              isBack: true,
                                              context: context,
                                              amount: amount.toString(),
                                              // amount: widget.finalPayableAmount,
                                              couponCode: coupon.code ?? "",
                                            )
                                            .then((_) {
                                              // Refresh summary after apply
                                              if (pro.appliedCouponCode !=
                                                  null) {
                                                _refreshFareSummaryWithCoupon(
                                                  coupon.code ?? "",
                                                );
                                              }
                                            });
                                        // Navigator.pop(context);
                                        print("hhhhhhhhhhhhhhhhhhhhhh2");
                                        // ToastHelper.show(
                                        //   context,
                                        //   message: pro.couponMessage
                                        //   ,
                                        //   type:pro.isCouponGreenMessage==true?ToastType.success: ToastType.error,
                                        // );
                                      },
                                      child: const Text("Apply"),
                                    ),
                                  ),
                                );
                              },
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,
    int? maxLength, // Dynamic length
    required bool readOnly, // Dynamic length
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,

        keyboardType: keyboardType,
        onChanged: onChanged,
        maxLength: maxLength,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon, size: 20, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
