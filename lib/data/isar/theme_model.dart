import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

part 'theme_model.g.dart';

@collection
class ThemeSettings {
  Id id = Isar.autoIncrement;

  late String themeMode;
  late bool amoled;
  late String colorScheme;
  late bool useMaterial3;
  late bool useSubThemes;
  late double surfaceModeLight;
  late double surfaceModeDark;
  late bool useKeyColors;
  late bool useAppbarColors;
  late bool swapLightColors;
  late bool swapDarkColors;
  late bool useTertiary;
  late int blendLevel;
  late double appBarOpacity;
  late bool transparentStatusBar;
  late double tabBarOpacity;
  late double bottomBarOpacity;
  late bool tooltipsMatchBackground;
  late double defaultRadius;
  late bool useTextTheme;
  late String tabBarStyle;

  ThemeSettings({
    this.themeMode = 'system',
    this.amoled = false,
    this.colorScheme = 'red',
    this.useMaterial3 = true,
    this.useSubThemes = true,
    this.surfaceModeLight = 0,
    this.surfaceModeDark = 0,
    this.useKeyColors = true,
    this.useAppbarColors = false,
    this.swapLightColors = false,
    this.swapDarkColors = false,
    this.useTertiary = true,
    this.blendLevel = 0,
    this.appBarOpacity = 1.0,
    this.transparentStatusBar = false,
    this.tabBarOpacity = 1.0,
    this.bottomBarOpacity = 1.0,
    this.tooltipsMatchBackground = false,
    this.defaultRadius = 12.0,
    this.useTextTheme = true,
    this.tabBarStyle = 'forBackground',
  });

  ThemeSettings copyWith({
    String? themeMode,
    bool? amoled,
    String? colorScheme,
    bool? useMaterial3,
    bool? useSubThemes,
    double? surfaceModeLight,
    double? surfaceModeDark,
    bool? useKeyColors,
    bool? useAppbarColors,
    bool? swapLightColors,
    bool? swapDarkColors,
    bool? useTertiary,
    int? blendLevel,
    double? appBarOpacity,
    bool? transparentStatusBar,
    double? tabBarOpacity,
    double? bottomBarOpacity,
    bool? tooltipsMatchBackground,
    double? defaultRadius,
    bool? useTextTheme,
    String? tabBarStyle,
  }) {
    return ThemeSettings(
      themeMode: themeMode ?? this.themeMode,
      amoled: amoled ?? this.amoled,
      colorScheme: colorScheme ?? this.colorScheme,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      useSubThemes: useSubThemes ?? this.useSubThemes,
      surfaceModeLight: surfaceModeLight ?? this.surfaceModeLight,
      surfaceModeDark: surfaceModeDark ?? this.surfaceModeDark,
      useKeyColors: useKeyColors ?? this.useKeyColors,
      useAppbarColors: useAppbarColors ?? this.useAppbarColors,
      swapLightColors: swapLightColors ?? this.swapLightColors,
      swapDarkColors: swapDarkColors ?? this.swapDarkColors,
      useTertiary: useTertiary ?? this.useTertiary,
      blendLevel: blendLevel ?? this.blendLevel,
      appBarOpacity: appBarOpacity ?? this.appBarOpacity,
      transparentStatusBar: transparentStatusBar ?? this.transparentStatusBar,
      tabBarOpacity: tabBarOpacity ?? this.tabBarOpacity,
      bottomBarOpacity: bottomBarOpacity ?? this.bottomBarOpacity,
      tooltipsMatchBackground: tooltipsMatchBackground ?? this.tooltipsMatchBackground,
      defaultRadius: defaultRadius ?? this.defaultRadius,
      useTextTheme: useTextTheme ?? this.useTextTheme,
      tabBarStyle: tabBarStyle ?? this.tabBarStyle,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode,
      'amoled': amoled,
      'colorScheme': colorScheme,
      'useMaterial3': useMaterial3,
      'useSubThemes': useSubThemes,
      'surfaceModeLight': surfaceModeLight,
      'surfaceModeDark': surfaceModeDark,
      'useKeyColors': useKeyColors,
      'useAppbarColors': useAppbarColors,
      'swapLightColors': swapLightColors,
      'swapDarkColors': swapDarkColors,
      'useTertiary': useTertiary,
      'blendLevel': blendLevel,
      'appBarOpacity': appBarOpacity,
      'transparentStatusBar': transparentStatusBar,
      'tabBarOpacity': tabBarOpacity,
      'bottomBarOpacity': bottomBarOpacity,
      'tooltipsMatchBackground': tooltipsMatchBackground,
      'defaultRadius': defaultRadius,
      'useTextTheme': useTextTheme,
      'tabBarStyle': tabBarStyle,
    };
  }

  factory ThemeSettings.fromMap(Map<String, dynamic> map) {
    return ThemeSettings(
      themeMode: map['themeMode'],
      amoled: map['amoled'],
      colorScheme: map['colorScheme'],
      useMaterial3: map['useMaterial3'],
      useSubThemes: map['useSubThemes'],
      surfaceModeLight: map['surfaceModeLight'],
      surfaceModeDark: map['surfaceModeDark'],
      useKeyColors: map['useKeyColors'],
      useAppbarColors: map['useAppbarColors'],
      swapLightColors: map['swapLightColors'],
      swapDarkColors: map['swapDarkColors'],
      useTertiary: map['useTertiary'],
      blendLevel: map['blendLevel'],
      appBarOpacity: map['appBarOpacity'],
      transparentStatusBar: map['transparentStatusBar'],
      tabBarOpacity: map['tabBarOpacity'],
      bottomBarOpacity: map['bottomBarOpacity'],
      tooltipsMatchBackground: map['tooltipsMatchBackground'],
      defaultRadius: map['defaultRadius'],
      useTextTheme: map['useTextTheme'],
      tabBarStyle: map['tabBarStyle'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeSettings.fromJson(String source) =>
      ThemeSettings.fromMap(json.decode(source));

  @enumerated
  FlexScheme get flexSchemeEnum => FlexScheme.values.firstWhere(
        (e) => e.name == colorScheme,
        orElse: () => FlexScheme.red,
      );
      
  @enumerated
  FlexTabBarStyle get flexTabBarStyleEnum => FlexTabBarStyle.values.firstWhere(
        (e) => e.name == tabBarStyle,
        orElse: () => FlexTabBarStyle.forBackground,
      );
}
