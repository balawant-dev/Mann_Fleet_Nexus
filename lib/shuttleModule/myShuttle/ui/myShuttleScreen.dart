import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/custom_appBar.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';

import '../../../presentaion/booking/booking/ui/widget/bookingProcessingWidget.dart';
import '../../../presentaion/bottomBar/bottomBar.dart';
import '../model/myShuttleModel.dart';
import '../viewModel/myShuttleViewModel.dart';

class MyPassesScreen extends StatefulWidget {
  const MyPassesScreen({super.key});

  @override
  State<MyPassesScreen> createState() => _MyPassesScreenState();
}

class _MyPassesScreenState extends State<MyPassesScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<MyShuttleViewModel>(context, listen: false);

    vm.getShuttleHistoryApi(context: context);
  }
  void _handleViewQR(BuildContext context, MyShuttleData pass, MyShuttleViewModel pro, String readableBookingDate) async {
    showLoader(context);

    if (pass.travelType == "both") {
      navPop(context: context); // close loader

      // Show selection dialog for Onward / Return
      final selectedShift = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Select Journey",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text("Onward",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                subtitle: Text("${pass.source} → ${pass.destination}"),
                onTap: () => Navigator.pop(context, "onward"),
              ),
              ListTile(
                title: const Text("Return",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                subtitle: Text("${pass.returnSource} → ${pass.returnDestination}"),
                onTap: () => Navigator.pop(context, "return"),
              ),
            ],
          ),
        ),
      );

      if (selectedShift == null) return; // user cancelled

      final bool isReturn = selectedShift == "return";

      await pro.generateQrApi(
        context: context,
        transactionId: pass.sId ?? "",
        source: isReturn ? (pass.returnSource ?? "") : (pass.source ?? ""),
        destination: isReturn ? (pass.returnDestination ?? "") : (pass.destination ?? ""),
        // isReturn: isReturn,           // ← New optional param
        // shuttleShift: isReturn ? pass.returnShuttleShift : pass.shuttleShift,
      );
    } else {
      // Single direction (existing flow)
      await pro.generateQrApi(
        context: context,
        transactionId: pass.sId ?? "",
        source: pass.source ?? "_",
        destination: pass.destination ?? "_",
        // shuttleShift: pass.shuttleShift,
      );
    }

    navPop(context: context);

    // Show QR Dialog
    showQrDialog(
      context: context,
      pro: pro,
      scheduledAt: readableBookingDate,
      // isBoth: pass.travelType == "both",
    );
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: CustomAppBar(title: "My Shuttle Passes", isBack: true,    onBackTap: () {
        MainScreen.changeTab(context, 0);
      },),
      body: Consumer<MyShuttleViewModel>(
        builder: (context, pro, child) {
          if (pro.myShuttleModel == null ||
              pro.myShuttleModel!.data == null

          ) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (pro.myShuttleModel!.data!.isEmpty) {
            return SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.confirmation_num_outlined,
                      size: 70,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "No Passes Purchased Yet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "You haven't purchased any shuttle passes yet.\nPurchase a pass to start your journey.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "Choose your pass between ${pro.myShuttleModel!.data!.routeInfo!.source} and ${pro.getShuttlePassesModel!.data!.routeInfo!.destination}",
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontWeight: FontWeight.w600,
                //     fontSize: 16,
                //   ),
                // ),
                // SizedBox(height: 10),
                // Text(
                //   // "Unlimited travel across all Noida Metro Feeder and City buses.",
                //   "Unlimited travel between ${pro.getShuttlePassesModel!.data!.routeInfo!.source} and ${pro.getShuttlePassesModel!.data!.routeInfo!.destination} across all shuttleHistory routes.",
                //   style: TextStyle(
                //     color: Color(0xff64748B),
                //     fontWeight: FontWeight.w400,
                //     fontSize: 12,
                //     fontStyle: FontStyle.italic,
                //   ),
                // ),
                SizedBox(height: 10),
                ListView.builder(
                  itemCount: pro.myShuttleModel!.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return passCard(
                      pass: pro.myShuttleModel!.data![index],
                      pro: pro,
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
    required MyShuttleData pass,
    required MyShuttleViewModel pro,
  }) {
    print("pass.expiryDate  ${pass.expiryDate}");

    final expiryDate = pass.createdAt ?? "";
    final bookingDate = pass.bookingDate ?? "";
    final shiftName = pass.shuttleShift?.shiftName ?? "";
    final travelType = pass.travelType ?? "";
    final departureTime =
        pass.shuttleShift?.stoppageTimes?.first.departureTime ?? "";

    String readableExpiryDate = "";
    String readableBookingDate = "";

    // IST (Indian Time)
    if (expiryDate.isNotEmpty) {
      readableExpiryDate = DateFormat(
        'dd MMM yyyy, hh:mm a',
      ).format(
        DateTime.parse(expiryDate).toLocal(),
      );
    }

    if (bookingDate.isNotEmpty) {
      readableBookingDate = DateFormat(
        'dd MMM yyyy',
      ).format(
        DateTime.parse(bookingDate).toLocal(),
      );
    }

    print("Readable Expiry Date: $readableExpiryDate");
    print("Readable Booking Date: $readableBookingDate");
    // print("pass.expiryDate  ${pass.expiryDate}");
    //
    // final expiryDate = pass.createdAt ?? "";
    // final bookingDate = pass.bookingDate ?? "";
    // final shiftName = pass.shuttleShift?.shiftName??"";
    // final departureTime = pass.shuttleShift?.stoppageTimes?.first.departureTime ?? "";
    //
    // String readableExpiryDate = "";
    // String readableBookingDate = "";
    //
    // if (expiryDate.isNotEmpty) {
    //   readableExpiryDate = DateFormat(
    //     'dd MMM yyyy, hh:mm a',
    //   ).format(DateTime.parse(expiryDate));
    // }   if (bookingDate.isNotEmpty) {
    //   readableBookingDate = DateFormat(
    //     'dd MMM yyyy',
    //     // 'dd MMM yyyy, hh:mm a',
    //   ).format(DateTime.parse(bookingDate));
    // }
    //
    // print("Readable Expiry Date: $readableExpiryDate");
    // print("Readable Booking Date: $readableBookingDate");

    // print("Expiry Date: $formattedExpiryDate");
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      /// 🔥 OUTER CARD
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.15),
        // color: ColorResource.primary.withOpacity(0.15),
        // color: Colors.grey.withOpacity(0.5),
        // color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Container(
          width: double.infinity,

          // padding: EdgeInsets.all(12),
          clipBehavior: Clip.antiAlias,
          // padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Container(
              //   height: 150,
              //   decoration: BoxDecoration(
              //     color: Color(0x194E41B4),
              //     image: DecorationImage(
              //       image: NetworkImage(pass.shuttlePass?.thumbImage ?? ""),
              //       fit: BoxFit.fill,
              //     ),
              //   ),
              //   // child: const Center(
              //   //   child: Icon(Icons.calendar_month,
              //   //       size: 40, color: Color(0xFF4E41B4)),
              //   // ),
              // ),

              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pass.shuttlePass?.name ?? "-",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '₹${pass.totalAmount.toString()}',
                          // '₹${pass.pricing!.totalPrice.toString()}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 5),
                    Text(
                      pass.shuttlePass?.shortDescription ?? "_",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),

                    /// 🔹 Title + Price Row
                    const SizedBox(height: 10),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {

                          },
                          child: Column(
                            children: [
                              /// SOURCE DOT
                              _dot(),

                              /// LINE till next point
                              _line(),



                              /// DESTINATION DOT
                              _dot(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),


                        Expanded(
                          child: GestureDetector(
                            onTap: (){

                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// SOURCE
                                _locationTile(
                                  title: pass.source ?? "_",
                                  subtitle: "",
                                ),



                                const SizedBox(height: 14),

                                /// DESTINATION
                                _locationTile(
                                  title:pass.destination ?? "_",
                                  subtitle: "",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    Divider(),

                    Row(
                      children: [
                        Text("Booked On : ",style: TextStyle(fontWeight: FontWeight.w500),),
                        Text( readableExpiryDate),
                      ],
                    ),


                    const SizedBox(height: 10),

                    Row(
                      children: [
                        Text("Scheduled At : ",style: TextStyle(fontWeight: FontWeight.w500),),
                        Text( "${readableBookingDate} | ${departureTime}"),
                      ],
                    ),

                    const SizedBox(height: 10), Row(
                      children: [
                        Text("Shift Name : ",style: TextStyle(fontWeight: FontWeight.w500),),
                        Text( "${shiftName}"),
                      ],
                    ),     const SizedBox(height: 10), Row(
                      children: [
                        Text("Travel Type : ",style: TextStyle(fontWeight: FontWeight.w500),),
                        Text( "${travelType}".toUpperCase()),
                      ],
                    ),

                    Divider(),


                    const SizedBox(height: 15),

                    pass.remainingRides==0?SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Completed",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                        ],
                      ),



                    ):  // Inside passCard widget, replace the Row with Rides + View QR

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xfff2dfe0),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Rides: ${pass.remainingRides}",
                                style: TextStyle(
                                  color: ColorResource.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => _handleViewQR(context, pass, pro, readableBookingDate),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [ColorResource.primary, ColorResource.primarySec],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  "View QR",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     /// 🎫 Remaining Ride (Chip Style - NOT button)
                    //     Expanded(
                    //       child: Container(
                    //         padding: const EdgeInsets.symmetric(vertical: 12),
                    //         decoration: BoxDecoration(
                    //           color: Color(0xfff2dfe0),
                    //           // color: const Color(0xFFE6E9FF),
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         child: Center(
                    //           child: Text(
                    //             "Rides: ${pass.remainingRides}",
                    //             style:  TextStyle(
                    //               color: ColorResource.primary,
                    //               fontWeight: FontWeight.w600,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //
                    //     const SizedBox(width: 12),
                    //
                    //     /// 🚀 View QR (Primary Button)
                    //     Expanded(
                    //       child: InkWell(
                    //         borderRadius: BorderRadius.circular(10),
                    //         onTap: () async {
                    //           showLoader(context);
                    //
                    //           await pro.generateQrApi(
                    //             context: context,
                    //             transactionId: pass.sId ?? "",
                    //             source:  pass.source ?? "_",
                    //             destination:  pass.destination ?? "_",
                    //             // source: widget.source,
                    //             // destination:widget.destination ,
                    //           );
                    //
                    //           navPop(context: context);
                    //
                    //           /// 👉 QR Dialog (same as your code)
                    //           showQrDialog(context:context, pro:pro,scheduledAt: "${readableBookingDate} | ${departureTime}");
                    //         },
                    //         child: Container(
                    //           padding: const EdgeInsets.symmetric(vertical: 12),
                    //           decoration: BoxDecoration(
                    //             // color: ColorResource.primary,
                    //             gradient:  LinearGradient(
                    //               colors: [
                    //                 ColorResource.primary,
                    //                 ColorResource.primarySec,
                    //               ],
                    //               begin: Alignment.topCenter,
                    //               end: Alignment.bottomCenter,
                    //             ),
                    //             borderRadius: BorderRadius.circular(10),
                    //           ),
                    //           child: const Center(
                    //             child: Text(
                    //               "View QR",
                    //               style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontWeight: FontWeight.w600,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // )

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _locationTile({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
  Widget _dot() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: ColorResource.primary,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 50,
      width: 2,
      color: ColorResource.primary.withOpacity(0.2),
    );
  }
  void showQrDialog({required BuildContext context,required MyShuttleViewModel pro,required String scheduledAt}) {
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
                        style:  TextStyle(
                          color: ColorResource.primary,
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
                              color: ColorResource.primary,
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
                      Row(
                        children: [
                          Text("Scheduled At : ",style: TextStyle(fontWeight: FontWeight.w500,),),
                          Text( "${scheduledAt}"),
                        ],
                      ),

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
                        onPressed:(){
                          navPushReplace(context: context, action: MainScreen(currentIndex: 2,));
                        },
                        child: const Text(
                          "Close",
                          style: TextStyle(  color: ColorResource.primary,),
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