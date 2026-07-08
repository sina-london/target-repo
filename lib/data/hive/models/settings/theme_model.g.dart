// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeSettingsAdapter extends TypeAdapter<ThemeSettings> {
  @override
  final int typeId = 2;

  @override
  ThemeSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeSettings(
      themeMode: fields[0] as String,
      amoled: fields[1] as bool,
      colorScheme: fields[2] as String,
      useMaterial3: fields[3] as bool,
      useSubThemes: fields[4] as bool,
      surfaceModeLight: fields[5] as double,
      surfaceModeDark: fields[6] as double,
      useKeyColors: fields[7] as bool,
      useAppbarColors: fields[8] as bool,
      swapLightColors: fields[9] as bool,
      swapDarkColors: fields[10] as bool,
      useTertiary: fields[11] as bool,
      blendLevel: fields[12] as int,
      appBarOpacity: fields[13] as double,
      transparentStatusBar: fields[14] as bool,
      tabBarOpacity: fields[15] as double,
      bottomBarOpacity: fields[16] as double,
      tooltipsMatchBackground: fields[17] as bool,
      defaultRadius: fields[18] as double,
      useTextTheme: fields[19] as bool,
      tabBarStyle: fields[20] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeSettings obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.themeMode)
      ..writeByte(1)
      ..write(obj.amoled)
      ..writeByte(2)
      ..write(obj.colorScheme)
      ..writeByte(3)
      ..write(obj.useMaterial3)
      ..writeByte(4)
      ..write(obj.useSubThemes)
      ..writeByte(5)
      ..write(obj.surfaceModeLight)
      ..writeByte(6)
      ..write(obj.surfaceModeDark)
      ..writeByte(7)
      ..write(obj.useKeyColors)
      ..writeByte(8)
      ..write(obj.useAppbarColors)
      ..writeByte(9)
      ..write(obj.swapLightColors)
      ..writeByte(10)
      ..write(obj.swapDarkColors)
      ..writeByte(11)
      ..write(obj.useTertiary)
      ..writeByte(12)
      ..write(obj.blendLevel)
      ..writeByte(13)
      ..write(obj.appBarOpacity)
      ..writeByte(14)
      ..write(obj.transparentStatusBar)
      ..writeByte(15)
      ..write(obj.tabBarOpacity)
      ..writeByte(16)
      ..write(obj.bottomBarOpacity)
      ..writeByte(17)
      ..write(obj.tooltipsMatchBackground)
      ..writeByte(18)
      ..write(obj.defaultRadius)
      ..writeByte(19)
      ..write(obj.useTextTheme)
      ..writeByte(20)
      ..write(obj.tabBarStyle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
