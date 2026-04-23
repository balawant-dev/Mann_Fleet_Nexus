import 'package:flutter/material.dart';
import 'package:mannfleet/widget/navigator_method.dart';

import '../../../widget/custom_appBar.dart';
import '../model/getComplaintsModel.dart';
import '../viewModel/complaintsPro.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ← add this to pubspec.yaml for nice date formatting
import 'package:provider/provider.dart';

import '../../../widget/custom_appBar.dart';
import '../viewModel/complaintsPro.dart';
import 'complaintsDetailScreen.dart';

class ComplaintHistoryScreen extends StatefulWidget {
  const ComplaintHistoryScreen({super.key});

  @override
  State<ComplaintHistoryScreen> createState() => _ComplaintHistoryScreenState();
}

class _ComplaintHistoryScreenState extends State<ComplaintHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ComplaintsProvider>().getComplaintsApi(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Complaint History',
        isBack: true,
      ),
      body: Consumer<ComplaintsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = provider.getComplaintsModel?.data ?? [];

          if (complaints.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            itemCount: complaints.length,
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return _buildComplaintCard(complaint);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sentiment_dissatisfied_rounded,
            size: 72,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No complaints yet",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "When you file a complaint,\nit will appear here.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplaintCard(MyComplaintData complaint) {
    final date = complaint.createdAt != null
        ? DateTime.tryParse(complaint.createdAt!)
        : null;

    final formattedDate = date != null
        ? DateFormat("dd MMM yyyy • hh:mm a").format(date)
        : "Date unavailable";

    final status = (complaint.ticketStatus ?? "unknown").toLowerCase();
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "open":
      case "pending":
        statusColor = Colors.orange.shade700;
        statusIcon = Icons.hourglass_top_rounded;
        break;
      case "in progress":
        statusColor = Colors.blue.shade700;
        statusIcon = Icons.autorenew_rounded;
        break;
      case "resolved":
      case "closed":
        statusColor = Colors.green.shade700;
        statusIcon = Icons.check_circle_rounded;
        break;
      case "rejected":
        statusColor = Colors.red.shade700;
        statusIcon = Icons.cancel_rounded;
        break;
      default:
        statusColor = Colors.grey.shade700;
        statusIcon = Icons.help_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          navPush(context: context, action: ComplaintHistoryDetailScreen(id:        complaint.sId.toString(),));
          // TODO: Navigate to detail screen if you have one
          // Navigator.push(...);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Category + Ticket ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      complaint.issueCategory?.toUpperCase() ?? "UNKNOWN ISSUE",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      complaint.ticketId ?? "—",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                complaint.description?.trim() ?? "No description provided",
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  color: Colors.grey.shade800,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Bottom row: Status + Date + Media hint
              Row(
                children: [
                  Icon(statusIcon, size: 18, color: statusColor),
                  const SizedBox(width: 6),
                  Text(
                    complaint.ticketStatus?.toUpperCase() ?? "UNKNOWN",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Optional: show if there are images/videos
              if ((complaint.imageFiles?.isNotEmpty ?? false) ||
                  (complaint.videoFiles?.isNotEmpty ?? false)) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.image_outlined, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      "${complaint.imageFiles?.length ?? 0} image${(complaint.imageFiles?.length ?? 0) != 1 ? 's' : ''}"
                          "${(complaint.videoFiles?.isNotEmpty ?? false) ? ' • ${complaint.videoFiles?.length ?? 0} video${(complaint.videoFiles?.length ?? 0) != 1 ? 's' : ''}' : ''}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}