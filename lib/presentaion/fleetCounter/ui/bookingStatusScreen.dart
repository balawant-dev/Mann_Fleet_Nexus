import 'package:flutter/material.dart';
import 'package:mannfleet/widget/navigator_method.dart';

import '../../../util/color/app_colors.dart';



class BookingStatusScreen extends StatelessWidget {
  const BookingStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Row(
        children: [

          /// 🔵 LEFT PANEL (LOGO + BRAND)
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
                const SizedBox(height: 20),
                const Text(
                  "Mann Fleet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Booking Status Panel",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          /// ⚪ RIGHT PANEL
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  const Text(
                    "Check Booking Status",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ColorResource.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// SEARCH BAR
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Enter Booking ID / Mobile Number",
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResource.primary,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 18),
                        ),
                        onPressed: () {},
                        child: const Text("Search"),
                      )
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// TABLE HEADER
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: ColorResource.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Row(
                      children: [
                        Expanded(child: Text("Booking ID", style: TextStyle(color: Colors.white))),
                        Expanded(child: Text("Customer", style: TextStyle(color: Colors.white))),
                        Expanded(child: Text("Vehicle", style: TextStyle(color: Colors.white))),
                        Expanded(child: Text("Status", style: TextStyle(color: Colors.white))),
                        Expanded(child: Text("Action", style: TextStyle(color: Colors.white))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LIST
                  Expanded(
                    child: ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              const Expanded(child: Text("#BK1023")),
                              const Expanded(child: Text("Rahul Sharma")),
                              const Expanded(child: Text("Mini Truck")),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    "Completed",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text("View"),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}