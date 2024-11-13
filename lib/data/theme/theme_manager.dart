import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeType {
  light,
  dark,
  greenForest,
  purpleMystic,
  sunsetOrange,
  modernMint,      // Fresh, clean look
  oceanBreeze,     // Calming blue theme
  midnightPro,     // Professional dark theme
  rosePetal,       // Soft pink theme
  monochrome,      // Black and white
  techMinimal,     // Minimalist with accent
  nordicFrost,     // Scandinavian inspired
  warmCoffee,      // Earthy tones
  ultraViolet,     // Modern purple
  neoTokyo,        // Cyberpunk inspired
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

        
        case ThemeType.modernMint:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF00BFA5),
          scaffoldBackgroundColor: Color(0xFFF5F9F9),
          colorScheme: ColorScheme.light(
            primary: Color(0xFF00BFA5),
            secondary: Color(0xFF4CAF50),
            surface: Colors.white,
            background: Color(0xFFF5F9F9),
            error: Colors.redAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF00BFA5),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF00BFA5),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          textTheme: GoogleFonts.interTextTheme(textTheme),
        );

      case ThemeType.oceanBreeze:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF039BE5),
          scaffoldBackgroundColor: Color(0xFFF5F8FA),
          colorScheme: ColorScheme.light(
            primary: Color(0xFF039BE5),
            secondary: Color(0xFF00ACC1),
            surface: Colors.white,
            background: Color(0xFFF5F8FA),
            error: Colors.redAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF039BE5),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          textTheme: GoogleFonts.dmSansTextTheme(textTheme),
        );

      case ThemeType.midnightPro:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF2C2C2E),
          scaffoldBackgroundColor: Color(0xFF1C1C1E),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF2C2C2E),
            secondary: Color(0xFF0A84FF),
            surface: Color(0xFF2C2C2E),
            background: Color(0xFF1C1C1E),
            error: Color(0xFFFF453A),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF1C1C1E),
            elevation: 0,
          ),
          cardTheme: CardTheme(
            color: Color(0xFF2C2C2E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      case ThemeType.rosePetal:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFFFF4081),
          scaffoldBackgroundColor: Color(0xFFFFF5F8),
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF4081),
            secondary: Color(0xFFFF80AB),
            surface: Colors.white,
            background: Color(0xFFFFF5F8),
            error: Colors.redAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFFF4081),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.quicksandTextTheme(textTheme),
        );

      case ThemeType.monochrome:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(
            primary: Colors.black,
            secondary: Colors.grey[800]!,
            surface: Colors.white,
            background: Colors.white,
            error: Colors.red[900]!,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(textTheme),
        );

      case ThemeType.techMinimal:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF6200EE),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF6200EE),
            secondary: Color(0xFF03DAC6),
            surface: Colors.white,
            background: Colors.white,
            error: Color(0xFFB00020),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Color(0xFF6200EE),
          ),
          textTheme: GoogleFonts.rubikTextTheme(textTheme),
        );

      case ThemeType.nordicFrost:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF81A1C1),
          scaffoldBackgroundColor: Color(0xFFECEFF4),
          colorScheme: ColorScheme.light(
            primary: Color(0xFF81A1C1),
            secondary: Color(0xFF88C0D0),
            surface: Colors.white,
            background: Color(0xFFECEFF4),
            error: Color(0xFFBF616A),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF81A1C1),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.nunitoTextTheme(textTheme),
        );

      case ThemeType.warmCoffee:
        return ThemeData(
          brightness: Brightness.light,
          primaryColor: Color(0xFF795548),
          scaffoldBackgroundColor: Color(0xFFF5F5F5),
          colorScheme: ColorScheme.light(
            primary: Color(0xFF795548),
            secondary: Color(0xFFBCAAA4),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
            error: Colors.redAccent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF795548),
            elevation: 0,
            foregroundColor: Colors.white,
          ),
          textTheme: GoogleFonts.loraTextTheme(textTheme),
        );

      case ThemeType.ultraViolet:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFF9C27B0),
          scaffoldBackgroundColor: Color(0xFF1A1A1A),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF9C27B0),
            secondary: Color(0xFFE040FB),
            surface: Color(0xFF2D2D2D),
            background: Color(0xFF1A1A1A),
            error: Color(0xFFCF6679),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF9C27B0),
            elevation: 0,
          ),
          textTheme: GoogleFonts.chakraPetchTextTheme(textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      case ThemeType.neoTokyo:
        return ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color(0xFFFF0080),
          scaffoldBackgroundColor: Color(0xFF0D0D0D),
          colorScheme: ColorScheme.dark(
            primary: Color(0xFFFF0080),
            secondary: Color(0xFF00FFF0),
            surface: Color(0xFF1A1A1A),
            background: Color(0xFF0D0D0D),
            error: Color(0xFFFF3D3D),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF0D0D0D),
            elevation: 0,
            foregroundColor: Color(0xFFFF0080),
          ),
          textTheme: GoogleFonts.blinkerTextTheme(textTheme).apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );
      default:
        return ThemeData.light().copyWith(
          textTheme: baseTextTheme,
        );
    }
  }
}