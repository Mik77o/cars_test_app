import 'package:flutter/material.dart';

class TextInputFormatter {
  static InputDecoration getInputDecoration(BuildContext context,
      {String? labelText, String? hintText, Widget? suffixIcon}) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      labelStyle: TextStyle(color: Colors.black54),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(),
      ),
    );
  }
}
