import 'package:flutter/material.dart';

class ProjectConstants {
  static Color getPrimaryColor(BuildContext context, bool isReversed) {
    if (isReversed) {
      return Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black;
    }
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  static const double toolbarHeight = 48.0;

  static const Color blueColor = Color(0xFF3797EF);
  static const Color redColor = Color(0xFFF3555A);
}
