import 'package:flutter/material.dart';

class AppTheme {
  // Dark theme colors
  static const Color darkPrimaryColor = Color(0xff28397f); // Dark blue
  static const Color darkBackgroundColor = Color(0xff121212); // Dark background
  static const Color darkTextColor = Colors.white; // White text
  static const Color darkAccentColor = Color(0xff00a9fe); // Light blue

  // Light theme colors
  static const Color lightPrimaryColor = Colors.white;
  static const Color lightBackgroundColor = Colors.grey;
  static const Color lightTextColor = Colors.black;
  static const Color lightAccentColor = Color(0xff28397f);

  // Function to get the current theme based on dark mode
  static ThemeData getTheme(bool isDarkMode) {
    ColorScheme colorScheme = isDarkMode
        ? ColorScheme.dark(
      primary: darkPrimaryColor,
      surface: darkBackgroundColor,
      onSurface: darkTextColor,
    )
        : ColorScheme.light(
      primary: lightPrimaryColor,
      surface: lightBackgroundColor,
      onSurface: lightTextColor,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDarkMode ? darkBackgroundColor : lightBackgroundColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: isDarkMode ? darkTextColor : lightTextColor,
        ),
        bodyMedium: TextStyle(
          color: isDarkMode ? darkTextColor : lightTextColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            isDarkMode ? darkPrimaryColor : lightPrimaryColor,
          ),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      // Define more theme properties as needed...
    );
  }
}
