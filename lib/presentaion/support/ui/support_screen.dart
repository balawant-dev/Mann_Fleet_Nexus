import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:mannfleet/widget/navigator_method.dart';

import '../../sos/ui/sos_screen.dart';
class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'Mann Support',
        actionImage: AppImages.sosImage,
        onActionTap: (){
            navPush(context: context, action: SosScreen());
          print('SOS');
        },
      ),
      backgroundColor: ColorResource.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'How can we help?',
                size: 22,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              SizedBox(height: 10,),
              CustomText(
                'Find answers for your Noida commute',
                size: 14,
                weight: FontWeight.w400,
                color: ColorResource.textBlack,
              ),
              SizedBox(height: 10,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResource.homeOption,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search FAQs, ride issues...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CustomImageView(
                        imagePath: AppImages.searchImage,
                        height: 18,
                        width: 18,
                        fit: BoxFit.cover,
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minHeight: 18,
                      minWidth: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              CustomText(
                'Support Categories',
                size: 16,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              SizedBox(height: 10,),
              supportCategoriesCard(
                image: AppImages.supportCategories,
                title: 'Ride Issues',
                subTitle: 'Report lost items or late arrivals',
                onTap: (){
                  print('Ride Issues');
                },
              ),
              SizedBox(height: 10,),
              supportCategoriesCard(
                image: AppImages.paymentIcon,
                title: 'Payment Queries',
                subTitle: 'Refunds, promo codes, and invoices',
                onTap: (){
                  print('Ride Issues');
                },
              ),
              SizedBox(height: 10,),
              supportCategoriesCard(
                image: AppImages.feedback,
                title: 'App Feedback',
                subTitle: 'Suggestions for the Mann app',
                onTap: (){
                  print('Ride Issues');
                },
              ),
              SizedBox(height: 10,),
              supportCategoriesCard(
                image: AppImages.airPort,
                title: 'Airport Transfers',
                subTitle: 'Pre-booking info for IGI Airport',
                onTap: (){
                  print('Ride Issues');
                },
              ), SizedBox(height: 15,),
              CustomText(
                'Still need help?',
                size: 16,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),
              SizedBox(height: 10,),
              CustomButton(image: AppImages.chatIcon, title: 'Chat with Us', onTap: (){}),
              SizedBox(height: 10,),
              CustomButton(
                  title: 'Call Support', onTap: (){},
                image: AppImages.callImage,
                backgroundColor: ColorResource.white,
                textColor: ColorResource.buttonBackground,
                borderColor: ColorResource.buttonBackground,
              ),
              SizedBox(height: 10,),
              CustomButton(
                title: 'Raise a Formal Complaint', onTap: (){},
                image: AppImages.raiseImage,
                backgroundColor: ColorResource.white,
                textColor: ColorResource.orange,
                borderColor: ColorResource.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget supportCategoriesCard({
    required String image,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: const Color(0xFFE2E8F0),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: ColorResource.supportImage,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: image,
                  height: 20,
                  width: 20,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  size: 16,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),
                CustomText(
                 subTitle,
                  size: 12,
                  weight: FontWeight.w400,
                  color: ColorResource.textBlack,
                )
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,color: ColorResource.textBlack,size: 18,)
          ]
        ),
      ),
    );
  }
}
