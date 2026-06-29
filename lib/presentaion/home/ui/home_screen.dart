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

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final scrollController = ScrollController();
  final GlobalKey tabsKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    scrollController.dispose();

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomInset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 200));

        if (!mounted || !scrollController.hasClients) return;

        scrollController.animateTo(
          scrollController.position.maxScrollExtent + 250,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      });
    }
  }


  void loadInitialData() {
    final vm = Provider.of<HomeProvider>(context, listen: false);
    vm.getBannerApi(context: context);
    vm.getHourlyPackageApi(context: context);
    vm.clearAllFields();
    final vmProfile = Provider.of<ProfileDetailViewModel>(
      context,
      listen: false,
    );
    vmProfile.getProfileApi(context: context);
  }

  void scrollToTopTabs() {
    if (tabsKey.currentContext != null) {
      final context = tabsKey.currentContext!;

      Future.delayed(const Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          alignment:0
          // alignment: 0.001,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    AppSizes.init(context);
    final bottomInsect = MediaQuery.of(context).viewInsets.bottom > 0;

    return Consumer2<HomeProvider, ProfileDetailViewModel>(
      builder: (context, provider, profilePro, child) {


        final user = profilePro.getProfileModel?.data?.user;

        String genderTitle = "";

        switch (user?.gender?.toLowerCase()) {
          case "male":
            genderTitle = "Mr.";
            break;
          case "female":
            genderTitle = "Ms.";
            break;
          case "other":
            genderTitle = "Mx.";
            break;
          default:
            genderTitle = "";
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: ColorResource.white,

          key: _scaffoldKey,
          drawer: const CustomDrawer(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    /// ☰ Menu
                    GestureDetector(
                      onTap: () {
                        _scaffoldKey.currentState!.openDrawer();
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
                          Text(
                            user?.name != null && user!.name!.isNotEmpty
                                ? "$genderTitle ${user.name}"
                                : "Guest",
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: ColorResource.black,
                            ),

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
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.manual,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [

                          Container(
                            width: MediaQuery.of(context).size.width,


                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: ColorResource.homeOption,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(

                                children: List.generate(provider.tabs.length, (
                                  index,
                                ) {
                                  bool isSelected =
                                      provider.selectedIndex == index;

                                  return GestureDetector(
                                    onTap: () => provider.changeTab(index),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width*0.3,
                                      // duration: const Duration(
                                      //   milliseconds: 250,
                                      // ),
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? ColorResource.white
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          provider.tabs[index],
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? ColorResource.blueText
                                                : ColorResource.textBlack,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),

                          // SizedBox(height: screenHeight * 0.0125),

                          if (provider.selectedIndex == 0)
                            AirportCityView(
                              provider: provider,
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,

                              onLocationFocus: scrollToTopTabs,
                              globalKey: tabsKey,

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


                          if (bottomInsect) SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
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
          ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
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
        const Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: ColorResource.Continue,
        ),
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
    }
    else {
      return "Good Evening";
    }
  }
}
