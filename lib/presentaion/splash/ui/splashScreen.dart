import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import '../../../apiservice/services/appConfigService.dart';
import '../../../apiservice/services/firebaseService.dart';
import '../../../apiservice/services/secure_storage_service.dart';
import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../bottomBar/bottomBar.dart';
import '../../fleetCounter/ui/fleetCounterScreen.dart';
import '../../onBording/ui/onBordingScreen.dart';
import '../provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    // checkUpdateAndNavigate();

    checkLogin();
  }

  bool isUpdateRequired(String currentVersion, String apiVersion) {
    List<int> current = currentVersion.split('.').map(int.parse).toList();
    List<int> api = apiVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < api.length; i++) {
      if (current.length <= i) return true;

      if (api[i] > current[i]) {
        return true; // update required
      } else if (api[i] < current[i]) {
        return false;
      }
    }
    return false;
  }
  Future<void> checkLogin() async {
    // await FirebaseService.init();
    await SecureStorageService.saveToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjZhMTUzMDdiZmNlNTQyMjRmYjk3Y2JiNyIsImlhdCI6MTc4NDg5NDg3NH0.e28z5bgJIlH0uRIdeE58ak05wntiyICVaJKcIB05Xic");
    final token = await SecureStorageService.getToken();

    print("Check Token in Splash Screen >>>>>>>>>>>🟢🟢🟢🟢  ${token}");

    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      navPushReplace(context: context, action: FleetCounterScreen());
    } else {
      navPushReplace(context: context, action: MainScreen(currentIndex: 0,));
    }
  }
  /// 🔥 FORCE UPDATE DIALOG
  void showUpdateDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 ICON
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update_alt,
                    size: 35,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🔥 TITLE
                const Text(
                  "Update Available",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 MESSAGE
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 25),

                /// 🔥 BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final url = Uri.parse(
                        "https://play.google.com/store/apps/details?id=com.user.mannfleet",
                      );

                      if (await canLaunchUrl(url)) {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: ColorResource.buttonBackground,
                    ),
                    child: const Text(
                      "Update Now",
                      style: TextStyle(fontSize: 16,color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: ColorResource.splashBackground,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/sooo.jpeg"),fit: BoxFit.cover)
        ),
        // child: Center(
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children:  [
        //       CustomImageView(
        //           imagePath: AppImages.logo,
        //           height: MediaQuery.of(context).size.height * 0.115,
        //           width: MediaQuery.of(context).size.width * 0.786,
        //           fit: BoxFit.contain
        //       )
        //     ],
        //   ),
        // ),
      ),
    );
  }
}