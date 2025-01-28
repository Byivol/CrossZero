import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  return ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.black,
      errorStyle: const TextStyle(color: Color.fromARGB(112, 255, 0, 0)),
      hintStyle: const TextStyle(color: Color.fromARGB(112, 0, 0, 0)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(112, 255, 0, 0),
            width: 1.0,
          )),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(112, 255, 0, 0),
          width: 1.0,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color.fromARGB(206, 0, 0, 0),
          width: 1.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
    ),
    listTileTheme: ListTileThemeData(textColor: Colors.black),
    cardTheme: CardTheme(
      shadowColor: Colors.black,
      color: Colors.white,
    ),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
        selectionHandleColor: const Color.fromARGB(150, 0, 0, 0),
        selectionColor: const Color.fromARGB(55, 0, 0, 0),
        cursorColor: const Color.fromARGB(150, 0, 0, 0)),
    textTheme: const TextTheme(
      bodySmall: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
      labelSmall: TextStyle(color: Colors.black),
      labelLarge: TextStyle(color: Colors.black),
      labelMedium: TextStyle(color: Colors.black),
      titleSmall: TextStyle(color: Colors.black),
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.black),
      displaySmall: TextStyle(color: Colors.black),
      displayLarge: TextStyle(color: Colors.black),
      displayMedium: TextStyle(color: Colors.black),
      headlineSmall: TextStyle(color: Colors.black),
      headlineLarge: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
    ),
  );
}
