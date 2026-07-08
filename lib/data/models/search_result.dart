class Anime {
  final String id;
  final String image;
  final String subOrDub;
  final String title;
  final String releaseDate;

  Anime({
    required this.id,
    required this.image,
    required this.subOrDub,
    required this.title,
    required this.releaseDate,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      image: json['image'],
      subOrDub: json['subOrDub'],
      title: json['title'],
      releaseDate: json['releaseDate'],
    );
  }
}

class ResultResponse {
  final List<Anime> results;
  final int currentPage;
  final bool hasNextPage;

  ResultResponse({
    required this.results,
    required this.currentPage,
    required this.hasNextPage,
  });

  factory ResultResponse.fromJson(Map<String, dynamic> json) {
    return ResultResponse(
      results: (json['results'] as List<dynamic>)
          .map((result) => Anime.fromJson(result as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'],
      hasNextPage: json['hasNextPage'],
    );
  }
}
