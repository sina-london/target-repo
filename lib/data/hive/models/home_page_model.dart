import 'package:hive_flutter/hive_flutter.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/core/models/anime/anime_model.dep.dart';
import 'package:shonenx/core/models/anime/page_model.dart';

part 'home_page_model.g.dart';

@HiveType(typeId: 7)
class HomePage {
  @HiveField(0)
  final List<Media> trendingAnime;
  @HiveField(1)
  final List<Media> popularAnime;
  @HiveField(2)
  final List<Media> recentlyUpdated;
  @HiveField(3)
  final List<Media> topRatedAnime;
  @HiveField(4)
  final List<Media> mostFavoriteAnime;
  @HiveField(5)
  final List<Media> mostWatchedAnime;
  @HiveField(6)
  final List<BaseAnimeModel> spotlight;
  @HiveField(7)
  final List<BaseAnimeModel> trending;
  @HiveField(8)
  final List<Featured> featured;

  HomePage({
    this.trendingAnime = const [],
    this.popularAnime = const [],
    this.recentlyUpdated = const [],
    this.topRatedAnime = const [],
    this.mostFavoriteAnime = const [],
    this.mostWatchedAnime = const [],
    this.spotlight = const [],
    this.trending = const [],
    this.featured = const [],
  });
}