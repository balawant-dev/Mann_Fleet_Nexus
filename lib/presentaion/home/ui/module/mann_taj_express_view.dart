import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../provider/homeProvider.dart';

import '../widget/headerDetails.dart';

class MannTajExpressView extends StatelessWidget {
  final HomeProvider provider;
  final double screenHeight;
  final double screenWidth;

  const MannTajExpressView({
    super.key,
    required this.provider,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderDetailScreen(
          screenHeight: screenHeight,
          provider: provider,
          screenWidth: screenWidth,
          // image: AppImages.carImage, // ← replace with taj express / luxury car image if available

        ),
        SizedBox(height: screenHeight * 0.02),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: ColorResource.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.amber.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Popular Routes",
                size: 18,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              const SizedBox(height: 16),

              // Sample popular routes list (you can make dynamic later)
              ...[
                {"route": "Delhi → Agra", "price": "1,899", "time": "3h 30m"},
                {"route": "Delhi → Jaipur", "price": "2,499", "time": "5h"},
                {"route": "Delhi → Chandigarh", "price": "2,199", "time": "4h 15m"},
                {"route": "Delhi → Amritsar", "price": "2,999", "time": "6h"},
              ].map((route) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      Icons.directions_car,
                      color: Colors.amber[700],
                      size: 32,
                    ),
                    title: CustomText(
                      route["route"]!,
                      size: 16,
                      weight: FontWeight.w600,
                      color: ColorResource.black,
                    ),
                    subtitle: CustomText(
                      route["time"]!,
                      size: 13,
                      color: ColorResource.textBlack,
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                          "₹${route["price"]}",
                          size: 16,
                          weight: FontWeight.w700,
                          color: ColorResource.blueText,
                        ),
                        CustomText(
                          "one way",
                          size: 11,
                          color: ColorResource.Continue,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),

              CustomButton(
                title: "Book Now",
                onTap: () {
                  // TODO: Navigate to booking flow or show route selection screen
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}