import 'package:flutter/material.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/customImageView.dart';
import '../../../../widget/custom_text.dart';

class BookingCard extends StatefulWidget {
  final String image;
  final String title;
  final String subTitle;
  final String price;
  final String time;
  final String away;

  const BookingCard({
    super.key,
    required this.time,
    required this.image,
    required this.title,
    required this.away,
    required this.price,
    required this.subTitle,
  });

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFF1F5F9),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Container(
            width: 64,
            height: 64,
            decoration: ShapeDecoration(
              color: const Color(0xFFF1F5F9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: widget.image,
                imageType: ImageType.network,
                fit: BoxFit.contain,
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE + PRICE (AUTO WRAP)
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: [

                    /// TITLE (auto next line)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: CustomText(
                        widget.title,
                        size: 16,
                        weight: FontWeight.w700,
                        color: ColorResource.black,
                      ),
                    ),

                    /// PRICE
                    CustomText(
                      "₹ ${double.parse(widget.price).toStringAsFixed(1)}",
                      size: 18,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                /// TIME + DISTANCE (NO OVERFLOW)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomImageView(
                      imagePath: "assets/images/locationImage.png",
                      height: 13,
                      width: 13,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        widget.time,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: ColorResource.viewText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}