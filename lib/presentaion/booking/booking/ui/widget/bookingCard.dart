import 'package:flutter/material.dart';

import '../../../../../util/color/app_colors.dart';
import '../../../../../widget/customImageView.dart';
import '../../../../../widget/custom_text.dart';


class BookingCard2 extends StatefulWidget {

  final String title;

  final String finalPayableAmount;
  final String totalAmount;

  final String time;

  final String bookingType;


  const BookingCard2({
    super.key,
    required this.time,

    required this.title,

    required this.finalPayableAmount,
    required this.totalAmount,

    required this.bookingType,
  });

  @override
  State<BookingCard2> createState() => _BookingCard2State();
}

class _BookingCard2State extends State<BookingCard2> {
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
                      width: MediaQuery.of(context).size.width * 0.65,
                      // width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            widget.title,
                            size: 16,
                            weight: FontWeight.w700,
                            color: ColorResource.black,
                          ),SizedBox(height: 10,), widget. bookingType=="hourly"   ?SizedBox(child: Text("Note: Charges depend on vehicle type and selected hours.",    style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: ColorResource.viewText,
                          ),),):
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
                          ),SizedBox(height: 5,),
                          CustomText(
                            _formatPrice(widget.totalAmount),
                            size: 18,
                            weight: FontWeight.w700,
                            color: ColorResource.black,
                          ),

                        ],
                      ),
                    ),

                    /// PRICE
                    ///

                  ],
                ),



                /// TIME + DISTANCE (NO OVERFLOW)

              ],
            ),
          ),
        ],
      ),
    );
  }
}
String _formatPrice(dynamic price) {
  if (price == null) {
    return "₹ 0.0";
  }

  try {
    double? value;

    if (price is int) {
      value = price.toDouble();
    } else if (price is double) {
      value = price;
    } else if (price is String) {
      value = double.tryParse(price);
    }

    if (value == null) {
      return "₹ 0.0";
    }

    return "₹ ${value.toStringAsFixed(1)}";
  } catch (e) {
    return "₹ 0.0";
  }
}