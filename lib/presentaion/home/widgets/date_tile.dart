// import 'package:flutter/material.dart';
//
// class DateTile extends StatelessWidget {
//   final String title;
//   final String value;
//   final IconData icon;
//   final VoidCallback onTap;
//
//   const DateTile({
//     super.key,
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(10),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Colors.grey),
//           const SizedBox(width: 6),
//           Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }
// }
