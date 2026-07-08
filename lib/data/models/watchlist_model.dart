import 'package:hive/hive.dart';

part 'watchlist_model.g.dart';

@HiveType(typeId: 0)
class WatchlistModel extends HiveObject {
  @HiveField(0)
  List<AnimeItem> recentlyWatched;

  @HiveField(1)
  List<AnimeItem> continueWatching;

  @HiveField(2)
  List<AnimeItem> favorites;

  WatchlistModel({
    required this.recentlyWatched,
    required this.continueWatching,
    required this.favorites,
  });
}

@HiveType(typeId: 1)
class AnimeItem extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final int episode;

  AnimeItem({
    required this.name,
    required this.imageUrl,
    required this.episode,
  });
}
