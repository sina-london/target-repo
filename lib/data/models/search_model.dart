import 'package:flutter/material.dart';

class SearchResponseModel {
  final int currentPage;
  final bool hasNextPage;
  final int totalPages;
  final List<AnimeResult> results;

  SearchResponseModel({
    required this.currentPage,
    required this.hasNextPage,
    required this.totalPages,
    required this.results,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      currentPage: json['currentPage'] as int,
      hasNextPage: json['hasNextPage'] as bool,
      totalPages: json['totalPages'],
      results: (json['results'] as List<dynamic>)
          .map((animeResult) => AnimeResult.fromJson(animeResult))
          .toList(),
    );
  }
}

class AnimeResult {
  final String id;
  final String title;
  final String url;
  final String image;
  final String duration;
  final String japaneseTitle;
  final String type;
  final bool nsfw;
  final int sub;
  final int dub;
  final int episodes;

  AnimeResult({
    required this.id,
    required this.title,
    required this.url,
    required this.image,
    required this.duration,
    required this.japaneseTitle,
    required this.type,
    required this.nsfw,
    required this.sub,
    required this.dub,
    required this.episodes,
  });

  factory AnimeResult.fromJson(Map<String, dynamic> json) {
    return AnimeResult(
      id: json['id'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      image: json['image'] as String,
      duration: json['duration'] as String,
      japaneseTitle: json['japaneseTitle'] as String,
      type: json['type'] as String,
      nsfw: json['nsfw'] as bool,
      sub: json['sub'] as int,
      dub: json['dub'] as int,
      episodes: json['episodes'] as int,
    );
  }
}
