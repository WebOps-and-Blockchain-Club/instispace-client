import 'package:flutter/material.dart';

import '../../models/color_palette.dart';

class Themes {
  static final ThemeData theme = ThemeData(
    primaryColor: ColorPalette._primary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorPalette._primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: ColorPalette._secondary[50],

    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Text Theme
    textTheme: TextTheme(
        headlineSmall: TextStyle(
            color: ColorPalette._primary, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: ColorPalette._primary),
        titleMedium: TextStyle(color: ColorPalette._primary),
        titleSmall: TextStyle(
            color: ColorPalette._primary, fontWeight: FontWeight.w500),
        bodyLarge: const TextStyle(fontWeight: FontWeight.normal),
        // Default Style for body medium
        labelLarge: TextStyle(
            color: ColorPalette._primary,
            letterSpacing: 0,
            fontWeight: FontWeight.normal),
        labelSmall: const TextStyle(
            color: Colors.grey, letterSpacing: 0, fontSize: 12)),

    appBarTheme: AppBarTheme(
        backgroundColor: ColorPalette._secondary[50],
        elevation: 0,
        iconTheme: IconThemeData(color: ColorPalette._primary)),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: ColorPalette._primary,
        selectedItemColor: ColorPalette._secondary[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorPalette._secondary[50],
        showUnselectedLabels: true),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 5,
            primary: ColorPalette._success,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: ColorPalette._success)),
            textStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold))),

    // Floating Action Button Theme
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(elevation: 5),

    // TextFormField
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        constraints: const BoxConstraints(minHeight: 50),
        prefixIconColor: ColorPalette._secondary,
        suffixIconColor: ColorPalette._primary,
        isDense: true,
        contentPadding: const EdgeInsets.all(10),
        labelStyle: TextStyle(
            color: ColorPalette._primary, fontWeight: FontWeight.normal),
        hintStyle: const TextStyle(fontWeight: FontWeight.normal),
        enabledBorder: border,
        focusedBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorStyle: const TextStyle(color: ColorPalette._error)),

    // Card Theme
    cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias),

    // ListTile Theme
    listTileTheme: ListTileThemeData(
        horizontalTitleGap: 0,
        iconColor: ColorPalette._primary,
        textColor: ColorPalette._primary),

    //ExpansionTile Theme
    expansionTileTheme: ExpansionTileThemeData(
        iconColor: ColorPalette._primary,
        collapsedIconColor: ColorPalette._primary,
        childrenPadding: const EdgeInsets.only(left: 30)),

    // Icon Theme
    iconTheme: IconThemeData(color: ColorPalette._primary),

    // Divider Theme
    dividerTheme: DividerThemeData(color: ColorPalette._primary, thickness: 2),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)))),

    // Chip Theme
    chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: ColorPalette._primaryColor))),

    // Dialog Theme
    dialogTheme: DialogTheme(
        alignment: Alignment.center,
        titleTextStyle: TextStyle(
            color: ColorPalette._primary,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
  );

  static InputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: ColorPalette._primaryColor),
      borderRadius: BorderRadius.all(Radius.circular(10)));
  static InputBorder borderNone = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
      borderRadius: BorderRadius.all(Radius.circular(10)));
  static InputBorder errorBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: ColorPalette._error),
      borderRadius: BorderRadius.all(Radius.circular(10)));

  static BoxConstraints inputIconConstraints = const BoxConstraints(
      maxWidth: 50, maxHeight: 25, minHeight: 25, minWidth: 35);
}

class ColorPalette {
  static const Color _primaryColor = Color(0xFF2F247B);
  static final Map<int, Color> _primaryColorShades = {
    50: const Color(0xFFEAE9F1),
    100: const Color(0xFFC0BDD7),
    200: const Color(0xFF9791BD),
    300: const Color(0xFF6D65A2),
    400: const Color(0xFF433988),
    500: _primaryColor,
    600: const Color(0xFF2A206E),
    700: const Color(0xFF251C62),
    800: const Color(0xFF201956),
    900: const Color(0xFF1C1549),
  };

  static const Color _warningColor = Color(0xFFED6C02);
  static final Map<int, Color> _warningColorShades = {
    50: const Color(0xFFFDF0E5),
    100: const Color(0xFFF9D2B3),
    200: const Color(0xFFF6B580),
    300: const Color(0xFFF2984D),
    400: const Color(0xFFEE7A1B),
    500: _warningColor,
    600: const Color(0xFFD56101),
    700: const Color(0xFFBD5601),
    800: const Color(0xFFA54B01),
    900: const Color(0xFF8E4001),
  };

  static final MaterialColor _primary =
      MaterialColor(_primaryColor.value, _primaryColorShades);
  static const MaterialColor _secondary = Colors.purple;
  static const MaterialColor _success = Colors.green;
  static final MaterialColor _warning =
      MaterialColor(_warningColor.value, _warningColorShades);
  static const MaterialColor _error = Colors.red;

  static ColorPaletteModel palette(BuildContext context) {
    return ColorPaletteModel(
        primary: _primary,
        secondary: _secondary,
        success: _success,
        warning: _warning,
        error: _error);
  }
}
