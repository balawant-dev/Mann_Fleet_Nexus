// import 'package:flutter/material.dart';
// import 'package:mannfleet/presentaion/home/widgets/trip_tabs.dart';
//
// import '../../../util/color/app_colors.dart';
// import 'date_tile.dart';
// import 'location_field.dart';
//
// class RideSearchCard extends StatefulWidget {
//   const RideSearchCard({super.key});
//
//   @override
//   State<RideSearchCard> createState() => _RideSearchCardState();
// }
//
// class _RideSearchCardState extends State<RideSearchCard> {
//   String pickup = "Sector 62, Noida";
//   String drop = "";
//   DateTime date = DateTime.now();
//
//   void swapLocations() {
//     setState(() {
//       final temp = pickup;
//       pickup = drop;
//       drop = temp;
//     });
//   }
//
//   Future pickDate() async {
//     final result = await showDatePicker(
//       context: context,
//       initialDate: date,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2030),
//     );
//
//     if (result != null) {
//       setState(() => date = result);
//     }
//   }
//
//   Future pickTime() async {
//     final result = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//
//     if (result != null) {}
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: AppRadius.card,
//         boxShadow: AppShadow.card,
//       ),
//       child: Column(
//         children: [
//           /// Trip Types
//           const TripTypeSelector(),
//
//           const SizedBox(height: 18),
//
//           /// Location Section
//           LocationSection(
//             pickup: pickup,
//             drop: drop,
//             onPickupTap: () {},
//             onDropTap: () {},
//             onSwap: swapLocations,
//           ),
//
//           const SizedBox(height: 16),
//
//           /// Date & Time
//           Row(
//             children: [
//               Expanded(
//                 child: DateTile(
//                   title: "DATE",
//                   value: "Today, 24 Oct",
//                   icon: Icons.calendar_today,
//                   onTap: pickDate,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: DateTile(
//                   title: "TIME",
//                   value: "Leave Now",
//                   icon: Icons.access_time,
//                   onTap: pickTime,
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 22),
//
//           /// CTA
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorResource.primary,
//                 shape: RoundedRectangleBorder(borderRadius: AppRadius.pill),
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//               ),
//               child: const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Find Rides"),
//                   SizedBox(width: 6),
//                   Icon(Icons.arrow_forward),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
