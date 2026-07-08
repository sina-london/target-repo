import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:shonenx/core/models/anime/episode_model.dart';
import 'package:shonenx/core/models/anime/page_model.dart';
import 'package:shonenx/core/models/anime/server_model.dart';
import 'package:shonenx/core/models/anime/source_model.dart';
import 'package:shonenx/core/sources/anime/aniwatch/parser.dart';
import 'package:shonenx/core/sources/anime/anime_provider.dart';
import 'package:html/parser.dart' show parse;
import 'package:shonenx/core/utils/app_logger.dart';

class HiAnimeProvider extends AnimeProvider {
  HiAnimeProvider({String? customApiUrl})
      : super(
            apiUrl: customApiUrl != null
                ? '$customApiUrl/anime/zoro'
                : "${dotenv.env['API_URL']}/anime/zoro",
            baseUrl: 'https://hianimez.to',
            providerName: 'hianime');

  Map<String, String> _getHeaders() {
    return {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/133.0.0.0 Safari/537.36',
    };
  }

  @override
  Future<HomePage> getHome() async {
    AppLogger.d('Fetching home page from $baseUrl');
    return HomePage();
    // final response =
    //     await http.get(Uri.parse('$baseUrl/home'), headers: _getHeaders());
    // AppLogger.d('Received home page response');
    // final document = parse(response.body);
    // return HomePage(
    //   spotlight: parseSpotlight(document, baseUrl),
    //   trending: parseTrending(document, baseUrl),
    //   featured: parseFeatured(document, baseUrl),
    // );
  }

  @override
  Future<DetailPage> getDetails(String animeId) async {
    AppLogger.d('Fetching details for animeId: $animeId');
    final response =
        await http.get(Uri.parse('$baseUrl/$animeId'), headers: _getHeaders());
    AppLogger.d('Received details response for animeId: $animeId');
    final document = parse(response.body);
    return parseDetail(document, baseUrl, animeId: animeId);
  }

  @override
  Future<WatchPage> getWatch(String animeId) async {
    AppLogger.d('Fetching watch page for animeId: $animeId');
    final response = await http.get(Uri.parse('$baseUrl/watch/$animeId'),
        headers: _getHeaders());
    AppLogger.d('Received watch page response for animeId: $animeId');
    final document = parse(response.body);
    return parseWatch(document, baseUrl, animeId: animeId);
  }

  @override
  Future<BaseEpisodeModel> getEpisodes(String animeId) async {
    AppLogger.d('Fetching episodes for animeId: $animeId');
    final response = await http.get(
        Uri.parse("$baseUrl/ajax/v2/episode/list/${animeId.split('-').last}"),
        headers: _getHeaders());
    AppLogger.d('Received episodes response for animeId: $animeId');
    final document = parse(json.decode(response.body)['html']);
    return parseEpisodes(document, "$baseUrl/ajax/v2/episode/list/",
        animeId: animeId);
  }

  @override
  Future<BaseServerModel> getServers(String episodeId) async {
    AppLogger.d('Fetching servers for episodeId: $episodeId');
    final response = await http.get(
        Uri.parse("$baseUrl/ajax/v2/episode/servers?episodeId=$episodeId"),
        headers: _getHeaders());
    AppLogger.d('Received servers response for episodeId: $episodeId');
    final document = parse(json.decode(response.body)['html']);
    return parseServers(
        document, "$baseUrl/ajax/v2/episode/servers?episodeId=$episodeId");
  }

  String? retrieveServerId(Document document, int index, String category) {
    final serverItems = document.querySelectorAll(
        '.ps_-block.ps_-block-sub.servers-$category > .ps__-list .server-item');
    return serverItems
        .firstWhere((el) => el.attributes['data-server-id'] == index.toString())
        .attributes['data-id'];
  }

