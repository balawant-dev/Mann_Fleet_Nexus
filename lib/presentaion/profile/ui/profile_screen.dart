import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/profile/ui/editProfile.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../apiservice/services/secure_storage_service.dart';
import '../../busRoutes/ui/busRouteScreen.dart';
import '../../cms/ui/settingsScreen.dart';
import '../../emergencySos/ui/emergencySosScreen.dart';
import '../../newComplaints/ui/newComplaintScreen.dart';
import '../../splash/ui/splashScreen.dart';
import '../viewModel/profileViewModel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<ProfileDetailViewModel>(context, listen: false);
    vm.getProfileApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'My Profile',
        actionImage: AppImages.setting,
        onActionTap: () {
          navPush(context: context, action: SettingsScreen());
        },
      ),
      body: Consumer<ProfileDetailViewModel>(
        builder: (context, pro, child) {
          // if(pro.getProfileModel==null ||pro.getProfileModel!.data==null){
          //   return Center(child: CircularProgressIndicator());
          // }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Container(
                          height: 128,
                          width: 128,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              width: 3,
                              color: ColorResource.white,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                width: 10,
                                color: const Color(0xFF906B45),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: CustomImageView(
                                imagePath: pro.getProfileModel?.data?.user?.profilePic??AppImages.loginVan,
                                fit: BoxFit.contain,
                                imageType:pro.getProfileModel?.data?.user?.profilePic==null?ImageType.asset:ImageType.network,
                              ),
                              // child: CustomImageView(
                              //   imagePath: AppImages.loginVan,
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                          ),
                        ),

                        CustomText(
                          pro.getProfileModel?.data?.user?.name != null &&
                              pro.getProfileModel!.data!.user!.name!.isNotEmpty
                              ? "Mr. ${pro.getProfileModel!.data!.user!.name}"
                              : "Hello Guest",
                         // "Mr. ${pro.getProfileModel?.data?.user?.name??"Hello guest"}",
                          size: 24,
                          weight: FontWeight.w700,
                          color: ColorResource.black,
                        ),

                        CustomText(
                          '+91 ${pro.getProfileModel?.data?.user?.mobile?? "XXXXXXXXX"}',
                          size: 16,
                          weight: FontWeight.w400,
                          color: ColorResource.textBlack,
                        ),

                        // Container(
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 10,
                        //     vertical: 3,
                        //   ),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     color: ColorResource.sosActive,
                        //   ),
                        //   child: CustomText(
                        //     'GOLD MEMBER',
                        //     size: 12,
                        //     weight: FontWeight.w700,
                        //     color: ColorResource.textColor,
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      'Account Settings',
                      size: 18,
                      weight: FontWeight.w700,
                      color: ColorResource.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  profileCard(
                    image: AppImages.profile,
                    title: 'Edit Profile',
                    subTitle: 'Update your personal details',
                    onTap: () {
                      navPush(context: context, action: EditProfile());
                      print('Edit Profile');
                    },
                  ),
                  // SizedBox(height: 10),
                  // profileCard(
                  //   image: AppImages.saveicon,
                  //   title: 'Saved Addresses',
                  //   subTitle: 'Manage your home and work locations',
                  //   onTap: () {
                  //     print('Saved Addresses');
                  //   },
                  // ),
                  SizedBox(height: 10),
                  profileCard(
                    image: AppImages.emergency,
                    title: 'Emergency Contacts',
                    subTitle: 'Manage safety contacts for trips',
                    onTap: () {
                      navPush(context: context, action: EmergencySosScreen());
                      print('Emergency Contacts');
                    },
                  ),
                  // SizedBox(height: 10),
                  // profileCard(
                  //   image: AppImages.settingNotification,
                  //   title: 'Notification Settings',
                  //   subTitle: 'Choose what updates you receive',
                  //   onTap: () {
                  //     print('Notification Settings');
                  //   },
                  // ),
                  // SizedBox(height: 10),
                  // profileCard(
                  //   image: AppImages.settingNotification,
                  //   title: 'Bus Routes',
                  //   subTitle: 'Choose what updates you receive',
                  //   onTap: () {
                  //     navPush(context: context, action: BusRoutes());
                  //     print('Bus Routes');
                  //   },
                  // ),
                  SizedBox(height: 10),
                  profileCard(
                    image: AppImages.settingNotification,
                    title: 'New Complaint',
                    subTitle: 'Choose what updates you receive',
                    onTap: () {
                      navPush(context: context, action: NewComplaint());
                      print('NewComplaint');
                    },
                  ),     SizedBox(height: 10),
                  profileCard(
                    image: AppImages.setting,
                    title: 'Settings',
                    subTitle: 'Choose what updates you receive',
                    onTap: () {
                      navPush(context: context, action: SettingsScreen());
                      print('NewComplaint');
                    },
                  ),
                  SizedBox(height: 10),
                  logOutCard(
                    bgColor: ColorResource.redBackground,
                    image: AppImages.logOutIcon,
                    title: 'Logout',
                    onTap: () => showLogoutDialog(context),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 50, color: Colors.redAccent),
              const SizedBox(height: 16),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      // AppSettings.clearUserType();
                      SecureStorageService.logout(context);
                      final prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      // Navigator.pop(context, true);
                      navPushReplace(context: context, action: SplashScreen());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget profileCard({
    required String image,
    required String title,
    required String subTitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: ColorResource.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: ShapeDecoration(
                color: ColorResource.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: image,
                  height: 16,
                  width: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
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
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorResource.textBlack,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  Widget logOutCard({
    required String image,
    required String title,
    required VoidCallback onTap,
    Color? bgColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: bgColor ?? ColorResource.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: ShapeDecoration(
                color: ColorResource.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadows: [
                  BoxShadow(
                    color: Color(0x0C000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: image,
                  height: 16,
                  width: 16,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  title,
                  size: 16,
                  weight: FontWeight.w700,
                  color: ColorResource.red,
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorResource.textBlack,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
