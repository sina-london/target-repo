class EpisodesData {
  final bool success;
  final EpisodeInfo? data;

  EpisodesData({
    required this.success,
    this.data,
  });

  factory EpisodesData.fromJson(Map<String, dynamic> json) {
    return EpisodesData(
      success: json['success'] as bool,
      data: json['data'] != null ? EpisodeInfo.fromJson(json['data']) : null,
    );
  }
}

class EpisodeInfo {
  final int totalEpisodes;
  final List<Episode> episodes;

  EpisodeInfo({
    required this.totalEpisodes,
    required this.episodes,
  });

  factory EpisodeInfo.fromJson(Map<String, dynamic> json) {
    return EpisodeInfo(
      totalEpisodes: json['totalEpisodes'] as int,
      episodes: (json['episodes'] as List)
          .map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Episode {
  final String title;
  final String episodeId;
  final int number;
  final bool isFiller;

  Episode({
    required this.title,
    required this.episodeId,
    required this.number,
    required this.isFiller,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'] as String,
      episodeId: json['episodeId'] as String,
      number: json['number'] as int,
      isFiller: json['isFiller'] as bool,
    );
  }
}
