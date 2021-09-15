import 'package:flutter/material.dart';

class ToastService {
  static showToast(BuildContext context, String text, {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(_buildSnackBar(text, duration));
  }

  static SnackBar _buildSnackBar(String message, int duration) {
    return SnackBar(
      padding: EdgeInsets.symmetric(horizontal: 16),
      duration: Duration(seconds: duration),
      content: SizedBox(
        height: 36,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            message.toUpperCase(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
