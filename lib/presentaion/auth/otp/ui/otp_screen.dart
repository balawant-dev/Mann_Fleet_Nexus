import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/auth/otp/otpProvider/otpProvider.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../util/color/app_colors.dart';
import '../../../../util/constants/sizes.dart';
import '../../../../util/image_resource/image_resource.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../bottomBar/bottomBar.dart';

// class OtpScreen extends StatefulWidget {
//   final String mobileNumber;
//
//   const OtpScreen({super.key, required this.mobileNumber});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   final TextEditingController otpController = TextEditingController();
//   @override
//   void initState() {
//     Future.microtask(() {
//       context.read<OtpProvider>().startTimer();
//     });
//     super.initState();
//   }
//   String maskNumber(String number) {
//     return "+91 ${number.substring(0,5)} ${number.substring(5,7)}XXX";
//   }
//   bool get isOtpValid => otpController.text.length == 4;
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     AppSizes.init(context);
//
//     final defaultPinTheme = PinTheme(
//       width: 60,
//       height: 60,
//       textStyle: const TextStyle(
//         fontSize: 20,
//         fontWeight: FontWeight.w700,
//         color: ColorResource.buttonBackground,
//       ),
//       decoration: BoxDecoration(
//         color: ColorResource.otpBox,
//         borderRadius: BorderRadius.circular(12),
//       ),
//     );
//
//     return Consumer<OtpProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           backgroundColor: ColorResource.white,
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 children: [
//                   SizedBox(height: screenHeight * 0.0125),
//                   Row(
//                     children: [
//                       IconButton(
//                         onPressed: () => Navigator.pop(context),
//                         icon: const Icon(Icons.arrow_back_ios),
//                       ),
//                       const Spacer(),
//                       CustomText(
//                         'OTP VERIFICATION',
//                         size: AppSizes.size14,
//                         color: ColorResource.textBlack,
//                         weight: FontWeight.w700,
//                       ),
//                       const Spacer(),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                   CustomText(
//                     'Enter code sent to',
//                     size: AppSizes.size14,
//                     weight: FontWeight.w500,
//                     color: ColorResource.textBlack,
//                   ),
//                   SizedBox(height: screenHeight * 0.0125),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomText(
//                         maskNumber(widget.mobileNumber),
//                         size: 20,
//                         weight: FontWeight.w700,
//                       ),
//                       SizedBox(width: AppSizes.size20),
//                       GestureDetector(
//                         onTap: () {
//                           navPop(context: context);
//                         },
//                         child: CustomImageView(
//                           imagePath: AppImages.editIcon,
//                           height: AppSizes.size20,
//                           width: AppSizes.size20,
//                         ),
//                       )
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.05),
//                   Pinput(
//                     controller: otpController,
//                     length: 4,
//                     defaultPinTheme: defaultPinTheme,
//                     onChanged: (value) {
//                       setState(() {});
//                     },
//                   ),
//                    SizedBox(height: screenHeight * 0.05),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CustomImageView(
//                         imagePath: AppImages.timer,
//                         height: AppSizes.size14,
//                         width: AppSizes.size14,
//                         fit: BoxFit.cover,
//                       ),
//                       SizedBox(width: screenWidth * 0.0125),
//                       CustomText(
//                         "00:${provider.seconds.toString().padLeft(2, '0')}",
//                         size: AppSizes.size14,
//                         weight: FontWeight.w700,
//                       ),
//                       SizedBox(width: screenWidth * 0.0250),
//                       GestureDetector(
//                         onTap: provider.seconds == 0
//                             ? () async {
//                           showLoader(context);
//
//                           await provider.resendOtpApi(
//                             context: context,
//                             phone: widget.mobileNumber,
//                           );
//                           Navigator.pop(context);
//
//                           provider.startTimer();
//                         }
//                             : null,
//                         child: CustomText(
//                           'Resend',
//                           size: 14,
//                           weight: FontWeight.w700,
//                           color: provider.seconds == 0
//                               ? ColorResource.buttonBackground
//                               : ColorResource.Continue,
//                         ),
//                       )
//                     ],
//                   ),
//                   const Spacer(),
//                   CustomButton(
//                     title: 'Verify Now',
//                     backgroundColor: isOtpValid ? ColorResource.buttonBackground : Colors.grey,
//                     onTap: isOtpValid
//                         ? () async {
//                       showLoader(context);
//                       final prefs = await SharedPreferences.getInstance();
//                       final deviceToken = prefs.getString('deviceToken') ?? '';
//                       final deviceId = prefs.getString('deviceId') ?? '';
//
//                       final provider = context.read<OtpProvider>();
//
//                       await provider.verifyOtp(
//                         context: context,
//                         phone: widget.mobileNumber,
//                         otp: otpController.text,
//                         fcmToken: deviceToken,
//                         deviceId:deviceId ,
//                         deviceType:"android"// enum: ["android", "ios"],
//
//                       );
//                       Navigator.pop(context);
//
//                       if (provider.verifyOtpModel != null &&
//                           provider.verifyOtpModel!.status == true) {
//
//                         navPushBottomRemove(
//                           duration: 1,
//                           context: context,
//                           action: const MainScreen(currentIndex: 0,),
//                         );
//
//                       } else {
//
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Invalid OTP"),
//                           ),
//                         );
//
//                       }
//                     }
//                         : null,
//                   ),
//                    SizedBox(height: screenHeight * 0.05)
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }




