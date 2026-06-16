// import 'package:flutter/material.dart';
//
// import '../../../util/color/app_colors.dart';
//
// class TripTypeTabs extends StatefulWidget {
//   const TripTypeTabs({super.key});
//
//   @override
//   State<TripTypeTabs> createState() => _TripTypeTabsState();
// }
//
// class _TripTypeTabsState extends State<TripTypeTabs> {
//   int selected = 0;
//
//   final tabs = ["One Way", "Round Trip", "Hourly", "Intercity"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 36,
//       decoration: BoxDecoration(
//         color: const Color(0xffF1F3F6),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: List.generate(
//           tabs.length,
//           (index) => Expanded(
//             child: GestureDetector(
//               onTap: () => setState(() => selected = index),
//               child: Container(
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: selected == index ? Colors.white : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   tabs[index],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w500,
//                     color: selected == index ? Colors.blue : Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class TripTypeSelector extends StatefulWidget {
//   const TripTypeSelector({super.key});
//
//   @override
//   State<TripTypeSelector> createState() => _TripTypeSelectorState();
// }
//
// class _TripTypeSelectorState extends State<TripTypeSelector> {
//   int selected = 0;
//
//   final types = ["One Way", "Round Trip", "Hourly", "Intercity"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 38,
//       decoration: BoxDecoration(
//         color: ColorResource.background,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: List.generate(types.length, (index) {
//           final active = selected == index;
//
//           return Expanded(
//             child: InkWell(
//               borderRadius: BorderRadius.circular(10),
//               onTap: () => setState(() => selected = index),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 250),
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   color: active ? Colors.white : Colors.transparent,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Text(
//                   types[index],
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                     color: active ? Colors.blue : Colors.black54,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
