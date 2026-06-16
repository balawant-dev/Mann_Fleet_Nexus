import 'package:flutter/material.dart';

import '../../model/recent_booking_model.dart';

class BookingIcon extends StatelessWidget {
  final BookingType type;

  const BookingIcon({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    IconData icon;

    switch (type) {
      case BookingType.cab:
        icon = Icons.local_taxi;
        break;
      case BookingType.bus:
        icon = Icons.directions_bus;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 22),
    );
  }
}

class BookingTile extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingTile({super.key, required this.booking, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            BookingIcon(type: booking.type),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(booking.title /*style: AppTextStyles.title*/),
                  const SizedBox(height: 4),
                  Text(
                    "${booking.dateTime.day} Oct, ${booking.dateTime.hour}:${booking.dateTime.minute.toString().padLeft(2, '0')}",
                    /* style: AppTextStyles.subtitle,*/
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "₹${booking.price.toStringAsFixed(0)} Paid",
                  // style: AppTextStyles.price,
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
