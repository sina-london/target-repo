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
    final textTheme = GoogleFonts.poppinsTextTheme();

    return _createThemeData(
      colorScheme: _getColorScheme(themeType),
      textTheme: textTheme,
    );
  }

  static ThemeData _createThemeData({required ColorScheme colorScheme, required TextTheme textTheme}) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
    );
  }

  static ColorScheme _getColorScheme(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return ColorScheme.light(
          primary: Color(0xFF757575), // Neutral gray
          secondary: Color(0xFF9E9E9E), // Lighter gray
          surface: Color(0xFFF5F5F5),
          onSurface: Colors.black87,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        );
       case ThemeType.dark:
        return ColorScheme.dark(
          primary: Color(0xFF424242), // Dark neutral
          secondary: Color(0xFF616161), // Slightly lighter dark gray
          surface: Color.fromARGB(255, 13, 13, 13),
          onSurface: Colors.white,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
        );
      case ThemeType.modernMint:
        return ColorScheme.light(
          primary: Color(0xFF00BFA5),
          secondary: Color(0xFF1DE9B6),
          surface: Color(0xFFE0F2F1),
        );
      case ThemeType.oceanBreeze:
        return ColorScheme.light(
          primary: Color(0xFF0288D1),
          secondary: Color(0xFF03A9F4),
          surface: Color(0xFFE3F2FD),
        );
      case ThemeType.midnightPro:
        return ColorScheme.dark(
          primary: Color(0xFF3949AB),
          secondary: Color(0xFF5C6BC0),
          surface: Color(0xFF1A237E),
        );
      case ThemeType.rosePetal:
        return ColorScheme.light(
          primary: Color(0xFFE91E63),
          secondary: Color(0xFFEC407A),
          surface: Color(0xFFFCE4EC),
        );
      case ThemeType.monochrome:
        return ColorScheme.light(
          primary: Color(0xFF424242),
          secondary: Color(0xFF616161),
          surface: Color(0xFFF5F5F5),
        );
      case ThemeType.techMinimal:
        return ColorScheme.light(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF2196F3),
          surface: Color(0xFFFAFAFA),
        );
      case ThemeType.nordicFrost:
        return ColorScheme.light(
          primary: Color(0xFF4FC3F7),
          secondary: Color(0xFF81D4FA),
          surface: Color(0xFFE1F5FE),
        );
      case ThemeType.warmCoffee:
        return ColorScheme.light(
          primary: Color(0xFF795548),
          secondary: Color(0xFF8D6E63),
          surface: Color(0xFFD7CCC8),
        );
      case ThemeType.ultraViolet:
        return ColorScheme.light(
          primary: Color(0xFF6200EA),
          secondary: Color(0xFF7C4DFF),
          surface: Color(0xFFEDE7F6),
        );
      case ThemeType.neoTokyo:
        return ColorScheme.dark(
          primary: Color(0xFFE91E63),
          secondary: Color(0xFF00BCD4),
          surface: Color(0xFF2C2C2C),
        );
      case ThemeType.emeraldForest:
        return ColorScheme.light(
          primary: Color(0xFF2E7D32),
          secondary: Color(0xFF388E3C),
          surface: Color(0xFFE8F5E9),
        );
      case ThemeType.sunsetGold:
        return ColorScheme.light(
          primary: Color(0xFFFF6F00),
          secondary: Color(0xFFFF8F00),
          surface: Color(0xFFFFF3E0),
        );
      case ThemeType.digitalLavender:
        return ColorScheme.light(
          primary: Color(0xFF7B1FA2),
          secondary: Color(0xFF9C27B0),
          surface: Color(0xFFF3E5F5),
        );
      case ThemeType.materialGrey:
        return ColorScheme.light(
          primary: Color(0xFF455A64),
          secondary: Color(0xFF546E7A),
          surface: Color(0xFFECEFF1),
        );
      case ThemeType.nightBlue:
        return ColorScheme.dark(
          primary: Color(0xFF1A237E),
          secondary: Color(0xFF283593),
          surface: Color(0xFF0D47A1),
        );
      case ThemeType.forestMoss:
        return ColorScheme.light(
          primary: Color(0xFF33691E),
          secondary: Color(0xFF558B2F),
          surface: Color(0xFFE8F5E9),
        );
      case ThemeType.desertSand:
        return ColorScheme.light(
          primary: Color(0xFFBF360C),
          secondary: Color(0xFFD84315),
          surface: Color(0xFFFFF8E1),
        );
      case ThemeType.arcticIce:
        return ColorScheme.light(
          primary: Color(0xFF00ACC1),
          secondary: Color(0xFF00BCD4),
          surface: Color(0xFFE0F7FA),
        );
      default:
        return ColorScheme.light(
          primary: Color(0xFF2196F3),
          secondary: Color(0xFF03A9F4),
          surface: Colors.white,
        );
    }
  }
}
