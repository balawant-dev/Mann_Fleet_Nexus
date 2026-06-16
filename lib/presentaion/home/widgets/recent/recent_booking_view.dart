import 'package:flutter/material.dart';

import '../../model/recent_booking_model.dart';
import 'booking_icon.dart';

class RecentBookingsSection extends StatelessWidget {
  final List<Booking> bookings;

  const RecentBookingsSection({super.key, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: bookings
          .map((booking) => BookingTile(booking: booking))
          .toList(),
    );
  }
}

class DealCard extends StatelessWidget {
  final Deal deal;

  const DealCard({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        // color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              // color: AppColors.tag,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(deal.tag /* style: AppTextStyles.tag*/),
          ),

          const SizedBox(height: 10),

          Text(
            deal.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),

          const SizedBox(height: 4),

          Text(
            deal.subtitle,
            // style: AppTextStyles.subtitle,
          ),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(deal.badge),
          ),
        ],
      ),
    );
  }
}

class DealsSection extends StatelessWidget {
  final List<Deal> deals;

  const DealsSection({super.key, required this.deals});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Icon(Icons.local_offer_outlined),
            SizedBox(width: 8),
            Text(
              "Grab deal of the day",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Spacer(),
            Text("View All", style: TextStyle(color: Colors.blue)),
          ],
        ),

        const SizedBox(height: 14),

        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: deals.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, index) => DealCard(deal: deals[index]),
          ),
        ),
      ],
    );
  }
}
