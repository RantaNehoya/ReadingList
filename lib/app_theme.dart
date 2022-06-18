import 'package:flutter/material.dart';

//TODO: DATA PERSISTENCE
class AppTheme {

  //light mode configuration
  static final lightMode = ThemeData(
    colorScheme: const ColorScheme(
      primary: Color(0xFFF76E11),
      secondary: Color(0xFFFC4F4F),
      background: Colors.white,
      brightness: Brightness.light,

      error: Colors.red,
      surface: Colors.white,

      onBackground: Colors.black,
      onError: Colors.red,
      onPrimary: Colors.black54,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),

    primaryColor: const Color(0xFFF76E11),
    primaryColorLight: const Color(0xFFFFBC80),
    primaryColorDark: const Color(0xFFFF9F45),
    fontFamily: 'Dosis',

    iconTheme: const IconThemeData(
      color: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      foregroundColor: Colors.black,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
    ),

    scaffoldBackgroundColor: Colors.white,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.black54,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      floatingLabelStyle: const TextStyle(
        color: Colors.black54,
      ),

      iconColor: Colors.white54,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white54,
    ),

    // textButtonTheme: ,
  );

  //dark mode configuration
  static final darkMode = ThemeData(
    colorScheme: const ColorScheme(
      primary: Color(0xFF461111),
      secondary: Color(0xFFB3541E),
      background: Color(0xFF040303),
      brightness: Brightness.dark,

      error: Colors.red,
      surface: Color(0xFFA13333),

      onBackground: Colors.white,
      onError: Colors.red,
      onPrimary: Colors.white54,
      onSecondary: Colors.white,
      onSurface: Colors.white,
    ),

    primaryColor: const Color(0xFFA13333),
    primaryColorLight: const Color(0xFFA13333),
    primaryColorDark: const Color(0xFF461111),
    fontFamily: 'Dosis',
    // buttonTheme: ButtonThemeData(
    //
    // ),

    iconTheme: const IconThemeData(
      color: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      foregroundColor: Colors.white,
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF040303),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
    ),

    scaffoldBackgroundColor: Color(0xFF040303),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: const TextStyle(
        color: Colors.white54,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),

      floatingLabelStyle: const TextStyle(
        color: Colors.white54,
      ),

      iconColor: Colors.white54,
    ),

    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Colors.white54,
    ),

    // textButtonTheme: ,
  );
}

class ThemeProvider extends ChangeNotifier{

  bool _isDark = false;

  //getter
  bool get isDark => _isDark;

  //setter
  void changeTheme (bool val){
    _isDark = val;
    notifyListeners();
  }

}