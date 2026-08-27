import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';

import '../../../apiservice/services/secure_storage_service.dart';
import '../../../shuttleModule/shuttleHistory/ui/shuttleHistoryScreen.dart';
import '../../../widget/navigator_method.dart';
import '../../../widget/showLoaderFunction.dart';
import '../../bookingHistory/provider/bookingHistoryProvider.dart';
import '../../cms/ui/cMSContentScreen.dart';
import '../../emergencySos/ui/emergencySosScreen.dart';

import 'package:mannfleet/presentaion/profile/ui/editProfile.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';

import '../../../widget/customImageView.dart';

import '../../profile/viewModel/profileViewModel.dart';
import 'package:intl/intl.dart';


import '../../splash/ui/splashScreen.dart';
import '../../wallet/ui/walletScreen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String version = "";
  String dobApi = "";

  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    setState(() {});
    return version;
  }

  Future<void> _selectDate(BuildContext context) async {
    final profilePro = Provider.of<ProfileDetailViewModel>(
      context,
      listen: false,
    );

    final now = DateTime.now();

    final maxDate = DateTime(now.year - 14, now.month, now.day);

    DateTime initialDate = DateTime(now.year - 18, now.month, now.day);

    if (profilePro.getProfileModel?.data?.user?.dob != null &&
        profilePro.getProfileModel!.data!.user!.dob!.isNotEmpty) {
      try {
        initialDate = DateTime.parse(
          profilePro.getProfileModel!.data!.user!.dob!,
        );
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: maxDate,
    );

    if (picked != null) {
      dobApi = DateFormat('yyyy-MM-dd').format(picked);

      showLoader(context);

      await profilePro.editProfileApi(
        context: context,
        name: profilePro.getProfileModel?.data?.user?.name ?? "",
        email: profilePro.getProfileModel?.data?.user?.email ?? "",
        city: profilePro.getProfileModel?.data?.user?.city ?? "",
        gender: profilePro.getProfileModel?.data?.user?.gender ?? "",
        dob: dobApi,
        profilePic: "",
      );

      Navigator.pop(context);

      await profilePro.getProfileApi(context: context);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        // color: ColorResource.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFe31d25),

            Color(0xFFf15a5f),
            Color(0xFFff9a9e),
            Color(0xFFfff0f1),
            Color(0xFFfffcfc),


          ],
          stops: const [0.0,0.1, 0.3, 0.7, 1.0],

        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: () {
                navPop(context: context);
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,

        // backgroundColor: const Color(0xFFF8F9FA),
        body: Consumer<ProfileDetailViewModel>(
          builder: (context, profilePro, child) {
            appVersion();
            // if (profilePro.getProfileModel==null||profilePro.getProfileModel!.data==null) {
            //   return const Center(child: CircularProgressIndicator());
            // }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                children: [
                  // Top Status Bar Simulation

                  // Header
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          navPush(context: context, action: EditProfile());
                        },
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 110,
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      width: 3,
                                      color: ColorResource.primary,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: CustomImageView(
                                      width: 80,
                                      height: 80,
                                      imagePath:
                                      profilePro
                                          .getProfileModel
                                          ?.data
                                          ?.user
                                          ?.profilePic ??
                                          "assets/images/person.png",
                                      fit: BoxFit.fill,
                                      imageType:
                                      profilePro
                                          .getProfileModel
                                          ?.data
                                          ?.user
                                          ?.profilePic ==
                                          null
                                          ? ImageType.asset
                                          : ImageType.network,
                                    ),
                                    // child: CustomImageView(
                                    //   imagePath: AppImages.loginVan,
                                    //   fit: BoxFit.cover,
                                    // ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      navPush(
                                        context: context,
                                        action: EditProfile(),
                                      );
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                        color: ColorResource.white,
                                      ),

                                      child: Icon(Icons.edit,color: ColorResource.primary,),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 12),
                            Text(
                              profilePro.getProfileModel?.data?.user?.name ??
                                  "Guest User",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade300,
                                // color: Colors.black87,
                              ),
                            ),

                            SizedBox(height: 4),
                            Text(
                              "+91 ${profilePro.getProfileModel?.data?.user?.mobile ?? "XXXXXXX"}",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade300,
                                // color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Profile Icon
                    ],
                  ),
                  SizedBox(height: 10),

                  // Birthday Banner
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: ColorResource.white,
                        // color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profilePro.getProfileModel?.data?.user?.dob ==
                                      null ||
                                      profilePro
                                          .getProfileModel!
                                          .data!
                                          .user!
                                          .dob!
                                          .isEmpty
                                      ? "Add your birthday"
                                      : DateFormat('dd MMM yyyy').format(
                                    DateTime.parse(
                                      profilePro
                                          .getProfileModel!
                                          .data!
                                          .user!
                                          .dob!,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: ColorResource.primary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      Icon(
                                        Icons.edit,
                                        size: 14,
                                        color: ColorResource.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            "assets/icon/birthdayIcon.png",
                            height: 65,
                          ),
                          // const Icon(
                          //   Icons.cake_outlined,
                          //   size: 40,
                          //   color: Colors.orange,
                          // ),
                        ],
                      ),
                    ),
                  ),

                  // Container(
                  //   // margin: const EdgeInsets.all(12),
                  //   padding: const EdgeInsets.all(14),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         color: Colors.black.withOpacity(0.05),
                  //         blurRadius: 8,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       const Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text(
                  //               "Add your birthday",
                  //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  //             ),
                  //             Text(
                  //               "Enter details",
                  //               style: TextStyle(
                  //                 color: Colors.green,
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.w600,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       // Image.network(
                  //       //   "https://cdn-icons-png.flaticon.com/512/5278/5278779.png",
                  //       //   height: 70,
                  //       // ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(height: 12),

                  // Three Action Cards
                  Row(
                    children: [
                      _buildActionCard(
                        icon: Icons.person_outline,
                        label: "My Profile",
                        onTap: () {
                          navPush(context: context, action: EditProfile());
                        },
                      ),
                      SizedBox(width: 12),
                      _buildActionCard(
                        icon: Icons.wallet,
                        label: "Wallet",
                        onTap: () {
                          navPush(context: context, action: WalletScreen());
                        },
                      ),
                      SizedBox(width: 12),
                      _buildActionCard(
                        icon: Icons.receipt_long,
                        label: "Shuttle History",
                        onTap: () {
                          navPush(
                            context: context,
                            action: ShuttleHistoryScreen(),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Your Information
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child: Text(
                  //     "Your information",
                  //     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  //   ),
                  // ),SizedBox(height: 10,),
                  Container(
                    // margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorResource.white,
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Your Information",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color:  Colors.grey.shade300,
                            ),
                          ),
                        ),

                        // drawerItem(
                        //   icon: Icons.person_outline,
                        //   title: "My Profile",
                        //   onTap: () {
                        //     navPush(context: context, action: EditProfile());
                        //     // TODO: Navigate to profile
                        //   },
                        // ),
                        // drawerItem(
                        //   icon: Icons.wallet,
                        //   title: "Wallet",
                        //   onTap: () {
                        //     navPush(context: context, action:     WalletScreen());
                        //     // TODO: Navigate to profile
                        //   },
                        // ),    drawerItem(
                        //   icon: Icons.paste_sharp,
                        //   title: "Shuttle History",
                        //   onTap: () {
                        //     navPush(context: context, action:     ShuttleHistoryScreen());
                        //     // TODO: Navigate to profile
                        //   },
                        // ),
                        drawerItem(
                          icon: Icons.sos,
                          title: "SOS",
                          onTap: () {
                            navPush(
                              context: context,
                              action: EmergencySosScreen(
                                // title: "Terms & Conditions",
                                // type: CMSContentType.terms,
                              ),
                            );
                          },
                        ),

                        drawerItem(
                          icon: Icons.currency_rupee,
                          title: "Refund Policy",
                          onTap: () {
                            navPush(
                              context: context,
                              action: const CMSContentScreen(
                                title: "Refund Policy",
                                type: CMSContentType.refund,
                              ),
                            );
                          },
                        ),
                        // drawerItem(
                        //   icon: Icons.support_agent,
                        //   title: "Help & Support",
                        //   onTap: () {},
                        // ),
                        drawerItem(
                          icon: Icons.info_outline,
                          title: "About us",
                          onTap: () {
                            navPush(
                              context: context,
                              action: const CMSContentScreen(
                                title: "About us",
                                type: CMSContentType.terms,
                              ),
                            );
                          },
                        ),
                        drawerItem(
                          icon: Icons.privacy_tip_outlined,
                          title: "Privacy Policy",
                          onTap: () {
                            navPush(
                              context: context,
                              action: const CMSContentScreen(
                                title: "Privacy Policy",
                                type: CMSContentType.privacy,
                              ),
                            );
                          },
                        ),
                        drawerItem(
                          icon: Icons.description_outlined,
                          title: "Terms & Conditions",
                          onTap: () {
                            navPush(
                              context: context,
                              action: const CMSContentScreen(
                                title: "Terms & Conditions",
                                type: CMSContentType.terms,
                              ),
                            );
                          },
                        ),

                        const Divider(height: 32, thickness: 1),

                        drawerItem(
                          icon: Icons.logout,
                          title: "Log Out",
                          onTap: () => showLogoutDialog(context),
                          color: Colors.red,
                        ),
                        const Divider(height: 32, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "v$version",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        //
                        // _buildListTile(Icons.book, "Address book"),
                        // _buildListTile(Icons.coffee, "Bookmarked recipes"),
                        // _buildListTile(Icons.favorite_border, "Your wishlist"),
                        // _buildListTile(Icons.receipt, "GST details"),
                        // _buildListTile(Icons.card_giftcard, "E-gift cards"),
                        // _buildListTile(Icons.medication_outlined, "Your prescriptions"),
                      ],
                    ),
                  ),

                  // const SizedBox(height: 12),
                  //
                  // // Payment and Coupons
                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Payment and coupons",
                  //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 16,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: ColorResource.white,
              border: Border.all(     color:  Colors.grey.shade300,width: 2)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.logout, size: 50, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                "Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,     color:  Colors.grey.shade300,),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16,      color:  Colors.grey.shade400,),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      // AppSettings.clearUserType();
                      context
                          .read<BookingHistoryProvider>()
                          .resetPagination();

                      await SecureStorageService.logout(context);

                      navPushBottomRemove(
                        context: context,
                        action: SplashScreen(),
                        duration: 1,
                      );
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

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: ColorResource.white,
            // color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
            ],
          ),
          child: Column(
            children: [
              Icon(icon, size: 32,     color:  Colors.grey.shade300,
                // color: Colors.black87
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style:  TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,     color:  Colors.grey.shade300,
                  // color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem({
    required IconData icon,
    required VoidCallback onTap,
    required String title,
    Color? color, // optional - only for special cases like logout
  }) {
    final textColor = color ??      Colors.grey.shade300;
    final iconColor = color ??  Colors.grey.shade300;
    // final textColor = color ?? Colors.black87;
    // final iconColor = color ?? Colors.black87;
    return GestureDetector(
      onTap: onTap,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20,),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: iconColor),
          ],
        ),
      ),
    );
    // return ListTile(
    //
    //   leading: Icon(icon, color: Colors.black87),
    //   title: Text(title),
    //   trailing: const Icon(Icons.chevron_right),
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    // );
  }
}
