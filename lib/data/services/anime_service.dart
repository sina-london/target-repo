// This file is located at: lib/data/services/anime_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nekoflow/data/models/genres_model.dart';
import 'package:nekoflow/data/models/search_result.dart';
import 'package:nekoflow/data/models/watch_model.dart';

class AnimeService {
  static const String baseUrl =
      "https://animaze-swart.vercel.app/anime/gogoanime";
  final http.Client _client = http.Client();

  /// Cancels all pending requests.
  void dispose() {
    _client.close();
  }

  Future<List<dynamic>?> fetchTopAiring() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/top-airing"));
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load top airing anime');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>?> fetchPopular() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/popular"));
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load popular anime');
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<dynamic>?> fetchMovies() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/movies"));
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResultResponse> fetchByQuery(
      {required String query, required int page}) async {
    try {
      final response =
          await _client.get(Uri.parse("$baseUrl/$query?page=$page"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return ResultResponse?.fromJson(jsonResponse);
      } else {
        throw Exception(
            'Failed to load search results: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Genre>?> fetchGenres() async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/genre/list"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return (jsonResponse as List<dynamic>)
            .map((e) => Genre.fromJson(e))
            .toList();
      } else {
        throw Exception('Failed to load genres');
      }
    } catch (e) {
      return null;
    }
  }

  Future<WatchResponse?> fetchStream({required String id}) async {
    try {
      final response = await _client.get(Uri.parse("$baseUrl/watch/$id"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return WatchResponse.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load stream data');
      }
    } catch (e) {
      return null;
    }
  }
}
