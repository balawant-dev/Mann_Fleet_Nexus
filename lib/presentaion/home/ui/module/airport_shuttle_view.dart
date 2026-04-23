import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../provider/homeProvider.dart';
import '../widget/headerDetails.dart';


class AirportShuttleView extends StatelessWidget {
  final HomeProvider provider;
  final double screenHeight;
  final double screenWidth;

  const AirportShuttleView({
    super.key,
    required this.provider,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // HeaderDetailScreen(
        //   provider: provider,
        //   screenHeight: screenHeight,
        //   screenWidth: screenWidth,
        //   image: AppImages.carImage, // ← better if you have a shuttle-specific image
        //   title: 'Comfortable Airport Shuttle',
        //   subTitle: 'Shared rides • Fixed fares • No surge pricing',
        // ),
        SizedBox(height: screenHeight * 0.02),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: ShapeDecoration(
            color: ColorResource.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: ColorResource.homeOption),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                "Flight Details",
                size: 16,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              const SizedBox(height: 12),

              // Flight number input
              TextField(
                decoration: InputDecoration(
                  hintText: "Enter flight number (e.g. AI 423)",
                  hintStyle: TextStyle(color: ColorResource.textBlack.withOpacity(0.6)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorResource.homeOption),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorResource.blueText, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 16),

              // Optional: Airline / Arrival time / Terminal (you can expand later)
              TextField(
                decoration: InputDecoration(
                  hintText: "Terminal (optional)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: ColorResource.homeOption),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                title: "Find Shuttle",
                onTap: () {
                  // TODO: Validate flight number & navigate / call API
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}