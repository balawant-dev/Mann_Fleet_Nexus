import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/presentaion/bookingHistory/ui/ratingBottomSheet.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../../../apiservice/payment/paymentService.dart';
import '../../../apiservice/services/appConfigService.dart';
import '../../../util/FontResource/FontResource.dart';
import '../../../widget/custom_appBar.dart';

import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../booking/booking/ui/widget/bookingProcessingWidget.dart';

import '../../bottomBar/bottomBar.dart';
import '../../profile/viewModel/profileViewModel.dart';
import '../helper/bookingMessageScreen.dart';
import '../model/myBookingHistoryModel.dart';
import '../provider/bookingHistoryProvider.dart';
import 'bookingHistoryDetailScreen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Load data when screen opens
    Future.microtask(() {
      context.read<BookingHistoryProvider>().myBookingHistoryApi(
        context: context,
      );
    });
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = context.read<BookingHistoryProvider>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !provider.isLoadingMore &&
        provider.hasMore) {
      provider.myBookingHistoryApi(context: context);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingHistoryProvider>(
      context,
      listen: false,
    );
    // final provider = context.read<BookingHistoryProvider>();
    // provider.myBookingHistoryApi(context: context);
    return Scaffold(
      appBar: CustomAppBar(
        isBack: true,
        title: 'My Bookings',
        onActionTap: () {
          print("Setting clicked");
        },
        onBackTap: () {
          MainScreen.changeTab(context, 0);
        },
      ),
      body: Consumer<BookingHistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final model = provider.myBookingHistoryModel;

          if (model == null) {
            return const Center(
              child: Text("Loading bookings, please wait..."),
            );
            // return const Center(child: Text("Failed to load bookings"));
          }
          if (provider.bookingList.isEmpty) {
            return const BookingMessageScreen();
          }

          // if (model.status != true ||
          //     model.data == null ||
          //     model.data!.isEmpty) {
          //   return const BookingMessageScreen();
          // }

          return Stack(
            children: [
              // Main Content
              if (provider.isLoading && provider.myBookingHistoryModel == null)
                const Center(child: CircularProgressIndicator())
              else
                RefreshIndicator(
                  onRefresh: () async {
                    await provider.myBookingHistoryApi(
                      context: context,
                      isRefresh: true,
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 12,
                    ),
                    itemCount:
                        provider.bookingList.length +
                        (provider.isLoadingMore ? 1 : 0),
                    // itemCount: provider.myBookingHistoryModel?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      if (index == provider.bookingList.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(strokeWidth: 3),
                          ),
                        );
                      }
                      final booking = provider.bookingList[index];
                      // final booking = provider.myBookingHistoryModel!.data![index];
                      return BookingCard(
                        booking: booking,
                        cancelTab: () async {
                          // showLoader(context);

                          final success = await provider.bookingCancelApi(
                            context: context,
                            id: booking.id.toString(),
                          );

                          // if (Navigator.canPop(context)) {
                          //   Navigator.of(context, rootNavigator: true).pop(); // close loader
                          // }
                          // navPop(context: context);
                          // if (!context.mounted) return;

                          ToastHelper.show(
                            context,
                            message:
                                success
                                    ? "Booking cancelled successfully. Amount refunded to wallet."
                                    : "Failed to cancel booking.",
                          );
                        },
                      );
                    },
                  ),
                ),

              // ✅ Top Linear Loader (Smooth UX)
              if (provider.isRefreshing)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(minHeight: 2),
                ),
            ],
          );
        },
      ),
    );
  }
}

// ────────────────────────────────────────────────
//               Booking Card Widget
// ────────────────────────────────────────────────
class BookingCard extends StatelessWidget {
  final BookingHistoryData booking;
  final VoidCallback cancelTab;

