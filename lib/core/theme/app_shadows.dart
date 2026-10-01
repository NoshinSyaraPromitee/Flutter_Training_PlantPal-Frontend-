import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static List<BoxShadow> tinted(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
}