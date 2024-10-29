import 'package:nekoflow/data/models/search_model.dart';

class AnimeInfoResponseModel {
  final String id;
  final String title;
  final int malID;
  final int alID;
  final String japaneseTitle;
  final String image;
  final String description;
  final String type;
  final String url;
  final List<AnimeResult> recommendations;
  final List<AnimeResult> relatedAnime;
  final String subOrDub;
  final bool hasSub;
  final bool hasDub;
  final int totalEpisodes;

  AnimeInfoResponseModel({
    required this.id,
    required this.title,
    required this.malID,
    required this.alID,
    required this.japaneseTitle,
    required this.image,
    required this.description,
    required this.type,
    required this.url,
    required this.recommendations,
    required this.relatedAnime,
    required this.subOrDub,
    required this.hasDub,
    required this.hasSub,
    required this.totalEpisodes,
  });

  factory AnimeInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return AnimeInfoResponseModel(
      id: json['id'],
      title: json['title'],
      malID: json['malID'],
      alID: json['alID'],
      japaneseTitle: json['japaneseTitle'],
      image: json['image'],
      description: json['description'],
      type: json['type'],
      url: json['url'],
      recommendations: json['recommendations'],
      relatedAnime: json['relatedAnime'],
      subOrDub: json['subOrDub'],
      hasDub: json['hasDub'],
      hasSub: json['hasSub'],
      totalEpisodes: json['totalEpisodes'],
    );
  }
}

class Episode {
  final String id;
  final int number;
  final String title;
  final bool isFiller;
  final String url;

  Episode(
      {required this.id,
      required this.number,
      required this.title,
      required this.isFiller,
      required this.url});

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
        id: json['id'],
        number: json['number'],
        title: json['title'],
        isFiller: json['isFiller'],
        url: json['url']);
  }
}
