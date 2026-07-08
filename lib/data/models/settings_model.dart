import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class Settings {
  @HiveField(0)
  final String defaultQuality;
  @HiveField(1)
  final bool isDarkTheme;
  @HiveField(2)
  final String defaultOrientation;
  @HiveField(3)
  final String layoutMode;
  @HiveField(4)
  final bool isLabelEnabled;
  @HiveField(5)
  Settings({
    required this.defaultQuality,
    required this.isDarkTheme,
    required this.defaultOrientation,
    required this.layoutMode,
    required this.isLabelEnabled,
  });

  // Factory method to create a Settings object from JSON
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      defaultQuality: json['defaultQuality'] as String,
      isDarkTheme: json['isDarkTheme'] as bool,
      defaultOrientation: json['defaultOrientation'] as String,
      layoutMode: json['layoutMode'] as String,
      isLabelEnabled: json['isLabelEnabled'] as bool,
    );
  }

  // Method to convert a Settings object to JSON
  Map<String, dynamic> toJson() {
    return {
      'defaultQuality': defaultQuality,
      'isDarkTheme': isDarkTheme,
      'defaultOrientation': defaultOrientation,
      'layoutMode': layoutMode,
      'isLabelEnabled': isLabelEnabled,
    };
  }
}
