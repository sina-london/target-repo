class WatchResponse {
  final String download;
  final List<WatchSource> sources;

  WatchResponse({
    required this.download,
    required this.sources,
  });

  factory WatchResponse.fromJson(Map<String, dynamic> json) {
    return WatchResponse(
      download: json['download'],
      sources: (json['sources'] as List<dynamic>)
          .map((e) => WatchSource.fromJson(e))
          .toList(),
    );
  }
}

class WatchSource {
  final bool isM3U8;
  final String quality;
  final String url;

  WatchSource({
    required this.isM3U8,
    required this.quality,
    required this.url,
  });

  factory WatchSource.fromJson(Map<String, dynamic> json) {
    return WatchSource(
      isM3U8: json['isM3U8'] as bool,
      quality: json['quality'] as String,
      url: json['url'] as String,
    );
  }
}
