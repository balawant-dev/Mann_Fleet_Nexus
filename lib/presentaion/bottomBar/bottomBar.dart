import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:provider/provider.dart';
import '../../util/color/app_colors.dart';
import '../../util/image_resource/image_resource.dart';
import '../booking/ui/vehicleSelectionScreen.dart';
import '../bookingHistory/provider/bookingHistoryProvider.dart';
import '../bookingHistory/ui/bookingHistoryScreen.dart';
import '../home/ui/home_screen.dart';
import '../newComplaints/ui/newComplaintScreen.dart';
import '../passes/ui/passes_screen.dart';
import '../profile/ui/profile_screen.dart';
import '../shuttleModule/myShuttle/ui/myShuttleScreen.dart';
import '../shuttleModule/shuttleHistory/ui/shuttleHistoryScreen.dart';
import '../wallet/ui/walletScreen.dart';

class MainScreen extends StatefulWidget {
  final int currentIndex;
  const MainScreen({super.key,required this.currentIndex});
  static void changeTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_MainScreenState>();
    state?.setState(() {
      state.currentIndex = index;
    });
  }

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  late int currentIndex;
  @override
  void initState() {
    super.initState();

    currentIndex = widget.currentIndex; // initial value

  }
  final List<Widget> pages = [
    const HomeScreen(),
    const BookingHistoryScreen(),
    // const PassesScreen(),
    const  MyPassesScreen(),
 // const ShuttleHistoryScreen(),

    const NewComplaint(),
  ];

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          setState(() {
            currentIndex = 0; // ✅ Go to Home tab
          });
          return false; // ❌ Don't pop
        }
        return true; // ✅ Pop screen
      },
      child: Scaffold(
        body: pages[currentIndex],

        bottomNavigationBar: SafeArea(
          child: Container(
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black12,
                )
              ],
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottomItem(
                  index: 0,
                  label: "HOME",
                  selectedIcon: AppIcons.activeHome,
                  unSelectedIcon: AppIcons.homeInactive,
                ),

                bottomItem(
                  index: 1,
                  label: "BOOKINGS",
                  selectedIcon: AppIcons.bookingActive,
                  unSelectedIcon: AppIcons.bookinInactive,
                ),

                bottomItem(
                  index: 2,
                  // label: "SHUTTLE",
                  // label: "WALLET",
                  label: "PASSES",
                  selectedIcon: AppIcons.passActive,
                  unSelectedIcon:  AppIcons.passedInactive,
                ),

                bottomItem(
                  index: 3,
                  label: "SUPPORT",
                  selectedIcon: "assets/icon/supportS.png",
                  unSelectedIcon: "assets/icon/supportU.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomItem({
    required int index,
    required String label,
    required String selectedIcon,
    required String unSelectedIcon,
  }) {

    bool isSelected = currentIndex  == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex  = index;
        });
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset(
            isSelected ? selectedIcon : unSelectedIcon,
            height: 20,
          ),

          const SizedBox(height: 5),
          CustomText(
            label,
            size: 10,
            weight: FontWeight.w500,
            color:  isSelected ? ColorResource.blueText : ColorResource.textBlack,
          )
        ],
      ),
    );
  }
}