  BookingCard({super.key, required this.booking, required this.cancelTab});

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "—";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat("dd MMM yyyy • hh:mm a").format(date);
    } catch (_) {
      return isoDate;
    }
  }

  final RazorpayService razorpayService = RazorpayService();
  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case "not_started":
        return Colors.orange;

      case "driver_enroute":
        return Colors.blue;

      case "arrived":
        return Colors.purple;

      case "in_progress":
        return Colors.teal;

      case "completed":
        return Colors.green;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  String getTripStatusText(String? status) {
    switch (status) {
      case "not_started":
        return "NOT STARTED";

      case "driver_enroute":
        return "DRIVER ACCEPTED";

      case "arrived":
        return "ARRIVED";

      case "in_progress":
        return "IN PROGRESS";

      case "completed":
        return "COMPLETED";

      case "cancelled":
        return "CANCELLED";

      default:
        return "UNKNOWN";
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = booking.overallStatus ?? booking.tripStatus ?? "Unknown";
    final pickupAddr = booking.pickup?.address ?? "—";
    final dropAddr = booking.dropoff?.address ?? "—";
    final createdOn = _formatDate(booking.createdAtIST);
    final scheduledAtIST = _formatDate(booking.scheduledAtIST);
    final isPendingPayment =
        booking.paymentStatus?.toLowerCase() == "pending" ||
        booking.overallStatus?.toLowerCase() == "pending_payment";

    print("isPendingPayment ${isPendingPayment}");
    print("booking.paymentStatus ${booking.paymentStatus}");
    print("booking.paymentStatus ${booking.overallStatus}");

    final tripStatus = booking.tripStatus?.toLowerCase() ?? "";
    final isInProgress = tripStatus == "in_progress";

    final userStatus = getTripStatusText(booking.tripStatus);

    final isCompleted = booking.overallStatus?.toLowerCase() == "completed";
    print("Trip status>>>>>>>>>>>${booking.tripStatus}");
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        navPush(
          context: context,
          action: BookingHistoryDetailScreen(id: booking.id.toString()),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        /// 🔥 OUTER CARD
        decoration: BoxDecoration(
          color: ColorResource.primary.withOpacity(0.15),
          // color: Colors.grey.withOpacity(0.5),
          // color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Container(
          // padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(6),

          /// 🔥 INNER CARD
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
          child: Stack(
            children: [
              if (isCompleted)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Image.asset(
                    "assets/icon/completedStamp.png",
                    height: 40,
                    width: 40,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Booking ID : ${booking.bookingNumber ?? '—'}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        if (isInProgress)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.directions_car,
                                  size: 14,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "Trip In Progress",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF03045E).withOpacity(.08),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            booking.segment?.name?.toUpperCase() ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF03045E),
                            ),
                          ),
                        ),
                        // Text(
                        //   booking.segment!.name!.toUpperCase(),
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: isCompleted
                        //         ? Colors.green
                        //         : Colors.grey.shade700,
                        //   ),
                        // ),
                        SizedBox(width: 8),
                        // Text(
                        //   userStatus.toUpperCase(),
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: isCompleted
                        //         ? Colors.green
                        //         : Colors.grey.shade700,
                        //   ),
                        // ),

                        // SizedBox(width: 15,),
                        if (booking.bookingType != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF03045E).withOpacity(.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              formatBookingType(booking.bookingType),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF03045E),
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(
                              booking.tripStatus,
                            ).withOpacity(.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: getStatusColor(
                                booking.tripStatus,
                              ).withOpacity(.4),
                            ),
                          ),
                          child: Text(
                            userStatus.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: getStatusColor(booking.tripStatus),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.radio_button_checked,
                          color: Color(0xFF03045E),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            pickupAddr,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              fontFamily: FontResource.plusJakartaSans,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        size: 18,
                        color: Colors.grey,
                      ),
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFFD00000),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            dropAddr,
                            style: const TextStyle(
                              fontSize: 12,
                              height: 1.35,
                              fontFamily: FontResource.plusJakartaSans,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24),

                    // Bottom info row
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   userStatus.toUpperCase(),
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: isCompleted
                        //         ? Colors.green
                        //         : Colors.grey.shade700,
                        //   ),
                        // ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              "Scheduled At : ",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              "${scheduledAtIST}",
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              "Created On : ",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              " $createdOn",
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Status : ",
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),

                            Text(
                              "${formatBookingType(booking.paymentStatus ?? "—")}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                          ],
                        ),
                        Text(
                          booking.finalFare != null
                              ? "₹ ${booking.finalFare!.toStringAsFixed(2)}"
                              : "₹ ${booking.estimatedFare?.toStringAsFixed(2) ?? '0.00'}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF03045E),
                          ),
                        ),
                        // Text(
                        //   "₹ ${booking.finalFare?.toStringAsFixed(0) ?? '—'}",
                        //   style: const TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xFF03045E),
                        //   ),
                        // ),

                        // Text(
                        //   "₹ ${booking.estimatedFare?.toStringAsFixed(0) ?? '—'}",
                        //   style: const TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xFF03045E),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 14),
                    if (isInProgress)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: const Text(
                          "🚖 Your trip is currently in progress",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (booking.tripStatus != "cancelled" &&
                                  booking.paymentStatus != "pending" &&
                                  booking.tripStatus == "not_started")
                              ? GestureDetector(
                                onTap: cancelTab,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )
                              : const SizedBox(),
                          //not_started

                          /// 🔹 Booking Type Chip
                          // detedt

                          /// 🔹 OTP Section (Start + End)
                          // Row(
                          //   children: [
                          //     /// ✅ Start OTP
                          //     _otpBox(
                          //       context,
                          //       label: "Start",
                          //       otp: booking.tripStartOtp ?? "1234",
                          //     ),
                          //
                          //     const SizedBox(width: 10),
                          //
                          //     /// 🔥 Divider Line (Premium touch)
                          //     Container(
                          //       height: 30,
                          //       width: 1,
                          //       color: Colors.grey.shade300,
                          //     ),
                          //
                          //     const SizedBox(width: 10),
                          //
                          //     /// ✅ End OTP
                          //     _otpBox(
                          //       context,
                          //       label: "End",
                          //       otp: booking.tripEndOtp ?? "1234",
                          //     ),
                          //   ],
                          // ),
                          isPendingPayment
                              ? InkWell(
                                onTap: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    isDismissible: false,
                                    enableDrag: false,
                                    backgroundColor: Colors.white,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    builder:
                                        (_) => BookingProcessingWidget(
                                          key: bookingKey,
                                        ),
                                  );

                                  bookingKey.currentState?.showPayment();

                                  final provider =
                                      context.read<BookingHistoryProvider>();

                                  final ok = await provider.retryPayment(
                                    context: context,
                                    bookingId: booking.id ?? "",
                                  );

                                  if (!ok) {
                                    await Future.delayed(
                                      const Duration(seconds: 1),
                                    );

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Unable to start payment",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final razor =
                                      provider
                                          .paymentRetryModel
                                          ?.data
                                          ?.razorpay;

                                  if (razor == null) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Payment data missing"),
                                      ),
                                    );
                                    return;
                                  }

                                  /// USER DETAILS
                                  final profile =
                                      context
                                          .read<ProfileDetailViewModel>()
                                          .getProfileModel
                                          ?.data
                                          ?.user;

                                  final razorKey =
                                      await AppConfigService.getRazorKey();

                                  razorpayService.onSuccess = (response) async {
                                    bookingKey.currentState?.showSuccess();

                                    await Future.delayed(
                                      const Duration(milliseconds: 800),
                                    );

                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Payment Successful ✅"),
                                      ),
                                    );

                                    context
                                        .read<BookingHistoryProvider>()
                                        .myBookingHistoryApi(
                                          context: context,
                                          isRefresh: true,
                                        );
                                  };

                                  razorpayService.onError = (response) async {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          response.message ?? "Payment Failed",
                                        ),
                                      ),
                                    );
                                  };

                                  razorpayService.openCheckoutWithOrderId(
                                    amount: razor.amount ?? 0,
                                    orderId: razor.orderId ?? "",
                                    key: razorKey,
                                    name: "Mann Fleet",
                                    description: "Complete Booking Payment",
                                    contact: profile?.mobile ?? "",
                                    email: profile?.email ?? "",
                                  );
                                },

                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.payment,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        "Complete Payment",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              : isCompleted
                              ? booking.ratings != null &&
                                      booking.ratings!.isNotEmpty
                                  ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.star_rounded,
                                          color: Colors.amber,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          booking.ratings!.first.userRating
                                                  ?.toStringAsFixed(1) ??
                                              "5",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        const Text("Rated"),
                                      ],
                                    ),
                                  )
                                  : InkWell(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder:
                                            (_) => RatingBottomSheet(
                                              bookingId: booking.id ?? "",
                                              driverName:
                                                  booking.driver?.name ??
                                                  "Driver",
                                            ),
                                      );

                                      context
                                          .read<BookingHistoryProvider>()
                                          .myBookingHistoryApi(
                                            context: context,
                                            isRefresh: true,
                                          );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF03045E),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "Rate Ride",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              /// OTP
                              : isInProgress
                              ? _otpBox(
                                context,
                                label: "End",
                                otp: booking.tripEndOtp,
                              )
                              : Row(
                                children: [
                                  _otpBox(
                                    context,
                                    label: "Start",
                                    otp: booking.tripStartOtp,
                                  ),
                                  const SizedBox(width: 10),
                                  _otpBox(
                                    context,
                                    label: "End",
                                    otp: booking.tripEndOtp,
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatBookingType(String? type) {
    if (type == null || type.isEmpty) return "—";

    return type
        .replaceAll("_", " ") // one_way → one way
        .split(" ") // ["one", "way"]
        .map((word) => word[0].toUpperCase() + word.substring(1)) // One Way
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
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 2),
            Text(
              otp ?? "----",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
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
            child: const Icon(Icons.copy, size: 14, color: Color(0xFF03045E)),
          ),
        ),
      ],
    );
  }
}
