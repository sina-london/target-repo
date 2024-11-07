class WatchResponseModel {
  final List<Source> sources;
  final List<Subtitle> subtitles;
  final IntroOutro intro;
  final IntroOutro outro;

  WatchResponseModel(
      {required this.sources,
      required this.subtitles,
      required this.intro,
      required this.outro});

  factory WatchResponseModel.fromJson(Map<String, dynamic> json) {
    return WatchResponseModel(
      sources: (json['sources'] as List<dynamic>)
          .map((sourceJson) => Source.fromJson(sourceJson))
          .toList(),
      subtitles: (json['subtitles'] as List<dynamic>)
          .map((subtitleJson) => Subtitle.fromJson(subtitleJson))
          .toList(),
      intro: IntroOutro.fromJson(json['intro']),
      outro: IntroOutro.fromJson(json['outro']),
    );
  }
}

class IntroOutro {
  final int? start;
  final int? end;

  IntroOutro({required this.start, required this.end});

  factory IntroOutro.fromJson(Map<String, dynamic> json) {
    return IntroOutro(start: json['start'], end: json['end']);
  }
}

class Subtitle {
  final String url;
  final String lang;

  Subtitle({required this.url, required this.lang});

  factory Subtitle.fromJson(Map<String, dynamic> json) {
    return Subtitle(url: json['url'], lang: json['lang']);
  }
}

class Source {
  final String url;
  final String type;
  final bool isM3U8;

  Source({required this.url, required this.type, required this.isM3U8});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(url: json['url'], type: json['type'], isM3U8: json['isM3U8']);
  }
}
