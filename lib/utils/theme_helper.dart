// lib/utils/theme_helper.dart
import 'package:flutter/material.dart';

class TH {
  // background color
  static Color bg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF0D1117)
        : const Color(0xFFF0FAFA);
  }

  // card color
  static Color card(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF161B22)
        : Colors.white;
  }

  // text color
  static Color text(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1A2E35);
  }

  // sub text
  static Color subText(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white60
        : Colors.grey;
  }

  // input fill
  static Color inputFill(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF21262D)
        : Colors.grey.shade50;
  }

  // divider
  static Color divider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white12
        : Colors.grey.shade200;
  }

  // icon bg
  static Color iconBg(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2EC4B6).withOpacity(0.2)
        : const Color(0xFF2EC4B6).withOpacity(0.1);
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
