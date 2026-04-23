import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../util/color/app_colors.dart';
void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 140,
            width: 140,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                SizedBox(
                  height: 50,
                  width: 50,
                  child:  SpinKitSpinningLines(

                    color: ColorResource.buttonBackground,
                    size: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Please wait...",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}