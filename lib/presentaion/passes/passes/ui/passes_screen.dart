import 'package:flutter/material.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../../bottomBar/bottomBar.dart';


class PassesScreen extends StatefulWidget {
  const PassesScreen({super.key});

  @override
  State<PassesScreen> createState() => _PassesScreenState();
}

class _PassesScreenState extends State<PassesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isBack: true,
        title: 'Passes',
        onActionTap: () {
          print("Setting clicked");
        },
        onBackTap: () {
          MainScreen.changeTab(context, 0);
        },
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// 🔵 Icon / Illustration
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF03045E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.confirmation_num_outlined,
                  size: 60,
                  color: Color(0xFF03045E),
                ),
              ),

              const SizedBox(height: 25),

              /// 🔥 Title
             Text(
                'No Pass Available',
                style: TextStyle(             fontSize: 20,
                  fontWeight: FontWeight.bold,),

              ),

              const SizedBox(height: 10),

              /// 💬 Subtitle
           Text(
                'You don’t have any active passes right now.\nBook your travel and get exclusive passes soon!', textAlign: TextAlign.center,

               style: TextStyle(
                 color: Colors.grey,),
              ),

              const SizedBox(height: 25),

              /// 🚀 Coming Soon Tag
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF03045E),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Coming Soon 🚀',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🧾 Extra Info
             Text(
                'Soon you will be able to purchase monthly & daily passes for buses, cabs and more.\nStay tuned!',
                textAlign: TextAlign.center,
               style: TextStyle(
                 color: Colors.grey.shade600,
                 fontSize: 13,
               ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}