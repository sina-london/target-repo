import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 0)
class SettingsModel extends HiveObject {
  @HiveField(0)
  String? defaultQuality;
  @HiveField(1)
  bool? isDarkTheme;
  @HiveField(2)
  String? defaultOrientation;
  @HiveField(3)
  String? layoutMode;
  @HiveField(4)
  bool? isLabelEnabled;

  SettingsModel({
    this.defaultQuality = '720p',
    this.isDarkTheme = false,
    this.defaultOrientation = 'Portrait',
    this.layoutMode = 'Grid',
    this.isLabelEnabled = true,
  });

  // Factory method to create a SettingsModel object from JSON
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      defaultQuality: json['defaultQuality'] as String,
      isDarkTheme: json['isDarkTheme'] as bool,
      defaultOrientation: json['defaultOrientation'] as String,
      layoutMode: json['layoutMode'] as String,
      isLabelEnabled: json['isLabelEnabled'] as bool,
    );
  }

  // Method to convert a SettingsModel object to JSON
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
