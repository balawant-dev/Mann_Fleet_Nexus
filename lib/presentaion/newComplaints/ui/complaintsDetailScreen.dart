import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../widget/custom_appBar.dart';
import '../../../widget/motionToastHelper.dart';
import '../model/GetComplaintsDetailModel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../viewModel/complaintsPro.dart';

class ComplaintHistoryDetailScreen extends StatefulWidget {
  final String id;
  const ComplaintHistoryDetailScreen({super.key, required this.id});

  @override
  State<ComplaintHistoryDetailScreen> createState() =>
      _ComplaintHistoryDetailScreenState();
}

class _ComplaintHistoryDetailScreenState
    extends State<ComplaintHistoryDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<ComplaintsProvider>()
          .getComplaintsDetailApi(context: context, id: widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Complaint Details',
        isBack: true,
      ),
      body: Consumer<ComplaintsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaint = provider.getComplaintsDetailModel?.data;

          if (complaint == null) {
            return _buildEmptyOrErrorState("Complaint not found");
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMainCard(complaint),
                const SizedBox(height: 20),
                _buildReporterCard(complaint.reporter),
                const SizedBox(height: 20),
                _buildMediaSection(complaint),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainCard(ComplaintDetailData complaint) {
    final date = complaint.createdAt != null
        ? DateTime.tryParse(complaint.createdAt!)
        : null;

    final formattedDate = date != null
        ? DateFormat("dd/mm/ yyyy • hh:mm a").format(date.toLocal())
        //? DateFormat("dd MMMM yyyy • hh:mm a").format(date.toLocal())
        : "Date unavailable";

    final status = (complaint.ticketStatus ?? "unknown").toLowerCase().trim();
    final (statusColor, statusIcon, statusLabel) = _getStatusStyle(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        complaint.issueCategory?.toUpperCase() ?? "UNKNOWN CATEGORY",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (complaint.otherLabel?.isNotEmpty ?? false) ...[
                        const SizedBox(height: 4),
                        Text(
                          complaint.otherLabel!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildStatusBadge(statusLabel, statusColor, statusIcon),
              ],
            ),

            const Divider(height: 32),

            // Ticket ID & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(
                  icon: Icons.confirmation_number_outlined,
                  label: "Ticket",
                  value: complaint.ticketId ?? "—",
                ),
                _buildInfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: "Filed on",
                  value: formattedDate,
                  crossRight: true,
                ),
              ],
            ),

            const Divider(height: 32),

            // Description
            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              complaint.description?.trim() ?? "No description provided.",
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReporterCard(ReporterComplaintData? reporter) {
    if (reporter == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reported by",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: reporter.profilePic != null
                      ? NetworkImage(reporter.profilePic!)
                      : null,
                  child: reporter.profilePic == null
                      ? const Icon(Icons.person, size: 32, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reporter.name ?? "Unknown User",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reporter.email ?? "—",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMediaSection(ComplaintDetailData complaint) {  // ← Use your actual Data class name
    final images = complaint.imageFiles ?? [];
    final videos = complaint.videoFiles ?? []; // might be null or empty list

    final hasMedia = images.isNotEmpty || videos!=null;
    if (!hasMedia) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Attachments",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                if (images.isNotEmpty || videos!=null)
                  Text(
                    "${images.length + 1} file${(images.length + 1) != 1 ? 's' : ''}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Images preview
            if (images.isNotEmpty) ...[
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    final url = images[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          ToastHelper.show(
                            context,
                            message: "Image ${index + 1} tapped",
                            type: ToastType.warning,
                          );

                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            width: 140,
                            height: 140,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              // Agar loadingProgress null hai, matlab image load ho chuki hai
                              if (loadingProgress == null) return child;

                              return Container(
                                width: 140,
                                height: 140,
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 140,
                              height: 140,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Videos preview (placeholder style)
            if (videos!=null) ...[
              if (images.isNotEmpty) const Divider(height: 32),
              GestureDetector(
                onTap: () {
                  //
ToastHelper.show(
context,
message: "Open video player coming soon...",
type: ToastType.warning,
);
                  // TODO: Open video player screen
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(content: Text("Open video player coming soon...")),
                  // );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${1} video${1 != 1 ? 's' : ''}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap to play",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Tap media to view full screen",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Widget _buildMediaSection(ComplaintDetailData complaint) {
  //   final hasImages = complaint.imageFiles?.isNotEmpty ?? false;
  //   final hasVideos = complaint.videoFiles?.isNotEmpty ?? false; // currently Null, but future-proof
  //
  //   if (!hasImages && !hasVideos) return const SizedBox.shrink();
  //
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.06),
  //           blurRadius: 16,
  //           offset: const Offset(0, 6),
  //         ),
  //       ],
  //     ),
  //     padding: const EdgeInsets.all(20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Text(
  //           "Attachments",
  //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  //         ),
  //         const SizedBox(height: 16),
  //         Row(
  //           children: [
  //             if (hasImages) ...[
  //               const Icon(Icons.image_outlined, color: Colors.blueGrey),
  //               const SizedBox(width: 8),
  //               Text(
  //                 "${complaint.imageFiles!.length} image${complaint.imageFiles!.length != 1 ? 's' : ''}",
  //                 style: const TextStyle(fontSize: 15),
  //               ),
  //             ],
  //             if (hasImages && hasVideos) const SizedBox(width: 24),
  //             if (hasVideos) ...[
  //               const Icon(Icons.videocam_outlined, color: Colors.blueGrey),
  //               const SizedBox(width: 8),
  //               Text(
  //                 "${complaint.videoFiles!.length} video${complaint.videoFiles!.length != 1 ? 's' : ''}",
  //                 style: const TextStyle(fontSize: 15),
  //               ),
  //             ],
  //           ],
  //         ),
  //         const SizedBox(height: 12),
  //         const Text(
  //           "Tap to view attachments",
  //           style: TextStyle(fontSize: 13, color: Colors.grey),
  //         ),
  //
  //       ],
  //     ),
  //   );
  // }

  Widget _buildEmptyOrErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool crossRight = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  (Color, IconData, String) _getStatusStyle(String status) {
    switch (status) {
      case "open":
      case "pending":
        return (Colors.orange.shade700, Icons.hourglass_top_rounded, "Pending");
      case "in progress":
      case "inprogress":
        return (Colors.blue.shade700, Icons.autorenew_rounded, "In Progress");
      case "resolved":
      case "closed":
        return (Colors.green.shade700, Icons.check_circle_rounded, "Resolved");
      case "rejected":
        return (Colors.red.shade700, Icons.cancel_rounded, "Rejected");
      default:
        return (Colors.grey.shade700, Icons.help_outline_rounded, "Unknown");
    }
  }
}