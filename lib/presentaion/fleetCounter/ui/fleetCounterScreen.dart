import 'package:flutter/material.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import '../../../util/color/app_colors.dart';
import '../../auth/login/ui/login_screen.dart';
import 'bookingStatusScreen.dart';




class FleetCounterScreen extends StatelessWidget {
  const FleetCounterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Row(
          children: [
            /// LEFT SIDE PANEL (LOGO + TITLE)
            Container(
              width: 240,
              color: ColorResource.primary,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  /// LOGO
                  ClipRRect(
          borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/icon/logo.png", // apna logo yaha daalna
                      height: 110,
                   
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "Mann Fleet Nexus",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Counter Panel",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            /// RIGHT SIDE CONTENT
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome to Mann Fleet Nexus",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: ColorResource.primary,
                      ),
                    ),

                    const SizedBox(height: 40),

                    /// GRID (2 BIG OPTIONS)
                    Row(
                      children: [
                        Expanded(
                          child: _buildCard(
                            icon: Icons.add_circle_outline,
                            title: "Book Now",
                            subtitle: "Create a new booking",
                            onTap: () {
                              navPush(
                                context: context,
                                action: LoginScreen(),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: _buildCard(
                            icon: Icons.receipt_long_outlined,
                            title: "Booking Status",
                            subtitle: "Track all bookings",
                            onTap: () {
                              navPush(context: context, action: BookingStatusScreen());
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: ColorResource.primary,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ColorResource.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}