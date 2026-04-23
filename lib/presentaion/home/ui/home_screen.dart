
import 'package:flutter/material.dart';

import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';

import 'package:mannfleet/widget/custom_text.dart';

import 'package:provider/provider.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import '../../../util/constants/sizes.dart';
import '../../../widget/navigator_method.dart';
import '../../drawer/ui/custom_drawer.dart';
import '../../notification/ui/NotificationScreen.dart';
import '../../profile/viewModel/profileViewModel.dart';
import '../../splash/ui/splashScreen.dart';
import '../provider/homeProvider.dart';
import 'module/airport_city_view.dart';
import 'module/airport_shuttle_view.dart';
import 'module/mann_taj_express_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInitialData();
  }
  void loadInitialData() {
    final vm = Provider.of<HomeProvider>(context, listen: false);
    vm.getBannerApi(context: context);
    vm.clearAllFields();
    final vmProfile = Provider.of<ProfileDetailViewModel>(context, listen: false);
    vmProfile.getProfileApi(context: context);
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    AppSizes.init(context);

    return Consumer2<HomeProvider,ProfileDetailViewModel>(
        builder: (context, provider,profilePro, child) {
          // if(profilePro.getProfileModel==null ||profilePro.getProfileModel!.data==null){
          //   return Center(child: CircularProgressIndicator());
          // }

          return Scaffold(
          backgroundColor: ColorResource.white,

              key: _scaffoldKey,
              drawer: const CustomDrawer(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Row(
                  children: [
                    /// ☰ Menu
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
                        // open drawer or menu
                      },
                      child: CustomImageView(
                        imagePath: AppImages.menuImage,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// 👋 Greeting + Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            _getGreeting(),
                            size: 12,
                            weight: FontWeight.w500,
                            color: ColorResource.textBlack,
                          ),
                          CustomText(
                            profilePro.getProfileModel?.data?.user?.name != null &&
                                profilePro.getProfileModel!.data!.user!.name!.isNotEmpty
                                ? "Mr. ${profilePro.getProfileModel!.data!.user!.name}"
                                : "Guest",
                            // '${profilePro.getProfileModel?.data?.user?.name ?? "Guest"}',
                            size: 18,
                            weight: FontWeight.w700,
                            color: ColorResource.black,
                          ),
                        ],
                      ),
                    ),

                    /// 🔔 Notification
                    GestureDetector(
                      onTap: () {
                        navPush(context: context, action: NotificationScreen());
                      },
                      child: CustomImageView(
                        imagePath: AppImages.notification,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body:  SingleChildScrollView(
            // controller: _scrollController, // 👈 yaha
                child: Column(
                  children: [
                    // SizedBox(height: screenHeight * 0.045),

                    // Top bar - Menu + Greeting + Notification
                    // Padding(
                    //   padding:
                    //   const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    //   child: Row(
                    //     children: [
                    //       GestureDetector(
                    //       onTap: (){
                    //         //navPush(context: context, action: SplashScreen());
                    //       },
                    //
                    //         child: CustomImageView(
                    //           imagePath: AppImages.menuImage,
                    //           height: screenHeight * 0.05,
                    //           width: screenWidth * 0.111,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //       const SizedBox(width: 10),
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           CustomText(
                    //             _getGreeting(),
                    //             size: AppSizes.size12,
                    //             weight: FontWeight.w500,
                    //             color: ColorResource.textBlack,
                    //           ),
                    //           CustomText(
                    //             '${profilePro.getProfileModel?.data?.user?.name??"Guest"}',
                    //             size: 18,
                    //             weight: FontWeight.w700,
                    //             color: ColorResource.black,
                    //           ),
                    //         ],
                    //       ),
                    //       const Spacer(),
                    //       GestureDetector(
                    //         onTap: (){
                    //           navPush(context: context, action: NotificationScreen());
                    //         },
                    //         child: CustomImageView(
                    //           imagePath: AppImages.notification,
                    //           height: screenHeight * 0.05,
                    //           width: screenWidth * 0.111,
                    //           fit: BoxFit.cover,
                    //
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),

                    // Main Tabs: AIRPORT/CITY  |  AIRPORT SHUTTLE  |  MANN TAJ EXPRESS
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: ColorResource.homeOption,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: List.generate(
                          provider.tabs.length,
                              (index) {
                            bool isSelected = provider.selectedIndex == index;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => provider.changeTab(index),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? ColorResource.white
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      provider.tabs[index],
                                      size: 10,
                                      weight: FontWeight.w700,
                                      color: isSelected
                                          ? ColorResource.blueText
                                          : ColorResource.textBlack,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.0125),



                    if (provider.selectedIndex == 0)
                      AirportCityView(
                        provider: provider,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                        // scrollController: _scrollController, // 👈 add this
                      ),

                    if (provider.selectedIndex == 1)
                      AirportShuttleView(
                        provider: provider,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),

                    if (provider.selectedIndex == 2)
                      MannTajExpressView(
                        provider: provider,
                        screenHeight: screenHeight,
                        screenWidth: screenWidth,
                      ),

                    // ─────────────────────────────────────────────────────────────
                    //           COMMON SECTION (Recent + Deals)
                    // ─────────────────────────────────────────────────────────────
                    // Container(
                    //   padding: const EdgeInsets.all(15),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       // Recent Bookings
                    //       Row(
                    //         children: [
                    //           CustomImageView(
                    //             imagePath: AppImages.recentImage,
                    //             height: 16,
                    //             width: 16,
                    //             fit: BoxFit.cover,
                    //           ),
                    //           const SizedBox(width: 10),
                    //           CustomText(
                    //             'Recent Bookings',
                    //             size: 16,
                    //             color: ColorResource.black,
                    //             weight: FontWeight.w700,
                    //           ),
                    //         ],
                    //       ),
                    //       ListView.builder(
                    //         padding: const EdgeInsets.only(bottom: 10, top: 10),
                    //         shrinkWrap: true,
                    //         physics: const NeverScrollableScrollPhysics(),
                    //         itemCount: 3,
                    //         itemBuilder: (context, index) {
                    //           return Padding(
                    //             padding: const EdgeInsets.only(bottom: 15),
                    //             child: RecentCard(
                    //               image: AppImages.recentImage,
                    //               title: 'IGI Airport T3',
                    //               subTitle: '24 Oct, 08:30 AM',
                    //               price: '1200 Paid',
                    //             ),
                    //           );
                    //         },
                    //       ),
                    //
                    //       const SizedBox(height: 20),
                    //
                    //       // Grab deal of the day
                    //       Row(
                    //         children: [
                    //           CustomImageView(
                    //             imagePath: AppImages.grabImage,
                    //             height: 18,
                    //             width: 18,
                    //           ),
                    //           const SizedBox(width: 10),
                    //           CustomText(
                    //             'Grab deal of the day',
                    //             size: 16,
                    //             weight: FontWeight.w700,
                    //             color: ColorResource.black,
                    //           ),
                    //           const Spacer(),
                    //           CustomText(
                    //             'View All',
                    //             size: 12,
                    //             weight: FontWeight.w700,
                    //             color: ColorResource.viewText,
                    //           ),
                    //         ],
                    //       ),
                    //       const SizedBox(height: 10),
                    //       SizedBox(
                    //         height: 108,
                    //         child: ListView.separated(
                    //           scrollDirection: Axis.horizontal,
                    //           padding: const EdgeInsets.only(left: 0),
                    //           itemCount: 3,
                    //           separatorBuilder: (context, index) =>
                    //           const SizedBox(width: 10),
                    //           itemBuilder: (context, index) {
                    //             return GrabCard(
                    //               title: 'LIMITED TIME',
                    //               subTitle: 'Evening Special',
                    //               status: 'SAVE15',
                    //               offer:
                    //               'Flat 15% off on city rides between 7-10 PM',
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ));
      }
    );



  }











  // ─────────────────────────────────────────────────────────────
  //  Reusable Widgets (unchanged)
  // ─────────────────────────────────────────────────────────────

  Widget GrabCard({
    required String title,
    required String subTitle,
    required String status,
    required String offer,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            title,
            size: 10,
            weight: FontWeight.w700,
            color: ColorResource.aberColor,
          ),
          CustomText(
            subTitle,
            size: 14,
            color: ColorResource.black,
            weight: FontWeight.w700,
          ),
          CustomText(
            offer,
            size: 12,
            weight: FontWeight.w400,
            color: ColorResource.Continue,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: ColorResource.homeOption,
                ),
                child: CustomText(
                  status,
                  size: 12,
                  weight: FontWeight.w700,
                  color: ColorResource.black,
                ),
              ),
              const Spacer(),
              CustomImageView(
                imagePath: AppImages.saveImage,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget RecentCard({
    required String image,
    required String title,
    required String subTitle,
    required String price,
  }) {
    return Row(
      children: [
        CustomImageView(
          imagePath: image,
          height: 30,
          width: 30,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
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
              color: ColorResource.Continue,
              weight: FontWeight.w400,
            ),
          ],
        ),
        const Spacer(),
        CustomText(
          '₹$price',
          size: 10,
          weight: FontWeight.w700,
          color: ColorResource.viewText,
        ),
        const Icon(Icons.arrow_forward_ios, size: 20, color: ColorResource.Continue),
      ],
    );
  }




  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon";
    } else if (hour >= 17 && hour < 21) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

}