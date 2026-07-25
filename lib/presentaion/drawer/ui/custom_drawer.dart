import 'package:flutter/material.dart';
import 'package:mannfleet/presentaion/profile/ui/editProfile.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:provider/provider.dart';

import '../../../apiservice/services/secure_storage_service.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../../widget/customImageView.dart';
import '../../../widget/navigator_method.dart';
import '../../bookingHistory/provider/bookingHistoryProvider.dart';
import '../../cms/ui/cMSContentScreen.dart';

import '../../cms/ui/settingsScreen.dart';
import '../../emergencySos/ui/emergencySosScreen.dart';
import '../../profile/viewModel/profileViewModel.dart';

import '../../shuttleModule/shuttleHistory/ui/shuttleHistoryScreen.dart';
import '../../splash/ui/splashScreen.dart';
import '../../wallet/ui/walletScreen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String version = "";

  Future<String> appVersion() async {
    final info = await PackageInfo.fromPlatform();
    version = info.version;
    setState(() {});
    return version;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailViewModel>(
      builder: (context, profilePro, child) {
        appVersion();
        // if (profilePro.getProfileModel==null||profilePro.getProfileModel!.data==null) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        return Drawer(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Column(
            children: [
              // ── Profile Header ────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 50, bottom: 24),
                color: ColorResource.buttonBackground,
                child: GestureDetector(
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
                                color: ColorResource.white,
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
                                  borderRadius: BorderRadius.circular(999),
                                  color: ColorResource.white,
                                ),

                                child: Icon(Icons.edit),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // ClipOval(
                      //   child: Image.network(
                      //     profilePro.getProfileModel?.data?.driver?.profilePic ?? "Profile Me image nhi aa rha hai",
                      //     width: 80, // Radius 40 hai toh width/height 80 hogi
                      //     height: 80,
                      //     fit: BoxFit.cover,
                      //
                      //     // Jab image load ho rahi ho
                      //     loadingBuilder: (context, child, loadingProgress) {
                      //       if (loadingProgress == null) return child;
                      //       return Container(
                      //         width: 80,
                      //         height: 80,
                      //         color: Colors.grey[200],
                      //         child: const Center(
                      //           child: CircularProgressIndicator(strokeWidth: 2),
                      //         ),
                      //       );
                      //     },
                      //
                      //     // Jab image load hone mein error aaye ya URL invalid ho
                      //     errorBuilder: (context, error, stackTrace) {
                      //       return Container(
                      //         width: 80,
                      //         height: 80,
                      //         color: Colors.grey[300],
                      //         child: const Icon(
                      //           Icons.person,
                      //           size: 40,
                      //           color: Colors.grey,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
                      // CircleAvatar(
                      //   radius: 40,
                      //   backgroundImage: NetworkImage(profilePro.getProfileModel?.data?.driver?.profilePic??"No Image"),
                      // ),
                      SizedBox(height: 12),
                      Text(
                        profilePro.getProfileModel?.data?.user?.name ??
                            "Guest User",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      profilePro.getProfileModel?.data?.user?.email == null
                          ? SizedBox()
                          : SizedBox(height: 6),
                      profilePro.getProfileModel?.data?.user?.email == null
                          ? SizedBox()
                          : Text(
                              profilePro.getProfileModel?.data?.user?.email ??
                                  "",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                      SizedBox(height: 4),
                      Text(
                        "+91 ${profilePro.getProfileModel?.data?.user?.mobile ?? "XXXXXXX"}",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Menu Items ─────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        drawerItem(
                          icon: Icons.person_outline,
                          title: "My Profile",
                          onTap: () {
                            navPush(context: context, action: EditProfile());
                            // TODO: Navigate to profile
                          },
                        ),
                        drawerItem(
                          icon: Icons.wallet,
                          title: "Wallet",
                          onTap: () {
                            navPush(context: context, action:     WalletScreen());
                            // TODO: Navigate to profile
                          },
                        ),    drawerItem(
                          icon: Icons.paste_sharp,
                          title: "Shuttle History",
                          onTap: () {
                            navPush(context: context, action:     ShuttleHistoryScreen());
                            // TODO: Navigate to profile
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

                        // const Divider(height: 32, thickness: 1),
                        //
                        // drawerItem(
                        //   icon: Icons.logout,
                        //   title: "Log Out",
                        //   onTap: () => showLogoutDialog(context),
                        //   color: Colors.red,
                        // ),
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

  Widget drawerItem({
    required IconData icon,
    required VoidCallback onTap,
    required String title,
    Color? color, // optional - only for special cases like logout
  }) {
    final textColor = color ?? Colors.black87;
    final iconColor = color ?? Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 18),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      context.read<BookingHistoryProvider>().resetPagination();

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
}
