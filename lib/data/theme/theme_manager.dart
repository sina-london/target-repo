import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeType {
  light,
  dark,
  greenForest,
  purpleMystic,
  sunsetOrange,
}

class ThemeManager {
  static ThemeData getTheme(ThemeType themeType) {
    TextTheme baseTextTheme = GoogleFonts.poppinsTextTheme();
    final listTileThemeData = ListTileThemeData(
      style: ListTileStyle.drawer,
      iconColor: Colors.black54,
    );

    final colorScheme = ColorScheme.fromSwatch();

    final appBarTheme = AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    );

    final elevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );

    final listTileTheme = listTileThemeData.copyWith(
      tileColor: Colors.white,
      selectedTileColor: Colors.black12,
    );

    final textTheme = baseTextTheme.copyWith(
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
      titleLarge: baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
    );

    switch (themeType) {
      case ThemeType.light:
        return ThemeData.light().copyWith(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          secondaryHeaderColor: Colors.black,
          colorScheme: colorScheme.copyWith(
            secondary: Colors.black,
          ),
          appBarTheme: appBarTheme,
          elevatedButtonTheme: elevatedButtonTheme,
          listTileTheme: listTileTheme,
          textTheme: textTheme,
        );

      case ThemeType.dark:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black87,
          appBarTheme: appBarTheme,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileTheme.copyWith(
            tileColor: Colors.black26,
            selectedTileColor: Colors.black38,
          ),
          textTheme: textTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            titleLarge: baseTextTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
            titleSmall: baseTextTheme.titleSmall?.copyWith(color: Colors.grey),
            headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: Colors.white),
            labelMedium: baseTextTheme.labelMedium?.copyWith(color: Colors.white),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.white),
          ),
        );

      case ThemeType.greenForest:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.green[50],
          colorScheme: colorScheme.copyWith(
            secondary: Colors.tealAccent,
          ),
          appBarTheme: appBarTheme.copyWith(
            backgroundColor: Colors.green,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileTheme.copyWith(
            tileColor: Colors.green[100],
            selectedTileColor: Colors.green[200],
          ),
          textTheme: textTheme,
        );

      case ThemeType.purpleMystic:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.purple[50],
          colorScheme: colorScheme.copyWith(
            secondary: Colors.deepPurpleAccent,
          ),
          appBarTheme: appBarTheme.copyWith(
            backgroundColor: Colors.purple,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileTheme.copyWith(
            tileColor: Colors.purple[100],
            selectedTileColor: Colors.purple[200],
          ),
          textTheme: textTheme,
        );

      case ThemeType.sunsetOrange:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          scaffoldBackgroundColor: Colors.orange[50],
          colorScheme: colorScheme.copyWith(
            secondary: Colors.deepOrangeAccent,
          ),
          appBarTheme: appBarTheme.copyWith(
            backgroundColor: Colors.orange,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileTheme.copyWith(
            tileColor: Colors.orange[100],
            selectedTileColor: Colors.orange[200],
          ),
          textTheme: textTheme,
        );

      default:
        return ThemeData.light().copyWith(
          textTheme: baseTextTheme,
        );
    }
  }
}