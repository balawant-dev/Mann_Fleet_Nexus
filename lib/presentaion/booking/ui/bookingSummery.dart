import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/booking/ui/widget/bookingProcessingWidget.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';


import '../../../apiservice/payment/paymentService.dart';
import '../../../apiservice/services/appConfigService.dart';
import '../../../util/FontResource/FontResource.dart';
import '../../../util/color/app_colors.dart';

import '../../../widget/customImageView.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/navigator_method.dart';

import '../../bottomBar/bottomBar.dart';
import '../../profile/model/getProfileModel.dart';
import '../../profile/viewModel/profileViewModel.dart';
import '../provider/bookingSummaryProvider.dart';


class BookingSummary extends StatefulWidget {
  final String segmentName;
  final String vehicleName;
  final String bookingType;
  final String away;
  final String pickUpLocation;
  final String dropLocation;
  final String date;
  final String time;
  final String baseFare;
  final String distanceCharge;
  final String timeCharge;
  final String surgeCharge;
  final String subtotal;
  final String gstPercent;
  final String gstAmount;
  final String tollCharge;
  final String totalFare;
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
  final   bool isDropAirport;
  final bool isAirportTrip;
  final bool isGrayMatter;


  const BookingSummary({
    super.key,
    required this.away,
    required this.time,
    required this.date,
    required this.airportFare,
    required this.baseFare,
    required this.bookingType,
    required this.cancellationFee,
    required this.distanceCharge,
    required this.dropLocation,
    required this.gstAmount,
    required this.nightFare,
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
    required this.estimatedTime,
    required this.estimatedTimeContent,required this.isAirportTrip,
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
  @override
  void initState() {
    super.initState();
    travellerEmail = TextEditingController();
    travellerName = TextEditingController();
    travellerPhone = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileDetailViewModel>(context, listen: false);
      provider.getProfileApi(context: context).then((_) {
        _fillInitialData(provider.getProfileModel);
        if (travellerPhone.text.length == 10) {
          Provider.of<BookingSummaryProvider>(context, listen: false)
              .checkVerification(travellerPhone.text, context);
        }
      });
    });

    razorpayService = RazorpayService();

    razorpayService.onSuccess = (response) async {
      print("Payment Success: ${response.paymentId}");

      // 👉 Payment success ke baad API call
      await callBookingApi();

    };

    razorpayService.onError = (response) {
      print("Payment Failed: ${response.message}");
    };

    razorpayService.onExternalWallet = (response) {
      print("External Wallet: ${response.walletName}");
    };
  }

  void _fillInitialData(GetProfileModel? model) {
    if (model?.data?.user == null) return;

    final user = model!.data!.user!;

    travellerName.text = user.name ?? '';
    travellerEmail.text = user.email ?? '';

    travellerPhone.text = user.mobile ?? '';


    setState(() {});
  }

  @override
  void dispose() {
    razorpayService.dispose();
    super.dispose();
  }
  Future<void> callBookingApi() async {
    final pro = Provider.of<BookingSummaryProvider>(context, listen: false);
    showBookingBottomSheet(context);


    // showLoader(context);

    await pro.createOneWayBooking(
      surchargeAmount: widget.surchargeAmount,
      nightFare: widget.nightFare,
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
      totalFare: widget.totalFare,
      timeType: widget.timeType,
      surgeCharge: widget.surgeCharge,
      subtotal: widget.subtotal,
      baseFare: widget.baseFare,
      distanceCharge: widget.distanceCharge,
      gstAmount: widget.gstAmount,
      gstPercent: widget.gstPercent,
      tollCharge: widget.tollCharge,
      scheduledDate:  widget.scheduledDate,
      scheduledTime:  widget.scheduledTime,
      returnDate:  widget.returnDate,
      // scheduledTime:  "23:00",
      bookedKms:  widget.bookedKms,
      returnTime: widget.returnTime,
      selectedHours: widget.selectedHours,
      tripDays: widget.tripDays,
      toCity: widget.toCity,


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
    if (data?.razorpay == null) {
      ToastHelper.show(
        context,
        message: "Payment data not found",
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
        return  BookingProcessingWidget(key: bookingKey);
      },
    );
  }
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
      appBar: CustomAppBar(title: 'Booking Summary',isBack: true,),
      body: Consumer<BookingSummaryProvider>(builder: (context, pro, child) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                bookingCard(
                  image: widget.vehicleImage,
                  title: widget.vehicleName,
                  estimatedTime: widget.estimatedTimeContent,
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
                  padding: const EdgeInsets.all(16),
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
                      )
                    ],
                  ),

