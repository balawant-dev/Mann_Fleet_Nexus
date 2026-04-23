import 'package:flutter/material.dart';

import '../../../widget/custom_appBar.dart';
import '../../../widget/navigator_method.dart';
import '../../../widget/showComingSoonDialog.dart';
import 'cMSContentScreen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});



  Widget buildTile({required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBack: true,
        title: 'Settings',
        // subTitle: 'Noida Sector 62 to IGI Airport',

      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          // Review Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFF1F5F9),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
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
                const Text("Enjoying the app?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text("Give us your feedback and rating"),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: (){
                    showComingSoonDialog(context);
                  },
                  child: const Text("Rate & Review"),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Options
          Container(
            // padding: const EdgeInsets.all(16),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: const Color(0xFFF1F5F9),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                buildTile(
                  icon: Icons.privacy_tip,
                  title: "Privacy Policy",
                  onTap: (){
                    navPush(
                      context: context,
                      action: const CMSContentScreen(
                        title: "Privacy Policy",
                        type: CMSContentType.privacy,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                buildTile(
                  icon: Icons.description,
                  title: "Terms & Conditions",
                  onTap: (){
                    navPush(
                      context: context,
                      action: const CMSContentScreen(
                        title: "Terms & Conditions",
                        type: CMSContentType.terms,
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                buildTile(
                  icon: Icons.assignment_return,
                  title: "Refund Policy",
                  onTap: (){
                    navPush(
                      context: context,
                      action: const CMSContentScreen(
                        title: "Refund Policy",
                        type: CMSContentType.refund,
                      ),
                    );
                  },
                ), const Divider(height: 1),
                // buildTile(
                //   icon: Icons.support_agent,
                //   title: "Support",
                //   onTap: (){},
                // ),
                const Divider(height: 1),
                // buildTile(
                //   icon: Icons.delete,
                //   title: "Delete Account",
                //   color: Colors.red,
                //   onTap: (){},
                // ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
