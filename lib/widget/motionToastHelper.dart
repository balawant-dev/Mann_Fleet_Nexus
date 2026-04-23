import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
enum ToastType { success, error, warning, info }

class ToastHelper {

  static void show(
      BuildContext context, {
        required String message,
        ToastType type = ToastType.success,
      }) {

    MotionToast toast;

    switch (type) {
      case ToastType.success:
        toast = MotionToast.success(
          title: const Text("Success"),
          description: Text(message),
        );
        break;

      case ToastType.error:
        toast = MotionToast.error(
          title: const Text("Error"),
          description: Text(message),
        );
        break;

      case ToastType.warning:
        toast = MotionToast.warning(
          title: const Text("Warning"),
          description: Text(message),
        );
        break;

      case ToastType.info:
        toast = MotionToast.info(
          title: const Text("Info"),
          description: Text(message),
        );
        break;
    }

    toast.show(context);
  }
}

//
// ToastHelper.show(
// context,
// message: "Something went wrong",
// type: ToastType.error,
// );