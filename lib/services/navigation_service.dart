import 'package:flutter/material.dart';

class NavService {
  static push(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static pushReplace(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static pushRemoveAll(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => widget),
      (Route<dynamic> route) => false,
    );
  }

  static pop(BuildContext context) {
    Navigator.pop(context);
  }

  static Future<dynamic> pushResult(
    BuildContext context,
    Widget widget,
  ) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
