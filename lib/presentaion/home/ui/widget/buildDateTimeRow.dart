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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text(
          widget.label,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black.withOpacity(0.7)
            // color: Color(0xff94A3B8),
          ),
        ),

        const SizedBox(height: 2),
        Container(
          height: 55,
        padding: EdgeInsets.symmetric(horizontal: 10),
        // decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        // border: Border.all(color: Colors.grey,width: 1)
        // ),

          decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomImageView(
                imagePath:widget. icon,
                height: 18,
                width: 18,
                fit: BoxFit.cover,
              ),              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  widget.controller.text.isNotEmpty
                      ? widget.controller.text
                      : widget.label,
                  style:  TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    // color: ColorResource.black,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // TextField(
              //   controller:widget. controller,
              //   enabled: false,
              //   style: const TextStyle(color: ColorResource.black),
              //   decoration: const InputDecoration(
              //     hintText: "Select",
              //     border: InputBorder.none,
              //     contentPadding: EdgeInsets.zero,
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
