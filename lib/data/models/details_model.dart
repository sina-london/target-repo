class AnimeDetails {
  final String id;
  final String title;
  final String image;
  final String url;
  final List<String> genres;
  final String releaseDate;
  final String description;
  final List<Episode> episodes;
  final String otherName;
  final String status;
  final String subOrDub;
  final int totalEpisodes;
  final String type;

  AnimeDetails({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.genres,
    required this.releaseDate,
    required this.description,
    required this.episodes,
    required this.otherName,
    required this.status,
    required this.subOrDub,
    required this.totalEpisodes,
    required this.type,
  });

  factory AnimeDetails.fromJson(Map<String, dynamic> json) {
    return AnimeDetails(
      id: json['id'] as String,
      title: json['title'] as String,
      image: json['image'] as String,
      url: json['url'] as String,
      genres: List<String>.from(json['genres']),
      releaseDate: json['releaseDate'] as String,
      description: json['description'] as String,
      episodes: (json['episodes'] as List)
          .map((episode) => Episode.fromJson(episode))
          .toList(),
      otherName: json['otherName'] as String,
      status: json['status'] as String,
      subOrDub: json['subOrDub'] as String,
      totalEpisodes: json['totalEpisodes'] as int,
      type: json['type'] as String,
    );
  }
}

class Episode {
  final String id;
  final String number;
  final String url;

  Episode({
    required this.id,
    required this.number,
    required this.url,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'] as String,
      number: json['number'].toString(),
      url: json['url'] as String,
    );
  }

  // Optional: Add toJson method for serialization if needed
  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'url': url,
      };
}
