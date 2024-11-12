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
      style: ListTileStyle
          .drawer, // This can be adjusted for different list styles
      iconColor: Colors.black54, // Default icon color
    );

    switch (themeType) {
      case ThemeType.light:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          secondaryHeaderColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.black,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileThemeData.copyWith(
            tileColor: Colors.white,
            selectedTileColor: Colors.black12,
          ),
          textTheme: baseTextTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            titleLarge:
                baseTextTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        );

      case ThemeType.dark:
        return ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black87,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileThemeData.copyWith(
            tileColor: Colors.black26,
            selectedTileColor: Colors.black38,
          ),
          textTheme: baseTextTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            titleLarge: baseTextTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w500, color: Colors.white),
            titleSmall:
                baseTextTheme.titleSmall?.copyWith(color: Colors.grey),

            headlineMedium: baseTextTheme.headlineMedium?.copyWith(color: Colors.white),
            labelMedium: baseTextTheme.labelMedium?.copyWith(color: Colors.white),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(color: Colors.white)
            
          ),
        );

      case ThemeType.greenForest:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green,
          scaffoldBackgroundColor: Colors.green[50],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.tealAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileThemeData.copyWith(
            tileColor: Colors.green[100],
            selectedTileColor: Colors.green[200],
          ),
          textTheme: baseTextTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            // bodyText1: baseTextTheme.bodyText1?.copyWith(color: Colors.green[800]),
            // subtitle1: baseTextTheme.subtitle1?.copyWith(color: Colors.green[600]),
          ),
        );

      case ThemeType.purpleMystic:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.purple,
          scaffoldBackgroundColor: Colors.purple[50],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepPurpleAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileThemeData.copyWith(
            tileColor: Colors.purple[100],
            selectedTileColor: Colors.purple[200],
          ),
          textTheme: baseTextTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            // bodyText1: baseTextTheme.bodyText1?.copyWith(color: Colors.deepPurple),
            // subtitle1: baseTextTheme.subtitle1?.copyWith(color: Colors.deepPurple[300]),
          ),
        );

      case ThemeType.sunsetOrange:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          scaffoldBackgroundColor: Colors.orange[50],
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: Colors.deepOrangeAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrangeAccent,
              foregroundColor: Colors.white,
            ),
          ),
          listTileTheme: listTileThemeData.copyWith(
            tileColor: Colors.orange[100],
            selectedTileColor: Colors.orange[200],
          ),
          textTheme: baseTextTheme.copyWith(
            headlineLarge: baseTextTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
            // bodyText1: baseTextTheme.bodyText1?.copyWith(color: Colors.deepOrange),
            // subtitle1: baseTextTheme.subtitle1?.copyWith(color: Colors.orange[700]),
          ),
        );

      default:
        return ThemeData.light().copyWith(
          textTheme: baseTextTheme,
        );
    }
  }
}
