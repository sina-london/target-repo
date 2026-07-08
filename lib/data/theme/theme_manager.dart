import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum ThemeType {
  light,
  dark,
  modernMint,
  oceanBreeze,
  midnightPro,
  rosePetal,
  monochrome,
  techMinimal,
  nordicFrost,
  warmCoffee,
  ultraViolet,
  neoTokyo,
  // New themes
  emeraldForest,
  sunsetGold,
  digitalLavender,
  materialGrey,
  nightBlue,
  forestMoss,
  desertSand,
  arcticIce,
}

class ThemeManager {
  static ThemeType? getThemeType(String themeName) {
    String lowerThemeName = themeName.toLowerCase();
    for (ThemeType type in ThemeType.values) {
      if (type.toString().split('.').last.toLowerCase() == lowerThemeName) {
        return type;
      }
    }
    return null;
  }

  static ThemeData getTheme(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF2196F3),
            secondary: Color(0xFF03A9F4),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.dark:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF1565C0),
            secondary: Color(0xFF0277BD),
            surface: Color(0xFF121212),
            background: Color(0xFF000000),
          ),
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      case ThemeType.modernMint:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF00BFA5),
            secondary: Color(0xFF1DE9B6),
            tertiary: Color(0xFF64FFDA),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.oceanBreeze:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF0288D1),
            secondary: Color(0xFF03A9F4),
            tertiary: Color(0xFF4FC3F7),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.midnightPro:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF3949AB),
            secondary: Color(0xFF5C6BC0),
            tertiary: Color(0xFF7986CB),
            surface: Color(0xFF121212),
            background: Color(0xFF000000),
          ),
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      case ThemeType.rosePetal:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFFE91E63),
            secondary: Color(0xFFEC407A),
            tertiary: Color(0xFFF48FB1),
            surface: Colors.white,
            background: Color(0xFFFCE4EC),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.monochrome:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF424242),
            secondary: Color(0xFF616161),
            tertiary: Color(0xFF757575),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.techMinimal:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF1976D2),
            secondary: Color(0xFF2196F3),
            tertiary: Color(0xFF64B5F6),
            surface: Colors.white,
            background: Color(0xFFFAFAFA),
          ),
          textTheme: GoogleFonts.robotoMonoTextTheme(),
        );

      case ThemeType.nordicFrost:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF4FC3F7),
            secondary: Color(0xFF81D4FA),
            tertiary: Color(0xFFB3E5FC),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.warmCoffee:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF795548),
            secondary: Color(0xFF8D6E63),
            tertiary: Color(0xFFA1887F),
            surface: Color(0xFFEFEBE9),
            background: Color(0xFFD7CCC8),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.ultraViolet:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF6200EA),
            secondary: Color(0xFF7C4DFF),
            tertiary: Color(0xFFB388FF),
            surface: Colors.white,
            background: Color(0xFFF3E5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.neoTokyo:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Color(0xFFE91E63),
            secondary: Color(0xFF00BCD4),
            tertiary: Color(0xFFFFEB3B),
            surface: Color(0xFF121212),
            background: Color(0xFF000000),
          ),
          textTheme: GoogleFonts.cabinCondensedTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      // New Themes
      case ThemeType.emeraldForest:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF2E7D32),
            secondary: Color(0xFF388E3C),
            tertiary: Color(0xFF43A047),
            surface: Colors.white,
            background: Color(0xFFE8F5E9),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.sunsetGold:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFFFF6F00),
            secondary: Color(0xFFFF8F00),
            tertiary: Color(0xFFFFA000),
            surface: Colors.white,
            background: Color(0xFFFFF3E0),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.digitalLavender:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF7B1FA2),
            secondary: Color(0xFF9C27B0),
            tertiary: Color(0xFFAB47BC),
            surface: Colors.white,
            background: Color(0xFFF3E5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.materialGrey:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF455A64),
            secondary: Color(0xFF546E7A),
            tertiary: Color(0xFF607D8B),
            surface: Colors.white,
            background: Color(0xFFECEFF1),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.nightBlue:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.dark(
            primary: Color(0xFF1A237E),
            secondary: Color(0xFF283593),
            tertiary: Color(0xFF303F9F),
            surface: Color(0xFF121212),
            background: Color(0xFF000000),
          ),
          textTheme: GoogleFonts.interTextTheme().apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        );

      case ThemeType.forestMoss:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF33691E),
            secondary: Color(0xFF558B2F),
            tertiary: Color(0xFF689F38),
            surface: Colors.white,
            background: Color(0xFFF1F8E9),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.desertSand:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFFBF360C),
            secondary: Color(0xFFD84315),
            tertiary: Color(0xFFE64A19),
            surface: Color(0xFFFBE9E7),
            background: Color(0xFFFBE9E7),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      case ThemeType.arcticIce:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF00ACC1),
            secondary: Color(0xFF00BCD4),
            tertiary: Color(0xFF26C6DA),
            surface: Colors.white,
            background: Color(0xFFE0F7FA),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );

      default:
        return ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: Color(0xFF2196F3),
            secondary: Color(0xFF03A9F4),
            surface: Colors.white,
            background: Color(0xFFF5F5F5),
          ),
          textTheme: GoogleFonts.interTextTheme(),
        );
    }
  }
}