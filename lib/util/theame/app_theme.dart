import 'package:flutter/material.dart';

class AppTheme {

  /// Main Brand Color
  static const Color primaryColor = Color(0xFF050660);

  /// Light Theme
  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    primaryColor: primaryColor,

    scaffoldBackgroundColor: Colors.white,

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),

    /// Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    /// Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
      ),
    ),

    /// Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),

    /// Input Field Theme
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
    ),

    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: const Color(0xFF050660),
      headerForegroundColor: Colors.white,

      // ✅ Selected dates (normal + today dono ke liye)
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF050660);   // blue background
        }
        return null;
      }),

      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;              // white text on selected
        }
        return Colors.black;                // normal dates black
      }),

      // ✅ Today specific styling (sirf jab today unselected ho)
      todayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.white;              // important: selected today → white text
        }
        return const Color(0xFF050660);     // unselected today → blue text
      }),

      todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const Color(0xFF050660);   // selected today → blue background
        }
        return null;                        // unselected today → no background
      }),

      todayBorder: const BorderSide(
        color: Color(0xFF050660),
        width: 1.5,
      ),
    ),

    /// Time Picker Theme
    timePickerTheme: const TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: primaryColor,
      hourMinuteTextColor: Colors.white,
      dialHandColor: primaryColor,
      dialBackgroundColor: Color(0xFFEDEDED),
    ),

    /// Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(primaryColor),
    ),

    /// Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.all(primaryColor),
      trackColor: MaterialStateProperty.all(primaryColor.withOpacity(0.5)),
    ),

    /// Floating Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),

    /// Tab Bar Theme
    tabBarTheme: const TabBarTheme(
      labelColor: primaryColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: primaryColor,
    ),

  );
}