class OtpScreen extends StatefulWidget {
  final String mobileNumber;

  const OtpScreen({super.key, required this.mobileNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();

  @override
  void initState() {
    Future.microtask(() {
      context.read<OtpProvider>().startTimer();
    });
    super.initState();
  }

  String maskNumber(String number) {
    return "+91 ${number.substring(0, 5)} ${number.substring(5, 7)}XXX";
  }

  bool get isOtpValid => otpController.text.length == 4;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ColorResource.buttonBackground,
      ),
      decoration: BoxDecoration(
        color: ColorResource.otpBox,
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return Consumer<OtpProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Row(
            children: [

              /// 🔵 LEFT PANEL (LOGO + BRAND)
              Container(
                width: 260,
                color: ColorResource.primary,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ SizedBox(height: 30,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/icon/logo.png", // apna logo yaha daalna
                        height: 110,

                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundColor: Colors.white,
                    //   child: Image.asset(
                    //     AppImages.loginVan,
                    //     height: 60,
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    const Text(
                      "Mann Fleet",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "OTP Verification Panel",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              /// ⚪ RIGHT PANEL (OTP CARD)
              Expanded(
                flex: 2,
                child: Center(
                  child: Container(
                    width: 450,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        /// TITLE
                        const Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: ColorResource.primary,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Enter code sent to",
                          style: TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              maskNumber(widget.mobileNumber),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                navPop(context: context);
                              },
                              child: const Icon(Icons.edit, size: 18),
                            )
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// OTP INPUT
                        Pinput(
                          controller: otpController,
                          length: 4,
                          defaultPinTheme: defaultPinTheme,
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),

                        const SizedBox(height: 25),

                        /// TIMER + RESEND
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.timer, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              "00:${provider.seconds.toString().padLeft(2, '0')}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 20),
                            GestureDetector(
                              onTap: provider.seconds == 0
                                  ? () async {
                                showLoader(context);

                                await provider.resendOtpApi(
                                  context: context,
                                  phone: widget.mobileNumber,
                                );

                                Navigator.pop(context);
                                provider.startTimer();
                              }
                                  : null,
                              child: Text(
                                "Resend",
                                style: TextStyle(
                                  color: provider.seconds == 0
                                      ? ColorResource.primary
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// VERIFY BUTTON
                        CustomButton(
                          title: 'Verify Now',
                          backgroundColor: isOtpValid
                              ? ColorResource.primary
                              : Colors.grey,
                          onTap: isOtpValid
                              ? () async {
                            showLoader(context);

                            final prefs =
                            await SharedPreferences.getInstance();
                            final deviceToken =
                                prefs.getString('deviceToken') ?? '';
                            final deviceId =
                                prefs.getString('deviceId') ?? '';

                            final provider =
                            context.read<OtpProvider>();

                            await provider.verifyOtp(
                              context: context,
                              phone: widget.mobileNumber,
                              otp: otpController.text,
                              fcmToken: deviceToken,
                              deviceId: deviceId,
                              deviceType: "android",
                            );

                            Navigator.pop(context);

                            if (provider.verifyOtpModel != null &&
                                provider.verifyOtpModel!.status == true) {
                              navPushBottomRemove(
                                duration: 1,
                                context: context,
                                action: const MainScreen(
                                  currentIndex: 0,
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text("Invalid OTP"),
                                ),
                              );
                            }
                          }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}