                  child: Column(
                    children: [
                      Row(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PICKUP LOCATION",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontFamily: FontResource.plusJakartaSans,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  widget.pickUpLocation,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontResource.plusJakartaSans,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: 20),

                                Text(
                                  "DROP-OFF LOCATION",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontFamily: FontResource.plusJakartaSans,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                SizedBox(height: 6),

                                Text(
                                  widget.dropLocation,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontResource.plusJakartaSans,
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

                      Row(
                        children: [

                          /// 📏 Distance
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.blue.withOpacity(0.1),
                                    child: const Icon(Icons.route, size: 18, color: Colors.blue),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        "${widget.estimatedDistance}",
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

                          const SizedBox(width: 10),

                          /// ⏱ Time
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFF1F5F9)),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 18,
                                    backgroundColor: Colors.orange.withOpacity(0.1),
                                    child: const Icon(Icons.access_time, size: 18, color: Colors.orange),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                        "${widget.estimatedTime}",
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

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          /// 📅 DATE
                          Expanded(
                            child: GestureDetector(
                              onTap: pickDate,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFF1F5F9)),
                                ),
                                child: Row(
                                  children: [
                                    /// Icon
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF03045E).withOpacity(0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.calendar_month,
                                        size: 18,
                                        color: Color(0xFF03045E),
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    /// Text
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "DATE",
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

                          const SizedBox(width: 12),

                          /// ⏱ TIME
                          Expanded(
                            child: GestureDetector(
                              onTap: pickTime,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFF1F5F9)),
                                ),
                                child: Row(
                                  children: [
                                    /// Icon
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: Colors.orange,
                                      ),
                                    ),

                                    const SizedBox(width: 10),

                                    /// Text
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "TIME",
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
                      )
                    ],
                  ),
                  child: Column(
                    children: [

                      /// NAME
                      _inputField(
                        controller: travellerName,
                        hint: "Enter Full Name",
                        icon: Icons.person,
                      ),

                      const SizedBox(height: 12),

                      /// EMAIL
                      _inputField(
                        controller: travellerEmail,
                        hint: "Enter Email",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 12),



                      Row(
                        children: [
                          Expanded(
                            child:      /// PHONE
                            _inputField(
                              controller: travellerPhone,
                              hint: "Enter Mobile Number",
                              icon: Icons.phone,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                if (value.length == 10) {
                                  pro.checkVerification(value, context);
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
                              ? const Icon(Icons.check_circle, color: Colors.green)
                              : ElevatedButton(
                            onPressed: () {
                              pro.sendOtp(
                                  travellerPhone.text, context);
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
                            pro.verifyOtp(
                                travellerPhone.text, pin, context);
                          },
                        ),
                    ],
                  ),
                ),

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
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      /// MAIN 3 ITEMS
                      textCard(title: 'Base Fare', price: '₹ ${widget.baseFare}'),
                      const SizedBox(height: 10),

                      textCard(
                        title: 'Distance Charge',
                        price: '₹ ${widget.distanceCharge}',
                      ),
                      const SizedBox(height: 10),

                      textCard(
                        title: 'Time Charge',
                        price: '₹ ${widget.timeCharge}',
                      ),

                      const SizedBox(height: 10),

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
                            textCard(
                              title: 'Surge Charge',
                              price: '₹ ${widget.surgeCharge}',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: 'Subtotal',
                              price: '₹ ${widget.subtotal}',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: 'GST Percent',
                              price: ' ${widget.gstPercent} %',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: 'GST Amount',
                              price: '₹ ${widget.gstAmount}',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: 'Toll Charge',
                              price: '₹ ${widget.tollCharge}',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: "Surge Charge Amount",
                              price: '₹ ${widget.surchargeAmount}',
                            ),
                            const SizedBox(height: 10),

                            textCard(
                              title: 'Airport Fare',
                              price: '₹ ${widget.airportFare}',
                            ), const SizedBox(height: 10),

                            textCard(
                              title: 'Night Fare',
                              price: '₹ ${widget.nightFare}',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

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
                            '₹ ${widget.totalFare}',
                            size: 20,
                            weight: FontWeight.w700,
                            color: ColorResource.textColor,
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Disclaimer: By proceeding, you agree to Mann Fleet's Terms & Conditions. "
                            "Fare may vary based on traffic, route, or waiting time. "
                            "Cancellation charges may apply. "
                            "Pets are not permitted during the ride.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100),

              ],
            ),
          ),
        );
      },),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Consumer<BookingSummaryProvider>(
              builder: (context, provider, _) {
                return CustomButton(title: 'Proceed to Pay ₹ ${widget.totalFare}', onTap:  provider.isVerified
                    ? ()async {
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
                  await  callBookingApi();
                  // razorpayService.openCheckout(
                  //   amount: widget.totalFare,
                  //   name: "Mann Fleet",
                  //   description: "Cab Booking Payment",
                  //   contact: "9161470607",
                  //   email: "test@gmail.com",
                  // );
                }: () {

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
                },backgroundColor: provider.isVerified?ColorResource.buttonBackground:Colors.grey,);
              }
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
      padding: EdgeInsets.all(12),
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
          Container(
            width: 64,
            height: 64,
            decoration: ShapeDecoration(
              color: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: image,
                // width: 24,
                // height: 24,
                fit: BoxFit.contain,
                imageType:ImageType.network,
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResource.homeOption,
                ),
                child: CustomText(
                  sugementName,

                  size: 10,
                  weight: FontWeight.w700,
                  color: ColorResource.textColor,
                ),
              ),SizedBox(height: 4,),
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
              Text(
                estimatedTime,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: ColorResource.viewText,
                ),
              ),

            ],
          ),
        ],
      ),
    );
  }



  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Function(String)? onChanged,

  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 20, color: Colors.grey),
          hintText: hint,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
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
