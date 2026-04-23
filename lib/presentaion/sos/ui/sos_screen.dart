import 'package:flutter/material.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_text.dart';

import '../../../util/color/app_colors.dart';
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'MANN',subTitle: 'Your Luxury & Safe ride',),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  'Emergency Help',
                  size: 30,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),
                SizedBox(height: 10,),
                CustomText(
                  'Press the button below. Our safety team\nand local authorities will be notified\nimmediately.',
                  size: 14,
                  weight: FontWeight.w400,
                  color: ColorResource.textBlack,
                  align: TextAlign.center,
                ),
                SizedBox(height: 35,),
                CustomImageView(
                    imagePath: AppImages.sosActive,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 35,),
                sosActiveCard(
                  image: AppImages.callIcon,
                  title: 'Emergency Services (112)',
                  subTitle: 'Direct line to ambulance/police',
                  onTap: (){}
                ),
                SizedBox(height: 10,),
                sosActiveCard(
                    image: AppImages.shareImage,
                    title: 'Share Live Location',
                    subTitle: 'Alert your trusted contacts',
                    onTap: (){}
                ),
                SizedBox(height: 10,),
                sosActiveCard(
                    image: AppImages.notifyImage,
                    title: 'Notify Nearest Police',
                    subTitle: 'Silent alarm to local station',
                    onTap: (){}
                ),
                SizedBox(height: 20,),
                Container(
                  width: 202,
                  padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: ColorResource.sosActive
                  ),
                  child: Row(
                    children: [
                      CustomImageView(
                          imagePath: AppImages.active,
                        height: 20,
                        width: 16,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10,),
                      CustomText(
                        'Secure Connection Active',
                        size: 12,
                        weight: FontWeight.w700,
                        color: ColorResource.textColor.withOpacity(0.6)
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget sosActiveCard({
    required String image,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: ColorResource.homeOption,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x0C000000),
              blurRadius: 2,
              offset: Offset(0, 1),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          children: [
            CustomImageView(
                imagePath: image,
              height: 48,
              width: 48,
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                 title,
                  size: 14,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),
                CustomText(
                  subTitle,
                  size: 12,
                  weight: FontWeight.w400,
                  color: ColorResource.textBlack,
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,color: ColorResource.textBlack,size: 18,)
          ],
        ),
      ),
    );
  }
}
