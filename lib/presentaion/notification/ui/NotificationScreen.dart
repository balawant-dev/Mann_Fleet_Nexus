import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // add to pubspec: intl: ^0.19.0 or latest
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';

import '../../../widget/custom_appBar.dart';
import '../viewModel/NotificationPro.dart';
import 'notificationDetailScreen.dart'; // adjust path if needed

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<NotificationProvider>(context, listen: false);
      provider.getNotificationApi(context: context);
    });
  }

  Future<void> _refresh() async {
    final provider = Provider.of<NotificationProvider>(context, listen: false);
    await provider.getNotificationApi(context: context);
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'Just now';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      return DateFormat('dd MMM, hh:mm a').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Notifications",
        isBack: true,

        // actions: [
        //   Consumer<NotificationProvider>(
        //     builder: (context, provider, _) {
        //       final unread = provider.getNotificationModel?.unreadCount ?? 0;
        //       if (unread == 0) return const SizedBox.shrink();
        //
        //       return Padding(
        //         padding: const EdgeInsets.only(right: 16),
        //         child: Stack(
        //           alignment: Alignment.center,
        //           children: [
        //             const Icon(Icons.notifications_none, size: 28),
        //             if (unread > 0)
        //               Positioned(
        //                 right: 0,
        //                 top: 0,
        //                 child: Container(
        //                   padding: const EdgeInsets.all(4),
        //                   decoration: const BoxDecoration(
        //                     color: Colors.red,
        //                     shape: BoxShape.circle,
        //                   ),
        //                   constraints: const BoxConstraints(
        //                     minWidth: 18,
        //                     minHeight: 18,
        //                   ),
        //                   child: Text(
        //                     unread > 99 ? '99+' : '$unread',
        //                     style: const TextStyle(
        //                       color: Colors.white,
        //                       fontSize: 10,
        //                       fontWeight: FontWeight.bold,
        //                     ),
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //               ),
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final model = provider.getNotificationModel;

          if (model == null || model.status != true) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 70, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  const Text(
                    "Failed to load notifications",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: () => _refresh(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (model.data == null || model.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No notifications yet",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: model.data!.length,
              itemBuilder: (context, index) {
                final notification = model.data![index];
                final isUnread = notification.isRead == false;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isUnread ? 3 : 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: isUnread ? Colors.blue.shade50 : Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      navPush(context: context, action: NotificationDetailScreen(id: notification.sId.toString(),));
                      // Optional: mark as read + navigate to booking detail
                      // provider.markAsRead(notification.sId ?? '');
                      // if (notification.booking != null) {
                      //   // TODO: navigate to booking detail screen
                      //   // Navigator.pushNamed(context, '/booking-detail', arguments: notification.booking);
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text("Booking: ${notification.booking?.bookingNumber}")),
                      //   );
                      // }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread dot
                          if (isUnread)
                            Container(
                              margin: const EdgeInsets.only(right: 12, top: 6),
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                            ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  notification.title ?? "Notification",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isUnread ? FontWeight.w700 : FontWeight.w600,
                                    color: isUnread ? Colors.black87 : Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Body
                                Text(
                                  notification.body ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade800,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Type + Time + Booking info
                                Row(
                                  children: [
                                    if (notification.type != null) ...[
                                      Chip(
                                        label: Text(
                                          notification.type!.toUpperCase(),
                                          style: const TextStyle(fontSize: 10),
                                        ),
                                        backgroundColor: Colors.grey.shade200,
                                        padding: EdgeInsets.zero,
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    Text(
                                      _formatDate(notification.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),

                                // Booking number (if exists)
                                if (notification.booking?.bookingNumber != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    "Booking #${notification.booking!.bookingNumber}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                ],

                                // Optional status chip
                                if (notification.booking?.overallStatus != null) ...[
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(notification.booking!.overallStatus!),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      notification.booking!.overallStatus!.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'finished':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'ongoing':
      case 'started':
        return Colors.orange;
      case 'scheduled':
      case 'assigned':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}