import 'package:flutter/material.dart';

class Palette {
  // This class is not meant to be instantiated or extended; this constructor
  // prevents instantiation and extension.
  Palette._();

  // static const Color darkBlue = const Color(0xFF34495E);
  static const Color lightBlue = const Color(0xFF455D76);
  static final Color orange = Colors.amberAccent[700];
  static final Color green = Colors.greenAccent[700];
  static final Color whiteTransparent = white[600];
  static final Color darkBlueTransparent = darkBlue[600];

  static final Map<int, Color> _blueCodes = {
    50: Color.fromRGBO(52, 73, 94, .1),
    100: Color.fromRGBO(52, 73, 94, .2),
    200: Color.fromRGBO(52, 73, 94, .3),
    300: Color.fromRGBO(52, 73, 94, .4),
    400: Color.fromRGBO(52, 73, 94, .5),
    500: Color.fromRGBO(52, 73, 94, .6),
    600: Color.fromRGBO(52, 73, 94, .7),
    700: Color.fromRGBO(52, 73, 94, .8),
    800: Color.fromRGBO(52, 73, 94, .9),
    900: Color.fromRGBO(52, 73, 94, 1),
  };
  static final MaterialColor darkBlue = MaterialColor(0xFF34495E, _blueCodes);

  static final Map<int, Color> _whiteCodes = {
    50: Color.fromRGBO(245, 245, 245, .1),
    100: Color.fromRGBO(245, 245, 245, .2),
    200: Color.fromRGBO(245, 245, 245, .3),
    300: Color.fromRGBO(245, 245, 245, .4),
    400: Color.fromRGBO(245, 245, 245, .5),
    500: Color.fromRGBO(245, 245, 245, .6),
    600: Color.fromRGBO(245, 245, 245, .7),
    700: Color.fromRGBO(245, 245, 245, .8),
    800: Color.fromRGBO(245, 245, 245, .9),
    900: Color.fromRGBO(245, 245, 245, 1),
  };
  static final MaterialColor white = MaterialColor(0xFFF5F5F5, _whiteCodes);

  static final ElevatedButtonThemeData elevatedButtonThemeData =
      ElevatedButtonThemeData(
    style: ButtonStyle(
      textStyle: MaterialStateProperty.all<TextStyle>(
        TextStyle(fontSize: 24),
      ),
      foregroundColor: MaterialStateProperty.all<Color>(white),
      padding:
          MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(16)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
      // primarySwatch: darkBlue,
      primaryColor: darkBlue,
      accentColor: lightBlue,
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: white),
      ),
      textTheme: TextTheme(
        bodyText2: TextStyle(fontSize: 24, color: whiteTransparent),
        headline4: TextStyle(fontSize: 42, color: whiteTransparent),
        headline5: TextStyle(fontSize: 48, color: whiteTransparent),
      ),
      scaffoldBackgroundColor: darkBlue,
      elevatedButtonTheme: elevatedButtonThemeData,
      canvasColor: darkBlue,
      unselectedWidgetColor: whiteTransparent,
      appBarTheme: AppBarTheme(actionsIconTheme: IconThemeData(color: white)));

  static final ThemeData lightTheme = ThemeData(
    primaryColor: white,
    accentColor: darkBlueTransparent,
    primaryTextTheme: TextTheme(
      headline6: TextStyle(color: darkBlue),
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(fontSize: 24, color: darkBlueTransparent),
      headline4: TextStyle(fontSize: 42, color: darkBlueTransparent),
      headline5: TextStyle(fontSize: 48, color: darkBlueTransparent),
    ),
    scaffoldBackgroundColor: white,
    elevatedButtonTheme: elevatedButtonThemeData,
    canvasColor: white,
    unselectedWidgetColor: darkBlueTransparent,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: darkBlue),
    ),
  );
}
