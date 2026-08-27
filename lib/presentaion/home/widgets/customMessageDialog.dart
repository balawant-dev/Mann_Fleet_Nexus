import 'package:flutter/material.dart';

enum MessageType { success, error, warning, info }

class CustomMessageDialog {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    MessageType type = MessageType.info,
  }) {
    IconData icon;
    Color color;

    switch (type) {
      case MessageType.success:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case MessageType.error:
        icon = Icons.error;
        color = Colors.red;
        break;
      case MessageType.warning:
        icon = Icons.warning;
        color = Colors.orange;
        break;
      case MessageType.info:
        icon = Icons.info;
        color = Colors.blue;
        break;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon(
              //   icon,
              //   size: 60,
              //   color: color,
              // ),
              // const SizedBox(height: 15),
              // Text(
              //   title,
              //   style: const TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              // const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}