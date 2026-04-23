import 'package:flutter/material.dart';

import '../../../../util/color/app_colors.dart';
import '../../../../widget/customImageView.dart';
class BuildDateTimeRow extends StatefulWidget {
  final String icon;
  final String label;
  final TextEditingController controller;
  const BuildDateTimeRow({super.key,required this.icon,required this.controller,required this.label});

  @override
  State<BuildDateTimeRow> createState() => _BuildDateTimeRowState();
}

class _BuildDateTimeRowState extends State<BuildDateTimeRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath:widget. icon,
          height: 22,
          width: 22,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 11,
                  color: ColorResource.Continue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextField(
                controller:widget. controller,
                enabled: false,
                style: const TextStyle(color: ColorResource.black),
                decoration: const InputDecoration(
                  hintText: "Select",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
