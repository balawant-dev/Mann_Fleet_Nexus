import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widget/custom_appBar.dart';

import '../viewModel/NotificationPro.dart';

class NotificationDetailScreen extends StatefulWidget {
  final String id;
  const NotificationDetailScreen({super.key, required this.id});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState
    extends State<NotificationDetailScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<NotificationProvider>().getNotificationDetailApi(
        context: context,
        id: widget.id,
      );
    });
  }

  Future<void> _onRefresh() async {
    await context.read<NotificationProvider>().getNotificationDetailApi(
      context: context,
      id: widget.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Notification Detail",isBack: true,),

      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {

          final data = provider.notificationDetailModel?.data;

          return Column(
            children: [

              /// 🔥 Top Soft Loader
              if (provider.isLoading)
                const LinearProgressIndicator(),

              Expanded(
                child: provider.isLoading && data == null
                    ? const Center(child: CircularProgressIndicator())

                    : data == null
                    ? const Center(child: Text("No Data Found"))

                    : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        /// 🔷 Title Card
                        _card(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [

                              Text(
                                data.title ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                data.body ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 14,
                                      color:
                                      Colors.grey.shade600),
                                  const SizedBox(width: 5),
                                  Text(
                                    data.createdAt ?? "",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// 🔷 Booking Details
                        if (data.booking != null)
                          _card(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Booking Details",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                _row("Booking ID",
                                    data.booking?.bookingNumber),
                                _row("Trip Status",
                                    data.booking?.tripStatus),
                                _row("Overall Status",
                                    data.booking?.overallStatus),
                                _row("Scheduled At",
                                    data.booking?.scheduledAtIST),
                                _row("Start Time",
                                    data.booking?.tripStartAtIST),
                                _row("End Time",
                                    data.booking?.tripEndAtIST),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔷 Reusable Card
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),        // ← Changed: Soft elegant background
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE2E8F0),      // ← Changed: Cleaner border
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),           // ← Softer shadow
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // decoration: BoxDecoration(
      //   color: Colors.white,
      //   borderRadius: BorderRadius.circular(14),
      //   border: Border.all(color: Colors.grey.shade200),
      //   boxShadow: [
      //     BoxShadow(
      //       blurRadius: 8,
      //       color: Colors.black.withOpacity(0.05),
      //       offset: const Offset(0, 3),
      //     )
      //   ],
      // ),
      child: child,
    );
  }

  /// 🔷 Row UI
  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value ?? "-",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}