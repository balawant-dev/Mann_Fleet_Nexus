import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../../../util/FontResource/FontResource.dart';
import '../../../widget/custom_appBar.dart';

import '../../bottomBar/bottomBar.dart';
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
      context.read<BookingHistoryProvider>().myBookingHistoryApi(context: context);
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
            return const Center(child: Text("Failed to load bookings"));
          }

          if (model.status != true || model.data == null || model.data!.isEmpty) {
            return const Center(
              child: Text(
                "No bookings found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    itemCount: provider.bookingList.length + (provider.isLoadingMore ? 1 : 0),
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
                      return BookingCard(booking: booking);
                    },
                  ),
                ),

              // ✅ Top Linear Loader (Smooth UX)
              if (provider.isRefreshing)
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    minHeight: 2,
                  ),
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

  const BookingCard({super.key, required this.booking});

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "—";
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat("dd MMM yyyy • hh:mm a").format(date);
    } catch (_) {
      return isoDate;
    }
  }



  @override
  Widget build(BuildContext context) {
    final status = booking.overallStatus ?? booking.tripStatus ?? "Unknown";
    final pickupAddr = booking.pickup?.address ?? "—";
    final dropAddr = booking.dropoff?.address ?? "—";
    final bookingDate = _formatDate(booking.scheduledAt ?? booking.createdAt);
    final createdDate = _formatDate(booking.createdAtIST);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        navPush(context: context, action: BookingHistoryDetailScreen(id: booking.id.toString(),));
        // TODO: Navigate to booking detail screen
        // Navigator.pushNamed(context, '/booking-detail', arguments: booking);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),

        /// 🔥 OUTER CARD
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
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
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row - Booking # + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Booking ID : ${booking.bookingNumber ?? '—'}",
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        fontFamily: FontResource.plusJakartaSans,
                        // fontFamily: FontResource.plusJakartaSans,
                      ),
                    ),
        
                  ],
                ),
        
                const SizedBox(height: 12),
        
                // Pickup → Dropoff
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.radio_button_checked, color: Color(0xFF03045E), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        pickupAddr,
                        style: const TextStyle(fontSize: 12.5, height: 1.35,         fontFamily: FontResource.plusJakartaSans,),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
        
        
                      ),
                    ),
                  ],
                ),
        
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Icon(Icons.arrow_downward_rounded, size: 18, color: Colors.grey),
                ),
        
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFD00000), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dropAddr,
                        style: const TextStyle(fontSize: 12.5, height: 1.35,         fontFamily: FontResource.plusJakartaSans,),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        
                const Divider(height: 24),
        
                // Bottom info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Scheduled",
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          createdDate,
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹ ${booking.estimatedFare?.toStringAsFixed(0) ?? '—'}",
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF03045E),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          formatBookingType(  booking.paymentStatus ?? "—"),
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
            SizedBox(height: 14),
        
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
                  if (booking.bookingType != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF03045E).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        formatBookingType(booking.bookingType),
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
                        otp:booking.tripStartOtp ?? "1234",
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
                        otp:booking.tripEndOtp ?? "1234",
                      ),
                    ],
                  ),
                ],
              ),
            )
        
        
        
              ],
            ),
          ),
        ),
      ),
    );
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