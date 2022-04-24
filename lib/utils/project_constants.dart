import 'dart:ui';

import 'package:flutter/material.dart';

class ProjectConstants {
  static Color getPrimaryColor(BuildContext context, bool isReversed) {
    if (isReversed) {
      return Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black;
    }
    return Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black;
  }
}
