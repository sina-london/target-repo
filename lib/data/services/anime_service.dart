// This file is located at: lib/data/services/anime_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/models/home_model.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/data/models/watch_model.dart';

class AnimeService {
  static const String baseUrl =
      "https://aniwatch-api-instance.vercel.app/api/v2/hianime";
  final http.Client _client = http.Client();

  /// Cancels all pending requests.
  void dispose() {
    _client.close();
  }

  Future<HomeModel> fetchHome() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/home"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return HomeModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load top airing anime');
      }
    } catch (e) {
      print("Error from service : $e");
      throw Exception('Failed to load home');
    }
  }

  Future<SearchModel?> fetchTopAiring() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/top-airing"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SearchModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load top airing anime');
      }
    } catch (e) {
      return null;
    }
  }

  Future<SearchModel?> fetchPopular() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/most-popular"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SearchModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load popular anime');
      }
    } catch (e) {
      return null;
    }
  }

  Future<SearchModel?> fetchCompleted() async {
    try {
      final response =
          await _client.get(Uri.parse("$baseUrl/latest-completed"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SearchModel.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      return null;
    }
  }

  Future<AnimeInfo?> fetchAnimeInfoById({required String id}) async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/anime/$id"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return AnimeInfo.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      return null;
    }
  }

  Future<SearchModel> fetchByQuery(
      {required String query, int page = 1}) async {
    try {
      final response =
          await _client.get(Uri.parse("$baseUrl/search?q=$query&page=$page"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return SearchModel?.fromJson(jsonResponse['data']);
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<Episode>> fetchEpisodes(
      {required  String id}) async {
    try {
      final response =
          await _client.get(Uri.parse("$baseUrl/anime/$id/episodes"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return (jsonResponse['data']['episodes'] as List<dynamic>).map((episodeJson) => Episode.fromJson(episodeJson)).toList();
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
  

  Future<WatchResponseModel> fetchWatchById({required String id}) async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/watch/$id"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return WatchResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
