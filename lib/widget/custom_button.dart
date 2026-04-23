import 'package:flutter/material.dart';
import 'package:mannfleet/util/FontResource/FontResource.dart';
import 'package:mannfleet/widget/customImageView.dart';

import '../util/color/app_colors.dart';

// class CustomButton extends StatelessWidget {
//   final String title;
//   final VoidCallback? onTap;
//   final Color backgroundColor;
//   final Color textColor;
//   final Color? borderColor;
//
//   const CustomButton({
//     super.key,
//     required this.title,
//     required this.onTap,
//     this.backgroundColor = ColorResource.buttonBackground,
//     this.textColor = ColorResource.white,
//     this.borderColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: 45,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: backgroundColor,
//           borderRadius: BorderRadius.circular(30),
//           border: borderColor != null
//               ? Border.all(color: borderColor!)
//               : null,
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0x3F000000),
//               blurRadius: 50,
//               offset: Offset(0, 25),
//               spreadRadius: -12,
//             )
//           ],
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//       ),
//     );
//   }
// }
//


class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final String? image;

  const CustomButton({
    super.key,
    required this.title,
    required this.onTap,
    this.backgroundColor = ColorResource.buttonBackground,
    this.textColor = ColorResource.white,
    this.borderColor,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 45,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(30),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 50,
              offset: Offset(0, 25),
              spreadRadius: -12,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null) ...[
              CustomImageView(
                imagePath: image,
                height: 20,
                width: 20,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontFamily: FontResource.plusJakartaSans,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


