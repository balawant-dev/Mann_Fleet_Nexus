import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/widget/custom_text.dart';

import '../util/FontResource/FontResource.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subTitle;
  final bool isBack;
  final String? actionImage;
  final VoidCallback? onActionTap;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.subTitle,
    this.isBack = false,
    this.actionImage,
    this.onActionTap,
    this.onBackTap, // ✅ add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: FontResource.plusJakartaSans,
            ),
          ),

          if (subTitle != null && subTitle!.isNotEmpty)
            CustomText(
              subTitle!,
              size: 11,
              weight: FontWeight.w400,
              color: ColorResource.textBlack,
            ),
        ],
      ),

      /// Back Button
      leading: isBack
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: onBackTap ?? () => Navigator.pop(context),
      )
          : null,

      /// Action Button
      actions: actionImage != null
          ? [
        IconButton(
          onPressed: onActionTap,
          icon: Image.asset(
            actionImage!,
            height: 24,
            width: 24,
          ),
        ),
      ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}