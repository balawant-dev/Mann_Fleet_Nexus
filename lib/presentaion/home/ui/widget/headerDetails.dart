import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mannfleet/presentaion/home/provider/homeProvider.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/customImageView.dart';
import '../../../../widget/customShimmer.dart';
import '../../../../widget/custom_text.dart';

class HeaderDetailScreen extends StatefulWidget {
  final String image;
  final HomeProvider provider;
  final String title;
  final String subTitle;
  final double screenHeight;
  final double screenWidth;

  const HeaderDetailScreen({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.provider,
  });

  @override
  State<HeaderDetailScreen> createState() => _HeaderDetailScreenState();
}

class _HeaderDetailScreenState extends State<HeaderDetailScreen> {

  Widget bannerSection() {

    /// Loader
    if (widget.provider.bannerModel == null) {
      return CustomShimmer(width:widget. screenWidth,height:widget.screenHeight * 0.18875,radius: 16,);
    }

    /// No Data
    if (widget.provider.bannerModel!.data == null ||
        widget.provider.bannerModel!.data!.isEmpty) {
      return SizedBox(
        height: widget.screenHeight * 0.18875,
        child: const Center(
          child: Text("No Data Found"),
        ),
      );
    }

    /// Carousel Banner
    return CarouselSlider(
      options: CarouselOptions(
        height: widget.screenHeight * 0.18875,
        viewportFraction: 1,
        autoPlay: true,
      ),
      items: widget.provider.bannerModel!.data!.map((banner) {
        return Image.network(
      banner.image.toString(),
          height: widget.screenHeight * 0.18875,
          width: widget.screenWidth,
          fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
  return Image.asset("assets/images/bannerError.jpg" ,    height: widget.screenHeight * 0.18875,
    width: widget.screenWidth,);
},
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: widget.screenHeight * 0.28875,
      width: widget.screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorResource.cardHedar.withAlpha(20),
      ),
      child: Column(
        children: [

          /// Banner
          bannerSection(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: ColorResource.homeBlue,
                      ),
                      child: CustomText(
                        'BEST VALUE',
                        size: 10,
                        color: ColorResource.white,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),

                    CustomText(
                      widget.title,
                      size: 18,
                      color: ColorResource.black,
                      weight: FontWeight.w700,
                    ),
                  ],
                ),

                CustomText(
                  widget.subTitle,
                  size: 14,
                  weight: FontWeight.w400,
                  color: ColorResource.textBlack,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}