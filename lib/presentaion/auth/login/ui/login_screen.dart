import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/auth/login/provider/loginProvider.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_input.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:provider/provider.dart';
import '../../../../util/color/app_colors.dart';
import '../../../../util/constants/sizes.dart';
import '../../../../util/image_resource/image_resource.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../cms/ui/cMSContentScreen.dart';
import '../../otp/ui/otp_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//
//   bool isValid(LoginProvider provider) =>
//       provider.mobileNumberController.text.length == 10;
//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double screenWidth = MediaQuery.of(context).size.width;
//     AppSizes.init(context);
//     return Consumer<LoginProvider>(
//         builder: (context, provider, child){
//           return Scaffold(
//               backgroundColor: ColorResource.white,
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: EdgeInsets.all(AppSizes.size16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: screenHeight * 0.08),
//                       CustomImageView(
//                           imagePath: AppImages.loginVan,
//                           height: screenHeight * 0.08,
//                           width: screenWidth * 0.1778,
//                           fit: BoxFit.cover
//                       ),
//                       SizedBox(height: screenHeight * 0.03,),
//                       CustomText(
//                         'Welcome to Mann',
//                         size: AppSizes.size32,
//                         color: ColorResource.blueText,
//                         weight: FontWeight.w700,
//                       ),
//                       SizedBox(height: screenHeight * 0.011,),
//                       CustomText(
//                         'Book your Noida airport taxis and city\nbuses with ease.',
//                         size: AppSizes.size16,
//                         color: ColorResource.textBlack,
//                         weight: FontWeight.w400,
//                       ),
//                       SizedBox(height: screenHeight * 0.03,),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               CustomText(
//                                 'Code',
//                                 size: AppSizes.size14,
//                                 weight: FontWeight.w500,
//                                 color: ColorResource.textBlack,
//                               ),
//                               SizedBox(height: AppSizes.size8,),
//                               Container(
//                                 height: screenHeight * 0.0625,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(12),
//                                   border: Border.all(
//                                     width: 1,
//                                     color: ColorResource.inputBorder,
//                                   ),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     CountryCodePicker(
//                                       onChanged: (country) {
//                                         provider.changeCountryCode(country.dialCode ?? "+91");
//                                       },
//                                       initialSelection: 'IN',
//                                       favorite: const ['+91', 'IN'],
//                                       showCountryOnly: false,
//                                       showFlag: false,
//                                       showOnlyCountryWhenClosed: false,
//                                       showDropDownButton: false,
//                                       alignLeft: false,
//                                       padding: EdgeInsets.zero,
//                                       margin: EdgeInsets.zero,
//                                       textStyle: const TextStyle(
//                                         color: Color(0xFF0F172A),
//                                         fontSize: 16,
//                                         fontFamily: 'Plus Jakarta Sans',
//                                         fontWeight: FontWeight.w400,
//                                       ),
//                                     ),
//                                     Icon(Icons.arrow_drop_down_outlined)
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                           SizedBox(width: 5,),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 CustomText(
//                                   'Mobile Number',
//                                   size: AppSizes.size14,
//                                   weight: FontWeight.w500,
//                                   color: ColorResource.textBlack,
//                                 ),
//                                 SizedBox(height: AppSizes.size8,),
//                                 CustomInputBox(
//                                   controller: provider.mobileNumberController,
//                                   hintText: "0000000000",
//                                   type: InputType.number,
//                                   maxLength: 10,
//                                   errorText: provider.errorText,
//                                   onChanged: (value){
//                                     provider.onPhoneChanged(value);
//                                   },
//                                 )
//                                 // CustomInputBox(
//                                 //   controller: provider.mobileNumberController,
//                                 //   hintText: "0000000000",
//                                 //   type: InputType.number,
//                                 //   maxLength: 10,
//                                 //   errorText: provider.errorText,
//                                 // )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       SizedBox(height: screenHeight * 0.05,),
//                       CustomButton(
//                         title: 'GetOTP',
//                         backgroundColor: isValid(provider) ? ColorResource.buttonBackground : Colors.grey,
//                         onTap: isValid(provider)
//                             ? () async {
//
//                           final phone = provider.mobileNumberController.text;
//
//                           showLoader(context);
//
//                           final viewModel = context.read<LoginProvider>();
//
//                           await viewModel.sendOtp(
//                             context: context,
//                             phone: phone,
//                             countryCode: provider.countryCode,
//                           );
//
//                           Navigator.pop(context);
//
//                           if (viewModel.signInModel != null &&
//                               viewModel.signInModel!.status == true) {
//
//                             navPush(
//                               context: context,
//                               action: OtpScreen(
//                                 mobileNumber: phone,
//                               ),
//                             );
//
//                           } else {
//
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text("Failed to send OTP"),
//                               ),
//                             );
//
//                           }
//
//                         }
//                             : null,
//                       ),
//                       SizedBox(height: 20,),
//                       // SizedBox(height: screenHeight * 0.07,),
//                       // Row(
//                       //   children: [
//                       //     Expanded(
//                       //       child: Divider(
//                       //         thickness: 1,
//                       //         color: ColorResource.inputBorder,
//                       //       ),
//                       //     ),
//                       //     const SizedBox(width: 10),
//                       //     CustomText(
//                       //       'Or continue with',
//                       //       size: 14,
//                       //       weight: FontWeight.w400,
//                       //       color: ColorResource.Continue,
//                       //     ),
//                       //     const SizedBox(width: 10),
//                       //     Expanded(
//                       //       child: Divider(
//                       //         thickness: 1,
//                       //         color: ColorResource.inputBorder,
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       // SizedBox(height: screenHeight * 0.05,),
//                       // CustomButton(
//                       //   image: AppImages.google,
//                       //     title: 'Sign in with Google',
//                       //     backgroundColor: ColorResource.white,
//                       //     textColor: ColorResource.black,
//                       //     borderColor: ColorResource.inputBorder,
//                       //     onTap: (){}
//                       // ),
//                       // SizedBox(height: screenHeight * 0.05,),
//                       // CustomButton(
//                       //  // image: AppImages.ios,
//                       //     title: 'Sign in with IOS',
//                       //     backgroundColor: ColorResource.onbording,
//                       //     textColor: ColorResource.white,
//                       //     onTap: (){}
//                       // ),
//                       // SizedBox(height: screenHeight * 0.05,),
//                       Center(
//                         child: SizedBox(
//                           // width: 291.36,
//                           // height: 39,
//                           child: Text.rich(
//                             TextSpan(
//                               children: [
//                                 TextSpan(
//                                   text: 'By continuing, you agree to Mann ',
//                                   style: TextStyle(
//                                     color: const Color(0xFF94A3B8),
//                                     fontSize: 12,
//                                     fontFamily: 'Plus Jakarta Sans',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.63,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//                                       navPush(
//                                         context: context,
//                                         action: const CMSContentScreen(
//                                           title: "Terms & Conditions",
//                                           type: CMSContentType.terms,
//                                         ),
//                                       );
//                                       print("Terms & Conditions");
//
//                                       /// 👉 Navigate karo
//                                       // navPush(context: context, action: PrivacyPolicyScreen());
//                                     },
//                                   text: 'Terms of \nService ',
//                                   style: TextStyle(
//                                     color: const Color(0xFF04055F),
//                                     fontSize: 12,
//                                     fontFamily: 'Plus Jakarta Sans',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   text: 'and ',
//                                   style: TextStyle(
//                                     color: const Color(0xFF94A3B8),
//                                     fontSize: 12,
//                                     fontFamily: 'Plus Jakarta Sans',
//                                     fontWeight: FontWeight.w400,
//                                     height: 1.63,
//                                   ),
//                                 ),
//                                 TextSpan(
//                                   recognizer: TapGestureRecognizer()
//                                     ..onTap = () {
//
//                                       print("Privacy clicked");
//                                       navPush(
//                                         context: context,
//                                         action: const CMSContentScreen(
//                                           title: "Privacy Policy",
//                                           type: CMSContentType.privacy,
//                                         ),
//                                       );
//
//                                       /// 👉 Navigate karo
//                                       // navPush(context: context, action: PrivacyPolicyScreen());
//                                     },
//                                   text: 'Privacy Policy',
//                                   style: TextStyle(
//                                     color: const Color(0xFF04055F),
//                                     fontSize: 12,
//                                     fontFamily: 'Plus Jakarta Sans',
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//           );
//         }
//     );
//   }
// }
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isValid(LoginProvider provider) =>
      provider.mobileNumberController.text.length == 10;

  @override
  Widget build(BuildContext context) {
    AppSizes.init(context);

    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: Row(
            children: [

              /// 🔵 LEFT PANEL (LOGO + BRANDING)
              Container(
                width: 260,
                color: ColorResource.primary,
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    GestureDetector(
                      onTap: (){
                        navPop(context: context);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset(
                          "assets/icon/logo.png", // apna logo yaha daalna
                          height: 110,

                        ),
                      ),
                    ),
                    /// LOGO
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
                      "Driver & Fleet Management System",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              /// ⚪ RIGHT PANEL (FORM)
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: ColorResource.primary,
                            ),
                          ),

                          const SizedBox(height: 25),

                          /// COUNTRY + PHONE
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Code"),
                                    const SizedBox(height: 8),
                                    Container(
                                      height: 50,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: ColorResource.inputBorder,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          CountryCodePicker(
                                            onChanged: (country) {
                                              provider.changeCountryCode(
                                                  country.dialCode ?? "+91");
                                            },
                                            initialSelection: 'IN',
                                            showFlag: false,
                                          ),
                                        //  const Icon(Icons.arrow_drop_down),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 20),

                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Mobile Number"),
                                    const SizedBox(height: 8),
                                    CustomInputBox(
                                      controller:
                                      provider.mobileNumberController,
                                      hintText: "0000000000",
                                      type: InputType.number,
                                      maxLength: 10,
                                      errorText: provider.errorText,
                                      onChanged: (value) {
                                        provider.onPhoneChanged(value);
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          const SizedBox(height: 30),

                          /// BUTTON
                          CustomButton(
                            title: 'Get OTP',
                            backgroundColor: isValid(provider)
                                ? ColorResource.primary
                                : Colors.grey,
                            onTap: isValid(provider)
                                ? () async {

                              final phone = provider
                                  .mobileNumberController.text;

                              showLoader(context);

                              final viewModel =
                              context.read<LoginProvider>();

                              await viewModel.sendOtp(
                                context: context,
                                phone: phone,
                                countryCode: provider.countryCode,
                              );

                              Navigator.pop(context);

                              if (viewModel.signInModel != null &&
                                  viewModel.signInModel!.status ==
                                      true) {
                                navPush(
                                  context: context,
                                  action: OtpScreen(
                                    mobileNumber: phone,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text("Failed to send OTP"),
                                  ),
                                );
                              }
                            }
                                : null,
                          ),

                          const SizedBox(height: 20),

                          /// TERMS
                          Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text:
                                    'By continuing, you agree to Mann ',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  TextSpan(
                                    text: 'Terms of Service ',
                                    style: const TextStyle(
                                      color: ColorResource.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        navPush(
                                          context: context,
                                          action:
                                          const CMSContentScreen(
                                            title:
                                            "Terms & Conditions",
                                            type:
                                            CMSContentType.terms,
                                          ),
                                        );
                                      },
                                  ),
                                  const TextSpan(text: 'and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: const TextStyle(
                                      color: ColorResource.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        navPush(
                                          context: context,
                                          action:
                                          const CMSContentScreen(
                                            title: "Privacy Policy",
                                            type:
                                            CMSContentType.privacy,
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}