  @override
  Future<BaseSourcesModel> getSources(String animeId, String episodeId,
      String? serverName, String? category) async {
    AppLogger.d('Fetching sources for animeId: $animeId, episodeId: $episodeId, server: $serverName, category: $category');
    // if (episodeId.startsWith('http')) {
    //   AppLogger.d('episodeId is a URL, processing accordingly');
    //   final serverUrl = episodeId;
    //   AppLogger.d('Processing MegaCloud for serverUrl: $serverUrl');
    //   final megaCloud = Megacloud();
    //   final extractedData = await megaCloud.extract(videoUrl: serverUrl);
    //   AppLogger.d('Extracted MegaCloud data for serverUrl: $serverUrl');
    //   return BaseSourcesModel();
    // }

    // final epId = Uri.parse('$baseUrl/watch/$episodeId').toString();
    // AppLogger.d('Constructed epId: $epId');

    // final episodeIdParam =
    //     Uri.encodeComponent(epId.split("?ep=").lastOrNull ?? '');
    // final serverUrl =
    //     Uri.parse('$baseUrl/ajax/v2/episode/servers?episodeId=$episodeIdParam');
    // AppLogger.d('Fetching episode servers from: $serverUrl');

    // final resp = await http.get(serverUrl);
    // if (resp.statusCode != 200) {
    //   AppLogger.e('Failed to fetch episode servers. Status code: ${resp.statusCode}');
    //   throw HttpException('Failed to fetch episode servers');
    // }

    // final jsonResponse = json.decode(resp.body);
    // final document = parse(jsonResponse['html']);
    // AppLogger.d('Parsed HTML document for episode servers');

    // String? serverId;
    // AppLogger.d('Attempting to retrieve server ID for $serverName');
    // serverId = retrieveServerId(document, 1, category);
    // if (serverId == null) {
    //   AppLogger.w('MegaCloud not found for serverName: $serverName');
    //   throw Exception('MegaCloud not found');
    // }
    // AppLogger.d('Retrieved serverId: $serverId');

    // final sourceUrl =
    //     Uri.parse('$baseUrl/ajax/v2/episode/sources?id=$serverId');
    // AppLogger.d('Fetching episode sources from: $sourceUrl');

    // final sourceResp = await http.get(sourceUrl);
    // if (sourceResp.statusCode != 200) {
    //   AppLogger.e('Failed to fetch episode sources. Status code: ${sourceResp.statusCode}');
    //   throw HttpException('Failed to fetch episode sources');
    // }

    // final sourceJson = json.decode(sourceResp.body);
    // final link = sourceJson['link'];
    // AppLogger.d('Retrieved source link: $link');
    // if (link != null) {
    //   return getSources(link, serverName, category);
    // }
    // return BaseSourcesModel();

    final response = await http.get(
      Uri.parse(
          'https://animaze-swart.vercel.app/anime/zoro/watch/$animeId\$episode\$$episodeId\$$category'),
    );
    AppLogger.d('Received sources response for episodeId: $episodeId, status code: ${response.statusCode}');
    return BaseSourcesModel.fromJson(json.decode(response.body));
  }

  @override
  Future<SearchPage> getSearch(String keyword, String? type, int page) async {
    final hianimeType =
        type != null ? _mapTypeToHianimeType(type.toLowerCase()) : null;
    final url = hianimeType != null
        ? '$baseUrl/search?keyword=$keyword&type=$hianimeType&page=$page'
        : '$baseUrl/search?keyword=$keyword&page=$page';
    AppLogger.d('Searching with URL: $url');
    final response = await http.get(Uri.parse(url), headers: _getHeaders());
    AppLogger.d('Received search response for keyword: $keyword');
    final document = parse(response.body);
    return parseSearch(document, baseUrl, keyword: keyword, page: page);
  }

  @override
  Future<SearchPage> getPage(String route, int page) async {
    AppLogger.d('Fetching page for route: $route, page: $page');
    final response = await http.get(Uri.parse('$baseUrl/$route?page=$page'),
        headers: _getHeaders());
    AppLogger.d('Received page response for route: $route');
    final document = parse(response.body);
    return parsePage(document, baseUrl, route: route, page: page);
  }

  int? _mapTypeToHianimeType(String type) {
    return switch (type) {
      'movie' => 1,
      'tv' => 2,
      'ova' => 3,
      'ona' => 4,
      'special' => 5,
      'music' => 6,
      _ => null
    };
  }

  @override
  List<String> getSupportedServers() {
    return ["vidcloud", "streamsb", "vidstreaming", "streamtape"];
  }

  @override
  bool getDubSubParamSupport() {
    return true;
  }
}