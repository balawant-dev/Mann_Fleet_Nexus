import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
class BookingMessageScreen extends StatelessWidget {
  const BookingMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// TOP ICON
          Container(
            height: 95,
            width: 95,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorResource.primary.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              size: 48,
              color: ColorResource.primary,
            ),
          ),

          const SizedBox(height: 22),

          /// TITLE
          const Text(
            "No Bookings Yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          /// SUBTITLE
          const Text(
            "You haven’t made any bookings yet.\nYour booking history will appear here once you book a ride.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          /// INFO BOX
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: ColorResource.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: ColorResource.primary,
                  size: 18,
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "Make a booking to see your booking history here.",
                    style: TextStyle(
                      color: ColorResource.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
