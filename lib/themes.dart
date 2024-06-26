import 'package:flutter/material.dart';

import '../../models/color_palette.dart';

class Themes {
  static final ThemeData darkTheme = ThemeData(
    fontFamily: 'Proxima Nova',
    primaryColor: ColorPalette._primary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorPalette._primary,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: Color.fromARGB(255,32,33,36),
    brightness: Brightness.dark,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Text Theme
    textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: Colors.white,   //ColorPalette._text,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(color: const Color.fromRGBO(221, 255, 255, 1),// ColorPalette._text,
         fontSize: 24),
        titleMedium: TextStyle(color: Colors.white //ColorPalette._text[400]
        ),
        titleSmall:
            TextStyle(color: Colors.white, //ColorPalette._text,
             fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: Colors.white,
          fontWeight: FontWeight.normal),
        // Default Style for body medium
        labelLarge: TextStyle(
            color:Colors.white, //ColorPalette._text,
            letterSpacing: 0,
            fontWeight: FontWeight.normal),
        labelSmall: const TextStyle(
            color: Colors.white, letterSpacing: 0, fontSize: 12)),
    appBarTheme: AppBarTheme(
        backgroundColor: Color.fromARGB(255,32,33,36),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: Color.fromARGB(221, 255, 255, 255),
            fontSize: 24,
            fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: Colors.white)),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.white,
        selectedItemColor: ColorPalette._secondary[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorPalette._primary[500],
        showUnselectedLabels: true),
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: ColorPalette._success,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: ColorPalette._success)),
            textStyle: const TextStyle(
                fontFamily: "Proxima Nova",
                color: Color.fromRGBO(221, 255, 255, 1),
                fontWeight: FontWeight.bold))),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(ColorPalette._primary.shade50),
      )
    ),
    // Floating Action Button Theme
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(elevation: 5),

    // TextFormField
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,

      border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.white)),
      // fillColor: Colors.white,
      // constraints: const BoxConstraints(minHeight: 50),
      // prefixIconColor: ColorPalette._secondary,
      // contentPadding: EdgeInsets.zero,
      alignLabelWithHint: true,
      labelStyle: TextStyle(
          color: ColorPalette._text[50], fontWeight: FontWeight.normal),
      hintStyle: const TextStyle(fontWeight: FontWeight.normal),

      // enabledBorder: border,
      // focusedBorder: border,
      // errorBorder: errorBorder,
      // focusedErrorBorder: errorBorder,
      // errorStyle: const TextStyle(color: ColorPalette._error)
    ),

    // Card Theme
    cardTheme: CardTheme(
        color: Color.fromARGB(255,48,49,52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias),

    // ListTile Theme
    listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textColor: Colors.white,
        tileColor: Color.fromARGB(197, 75, 76, 76)),
    //ExpansionTile Theme
    dividerColor: Colors.transparent,
    expansionTileTheme: ExpansionTileThemeData(
      textColor: Colors.white ,
      iconColor: Colors.black,
      collapsedIconColor: Colors.black,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: ColorPalette._secondary),

    // Divider Theme
    dividerTheme: DividerThemeData(color: ColorPalette._primary, thickness: 2),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)))),
    // Chip Theme
    chipTheme: ChipThemeData(
        backgroundColor: Color.fromARGB(255, 69, 69, 70),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        )),

    // Dialog Theme
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        alignment: Alignment.center,
        titleTextStyle: TextStyle(
            color: ColorPalette._primary.shade50,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
    
  );




  static final ThemeData theme = ThemeData(
    fontFamily: 'Proxima Nova',
    primaryColor: ColorPalette._primary,
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: ColorPalette._primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // Text Theme
    textTheme: TextTheme(
        headlineSmall: TextStyle(
          color: ColorPalette._text,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(color: ColorPalette._text, fontSize: 24),
        titleMedium: TextStyle(color: ColorPalette._text[400]),
        titleSmall:
            TextStyle(color: ColorPalette._text, fontWeight: FontWeight.w500),
        bodyLarge: const TextStyle(fontWeight: FontWeight.normal),
        // Default Style for body medium
        labelLarge: TextStyle(
            color: ColorPalette._text,
            letterSpacing: 0,
            fontWeight: FontWeight.normal),
        labelSmall: const TextStyle(
            color: Colors.grey, letterSpacing: 0, fontSize: 12)),
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            color: ColorPalette._text[400],
            fontSize: 24,
            fontWeight: FontWeight.w700),
        iconTheme: IconThemeData(color: ColorPalette._text)),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        unselectedItemColor: Colors.white,
        selectedItemColor: ColorPalette._secondary[400],
        type: BottomNavigationBarType.fixed,
        backgroundColor: ColorPalette._primary[500],
        showUnselectedLabels: true),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: ColorPalette._success,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: ColorPalette._success)),
            textStyle: const TextStyle(
                fontFamily: "Proxima Nova",
                color: Colors.white,
                fontWeight: FontWeight.bold))),

    // Floating Action Button Theme
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(elevation: 5),

    // TextFormField
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,

      border: const UnderlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)),
      // fillColor: Colors.white,
      // constraints: const BoxConstraints(minHeight: 50),
      // prefixIconColor: ColorPalette._secondary,
      // contentPadding: EdgeInsets.zero,
      alignLabelWithHint: true,
      labelStyle: TextStyle(
          color: ColorPalette._text[900], fontWeight: FontWeight.normal),
      hintStyle: const TextStyle(fontWeight: FontWeight.normal),

      // enabledBorder: border,
      // focusedBorder: border,
      // errorBorder: errorBorder,
      // focusedErrorBorder: errorBorder,
      // errorStyle: const TextStyle(color: ColorPalette._error)
    ),

    // Card Theme
    cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias),

    // ListTile Theme
    listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textColor: ColorPalette._text,
        tileColor: const Color.fromRGBO(3, 162, 220, 0.3)),
    //ExpansionTile Theme
    dividerColor: Colors.transparent,
    expansionTileTheme: ExpansionTileThemeData(
      textColor: ColorPalette._text,
      iconColor: Colors.black,
      collapsedIconColor: ColorPalette._primary,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: ColorPalette._secondary),

    // Divider Theme
    dividerTheme: DividerThemeData(color: ColorPalette._primary, thickness: 2),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)))),
    // Chip Theme
    chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE1E0EC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        )),

    // Dialog Theme
    dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        alignment: Alignment.center,
        titleTextStyle: TextStyle(
            color: ColorPalette._primary,
            fontSize: 22,
            fontWeight: FontWeight.bold)),
  );


  static InputBorder border = const OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(116, 52, 47, 129)),
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
  static const Color _primaryColor = Color(0xFF342f81);
  static const Color _textColor = Color(0xFF262626);
  static final Map<int, Color> _textColorShades = {
    50: const Color(0xFF939393),
    100: const Color(0xFF7d7d7d),
    200: const Color(0xFF676767),
    300: const Color(0xFF515151),
    400: const Color(0xFF3c3c3c),
    500: const Color(0xFF262626),
    600: const Color(0xFF222222),
    700: const Color(0xFF1e1e1e),
    800: const Color(0xFF1b1b1b),
    900: const Color(0xFF171717),
  };
  static final Map<int, Color> _primaryColorShades = {
    50: const Color(0xFF9a97c0),
    100: const Color(0xFF8582b3),
    200: const Color(0xFF716da7),
    300: const Color(0xFF5d599a),
    400: const Color(0xFF48448e),
    500: const Color(0xFF342f81),
    600: const Color(0xFF2f2a74),
    700: const Color(0xFF2a2667),
    800: const Color(0xFF24215a),
    900: const Color(0xFF1f1c4d),
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
  static final MaterialColor _text =
      MaterialColor(_textColor.value, _textColorShades);
  static const MaterialColor _secondary = Colors.lightBlue;
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
      error: _error,
    );
  }
}
