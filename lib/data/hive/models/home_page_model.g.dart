// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomePageAdapter extends TypeAdapter<HomePage> {
  @override
  final int typeId = 7;

  @override
  HomePage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomePage(
      trendingAnime: (fields[0] as List).cast<Media>(),
      popularAnime: (fields[1] as List).cast<Media>(),
      recentlyUpdated: (fields[2] as List).cast<Media>(),
      topRatedAnime: (fields[3] as List).cast<Media>(),
      mostFavoriteAnime: (fields[4] as List).cast<Media>(),
      mostWatchedAnime: (fields[5] as List).cast<Media>(),
      spotlight: (fields[6] as List).cast<BaseAnimeModel>(),
      trending: (fields[7] as List).cast<BaseAnimeModel>(),
      featured: (fields[8] as List).cast<Featured>(),
    );
  }

  @override
  void write(BinaryWriter writer, HomePage obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.trendingAnime)
      ..writeByte(1)
      ..write(obj.popularAnime)
      ..writeByte(2)
      ..write(obj.recentlyUpdated)
      ..writeByte(3)
      ..write(obj.topRatedAnime)
      ..writeByte(4)
      ..write(obj.mostFavoriteAnime)
      ..writeByte(5)
      ..write(obj.mostWatchedAnime)
      ..writeByte(6)
      ..write(obj.spotlight)
      ..writeByte(7)
      ..write(obj.trending)
      ..writeByte(8)
      ..write(obj.featured);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomePageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
