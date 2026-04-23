import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:provider/provider.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/constants/sizes.dart';
import '../../../util/image_resource/image_resource.dart';
import '../provider/onBordingProvider.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    AppSizes.init(context);
    return Consumer<OnBordingProvider>(
        builder: (context, provider, child) {
          return  Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: screenHeight * 0.6625,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: ColorResource.onbording,
                        image: DecorationImage(
                          image: AssetImage(AppImages.onbording),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.065),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1,
                                      color: ColorResource.white
                                  ),
                                  borderRadius: BorderRadius.circular(50)
                              ),
                              child: CustomText(
                                'ELITE TRAVEL',
                                size: AppSizes.size12,
                                weight: FontWeight.w700,
                                color: ColorResource.white,
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.415),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: CustomText(
                              'Your Luxury & Safe \nride',
                              size: 32,
                              weight: FontWeight.w700,
                              color: ColorResource.white,
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: screenHeight * 0.3375,
                      width: screenWidth,
                      color: ColorResource.onbording,
                      child: Column(
                        children: [
                          SizedBox(height: screenHeight * 0.13875,),
                          CustomButton(
                              backgroundColor: ColorResource.white,
                              textColor: ColorResource.black,
                              title: 'Get Started',
                              onTap: (){
                                provider.goToLogin(context);
                                //navPush(context: context, action: LoginScreen());
                              }
                          ),
                          SizedBox(height: screenHeight * 0.02875,),
                          // CustomButton(
                          //     borderColor: ColorResource.white,
                          //     backgroundColor: ColorResource.onbording,
                          //     textColor: ColorResource.white,
                          //     title: 'Already have an account?Log in',
                          //     onTap: (){}
                          // )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                    right: 40,
                    left: 20,
                    top: screenHeight * 0.6455,
                    child: CustomText(
                      'Experience luxury transit. Premium\nairport transfers and executive city\ntravel at your fingertips.',
                      size: AppSizes.size16,
                      weight: FontWeight.w500,
                      color: ColorResource.white,)
                )
              ],
            ),
          );
        }
    );
  }
}