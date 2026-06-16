// choosePassScreen

import 'dart:convert';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:provider/provider.dart';

import '../../../../apiservice/payment/paymentService.dart';
import '../../../../apiservice/services/appConfigService.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../booking/ui/widget/bookingProcessingWidget.dart';
import '../../../bottomBar/bottomBar.dart';
import '../../../profile/viewModel/profileViewModel.dart';
import '../model/getShuttlePassesModel.dart';
import '../provider/shuttleProvider.dart';

class ChoosePassScreen extends StatefulWidget {
  final String source;
  final String destination;
  final String bookingDate;
  final String shiftId ;

  const ChoosePassScreen({
    super.key,
    required this.destination,
    required this.source,
    required this.bookingDate,
    required this.shiftId
  });

  @override
  State<ChoosePassScreen> createState() => _ChoosePassScreenState();
}

class _ChoosePassScreenState extends State<ChoosePassScreen> {
  late RazorpayService razorpayService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShuttleProvider>(
        context,
        listen: false,
      ).getShuttleShiftStopApi(
        context: context,
        destination: widget.destination,
        source: widget.source,
        shuttleShiftId: widget.shiftId,
        bookingDate: widget.bookingDate
      );
    });
    razorpayService = RazorpayService();

    razorpayService.onSuccess = (response) async {
      print("Payment Success: ${response.paymentId}");

      // 👉 Payment success ke baad API call
      // await callBookingApi();
    };

    razorpayService.onError = (response) {
      print("Payment Failed: ${response.message}");
    };

    razorpayService.onExternalWallet = (response) {
      print("External Wallet: ${response.walletName}");
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Mann Passes", isBack: true),
      body: Consumer<ShuttleProvider>(
        builder: (context, pro, child) {
          if (pro.getShuttlePassesModel == null ||
              pro.getShuttlePassesModel!.data == null ||
              pro.getShuttlePassesModel!.data!.passes == null) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (pro.getShuttlePassesModel!.data!.passes!.isEmpty) {
            return Text("No Passes");
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your pass between ${pro.getShuttlePassesModel!.data!.routeInfo!.source} and ${pro.getShuttlePassesModel!.data!.routeInfo!.destination}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  // "Unlimited travel across all Noida Metro Feeder and City buses.",
                  "Unlimited travel between ${pro.getShuttlePassesModel!.data!.routeInfo!.source} and ${pro.getShuttlePassesModel!.data!.routeInfo!.destination} across all shuttleHistory routes.",
                  style: TextStyle(
                    color: Color(0xff64748B),
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: pro.getShuttlePassesModel!.data!.passes!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: passCard(
                        pass: pro.getShuttlePassesModel!.data!.passes![index],
                        pro: pro,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget passCard({
    required PassModelShuttle pass,
    required ShuttleProvider pro,
  }) {
    return Container(
      width: double.infinity,

      // padding: EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(width: 1, color: const Color(0xFFF1F5F9)),

        boxShadow: [
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
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Color(0x194E41B4),
              image: DecorationImage(
                image: NetworkImage(pass.thumbImage ?? ""),
                fit: BoxFit.fill,
              ),
            ),
            // child: const Center(
            //   child: Icon(Icons.calendar_month,
            //       size: 40, color: Color(0xFF4E41B4)),
            // ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pass.name ?? "-",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '₹${pass.pricing!.finalPrice.toString()}',
                      // '₹${pass.pricing!.totalPrice.toString()}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),
                Text(
                  pass.description ?? "_",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),

                /// 🔹 Title + Price Row
                const SizedBox(height: 10),

                /// 🔹 Features List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pass.benefits?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.verified_outlined,
                            size: 18,
                            color: Color(0xFF04055F),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: MediaQuery.of(context).size.width*0.75,
                            child: Text(
                              pass.benefits![index],
                              // maxLines: 1,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),

                pass.isPurchased == true
                    ? Row(
                      children: [
                        /// 🎫 Remaining Ride (Chip Style - NOT button)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6E9FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Rides: ${pass.remainingRides}",
                                style: const TextStyle(
                                  color: Color(0xFF03045E),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// 🚀 View QR (Primary Button)
                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              showLoader(context);

                              await pro.generateQrApi(
                                context: context,
                                transactionId: pass.transactionId ?? "",
                                source: widget.source,
                                destination:widget.destination ,
                              );

                              navPop(context: context);

                              /// 👉 QR Dialog (same as your code)
                              showQrDialog(context, pro);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF03045E),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "View QR",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                    : CustomButton(
                      title: 'Buy Now',
                      onTap: () async {
                        showBookingBottomSheet(context);
                        // showLoader(context);
                        await pro.purchaseShuttlePassApi(
                          context: context,
                          destination:
                              pro
                                  .getShuttlePassesModel!
                                  .data!
                                  .routeInfo!
                                  .destination
                                  .toString(),
                          source:
                              pro.getShuttlePassesModel!.data!.routeInfo!.source
                                  .toString(),
                          passId: pass.passId ?? "",
                          bookingDate:widget.bookingDate,
                          shiftId:widget.shiftId,
                        );
                        bookingKey.currentState?.showPayment();

                        /// ✅ IMPORTANT: wait 3 seconds
                        await Future.delayed(const Duration(milliseconds: 500));
                        Navigator.pop(context); // close loader

                        /// STEP 3: Close BottomSheet
                        // Navigator.pop(context);
                        print("<<<<<<<<<<<<<<<<<<<<<${pro.purchaseShuttlePassModel?.message}>>>>>>>>>>>>>>>>>>>>>");
                        final data = pro.purchaseShuttlePassModel?.data;
                        if (data?.razorpay == null) {
                          ToastHelper.show(
                            context,
                            message:pro.purchaseShuttlePassModel?.error?.message?? "Payment data not found",
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
                        print(
                          "Razor Pay Key 🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑🔑: $razorKey",
                        );
                        final profile = context
                            .read<ProfileDetailViewModel>()
                            .getProfileModel
                            ?.data
                            ?.user;

                        // final userEmail = provider.getProfileModel?.data?.user?.email??"";
                        // final userMobile = provider.getProfileModel?.data?.user?.mobile??"";

                        /// ✅ अब Razorpay open करो
                        razorpayService.openCheckoutWithOrderId(
                          amount: amount,
                          orderId: orderId,
                          // key: key,
                          key: razorKey,
                          name: "Mann Fleet",
                          description: "Shuttle Booking Payment",
                          contact: profile?.mobile ?? "",
                          email: profile?.email ?? "",
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

                          navPush(
                            context: context,
                            action: MainScreen(currentIndex: 2),
                          );
                        };
                      },
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showQrDialog(BuildContext context, ShuttleProvider pro) {
    final data = pro.generateQrModel!.data!;
    final qrBytes = getQrBytes(data.qrImage!);

    int timeLeft = data.timeLeft ?? 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future.delayed(const Duration(seconds: 1), () {
              if (timeLeft > 0) setState(() => timeLeft--);
            });

            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// 🔵 TITLE
                      Text(
                        data.passInfo?.name ?? "Shuttle Pass",
                        style: const TextStyle(
                          color: Color(0xFF03045E),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// 📍 ROUTE
                      Text(
                        "${data.passInfo?.source} → ${data.passInfo?.destination}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🧾 QR BOX
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.memory(
                          qrBytes,
                          height: 170,
                          width: 170,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// 🎫 REMAINING RIDES
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Remaining Rides"),
                          Text(
                            "${data.passInfo?.remainingRides ?? 0}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF03045E),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      /// ⏱ TIMER
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text("Expires In"),
                      //     Text(
                      //       "$timeLeft sec",
                      //       style: TextStyle(
                      //         color: timeLeft < 30 ? Colors.red : Colors.green,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ],
                      // ),

                      const SizedBox(height: 10),

                      /// 📅 EXPIRY DATE
                      // Text(
                      //   "Valid till: ${formatDateTime(data.expiresAt!)}",
                      //   style: TextStyle(
                      //     color: Colors.grey.shade500,
                      //     fontSize: 11,
                      //   ),
                      // ),

                      const SizedBox(height: 12),

                      /// ❌ CLOSE
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Color(0xFF03045E)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Uint8List getQrBytes(String base64String) {
    final base64Data =
        base64String.split(',').last; // remove data:image/png;base64,
    return base64Decode(base64Data);
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
}

String formatDateTime(String isoDate) {
  final dateTime = DateTime.parse(isoDate).toLocal();
  return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
}
