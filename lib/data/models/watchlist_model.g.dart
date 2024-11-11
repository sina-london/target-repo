// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistModelAdapter extends TypeAdapter<WatchlistModel> {
  @override
  final int typeId = 0;

  @override
  WatchlistModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistModel(
      recentlyWatched: (fields[0] as List).cast<AnimeItem>(),
      continueWatching: (fields[1] as List).cast<AnimeItem>(),
      favorites: (fields[2] as List).cast<AnimeItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.recentlyWatched)
      ..writeByte(1)
      ..write(obj.continueWatching)
      ..writeByte(2)
      ..write(obj.favorites);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AnimeItemAdapter extends TypeAdapter<AnimeItem> {
  @override
  final int typeId = 1;

  @override
  AnimeItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnimeItem(
      name: fields[0] as String,
      imageUrl: fields[1] as String,
      episode: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AnimeItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.imageUrl)
      ..writeByte(2)
      ..write(obj.episode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimeItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
