// This file is located at: lib/data/services/anime_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nekoflow/data/models/search_result.dart';

class AnimeService {
  static const String baseUrl =
      "https://animaze-swart.vercel.app/anime/gogoanime";

  Future<List<dynamic>?> fetchTopAiring() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/top-airing"));
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
      final response = await http.get(Uri.parse("$baseUrl/popular"));
      if (response.statusCode == 200) {
        return json.decode(response.body)['results'];
      } else {
        throw Exception('Failed to load popular anime');
      }
    } catch (e) {
      return null;
    }
  }

  Future<ResultResponse?> fetchByQuery({required String query}) async {
    print("fetchByQuery() : Success");
    try {
      final response = await http.get(Uri.parse("$baseUrl/$query"));
      print("response : ${response.body}"); // Print the response body
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("jsonResponse : $jsonResponse"); // Print the parsed JSON
        if (jsonResponse['results'] != null) {
          return ResultResponse.fromJson(jsonResponse);
        }
        return null;
      } else {
        print("Failed with status code: ${response.statusCode}");
        throw Exception('Failed to load popular anime');
      }
    } catch (e) {
      print("Error: $e"); // More detailed error logging
      return null;
    }
  }
}
