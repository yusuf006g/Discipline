import 'package:flutter/material.dart';

class WidgetsStyle {
  static final ButtonStyle primaryButtonStyle =
  ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFFCCE956),
    foregroundColor: const Color(0xFF111111),
    minimumSize: const Size(double.infinity, 48),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
  );
}


