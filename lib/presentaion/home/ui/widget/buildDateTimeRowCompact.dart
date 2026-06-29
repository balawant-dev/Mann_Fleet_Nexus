import 'package:flutter/material.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/customImageView.dart';
class BuildDateTimeRowCompact extends StatefulWidget {
  final String icon;
  final String title;
  final TextEditingController controller;
  const BuildDateTimeRowCompact({super.key,required this.controller,required this.icon,required this.title});

  @override
  State<BuildDateTimeRowCompact> createState() => _BuildDateTimeRowCompactState();
}

class _BuildDateTimeRowCompactState extends State<BuildDateTimeRowCompact> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath:widget.icon,
          height: 20,
          width: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: widget.controller,
            enabled: false,
            style: const TextStyle(
              color: ColorResource.black,
              fontSize: 12,
            ),
            decoration:  InputDecoration(
              hintText: widget.title,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
