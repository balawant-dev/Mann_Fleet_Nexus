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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10,),
        Text(
          widget.title,
          style:  TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:  Colors.black.withOpacity(0.7),
            // color: Color(0xff94A3B8),
          ),
        ),

        const SizedBox(height: 2),
        Container(
          height: 55,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            border: Border.all(    color:  Colors.black.withOpacity(0.7),),
            borderRadius: BorderRadius.circular(8),
          ),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   border: Border.all(color: Colors.grey,width: 1)
          // ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
              widget.icon,
                height: 18,
                width: 18,
                color:  Colors.black,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.controller.text.isNotEmpty
                      ? widget.controller.text
                      : widget.title,
                  style:  TextStyle(
                    color:  Colors.black.withOpacity(0.7),
                    // color: Colors.grey.shade300,
                    // color: ColorResource.black,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Expanded(
              //   child: TextField(
              //     controller: widget.controller,
              //     enabled: false,
              //     style: const TextStyle(
              //       color: ColorResource.black,
              //       fontSize: 12,
              //     ),
              //     decoration:  InputDecoration(
              //       hintText: widget.title,
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
