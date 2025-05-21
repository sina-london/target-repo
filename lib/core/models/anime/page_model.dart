import 'package:shonenx/core/models/anime/anime_model.dep.dart';

class Featured {
  final String? path;
  final String? title;
  final List<BaseAnimeModel>? animes;

  Featured({this.path, this.title, this.animes});
}

class DetailPage {
  final BaseAnimeModel? anime;

  DetailPage({this.anime});
}

class WatchPage {
  final int? totalEpisodes;
  final BaseAnimeModel? anime;

  WatchPage({this.totalEpisodes, this.anime});
}

class SearchPage {
  final int? totalPages;
  final int? currentPage;
  final List<BaseAnimeModel> results;

  SearchPage({
    this.totalPages = 0,
    this.currentPage = 0,
    this.results = const [],
  });
}
