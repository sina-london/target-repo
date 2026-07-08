class AnimeDetails {
  final List<String> genres;
  final String releaseDate;
  final String description;
  final List<Episode> episodes;

  AnimeDetails({
    required this.genres,
    required this.releaseDate,
    required this.description,
    required this.episodes,
  });

  factory AnimeDetails.fromJson(Map<String, dynamic> json) {
    return AnimeDetails(
      genres: List<String>.from(json['genres']),
      releaseDate: json['releaseDate'] as String,
      description: json['description'] as String,
      episodes: (json['episodes'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
    );
  }
}

class Episode {
  final String id;
  final String number;
  Episode({required this.id, required this.number});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      number: json['number'].toString(),
    );
  }
}
