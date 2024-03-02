import 'package:flutter/material.dart';

class ColorPaletteModel {
  final MaterialColor primary;
  final MaterialColor text;
  final MaterialColor secondary;
  final MaterialColor success;
  final MaterialColor warning;
  final MaterialColor error;

  ColorPaletteModel({
    required this.primary,
    required this.text,
    required this.secondary,
    required this.success,
    required this.warning,
    required this.error,
  });
}
