import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/stream_screen.dart';
import 'package:shimmer/shimmer.dart';

class EpisodesList extends StatefulWidget {
  final String id;
  final String title;
  final int rangeSize;

  const EpisodesList(
      {super.key, required this.id, required this.title, this.rangeSize = 50});

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  List<Episode> _episodes = [];
  List<Map<String, List<Episode>>> _groupedEpisodes = [];
  late AnimeService _animeService;
  int? _selectedRangeIndex;

  // Group Episodes by range
  List<Map<String, List<Episode>>> _groupEpisodesByRange(
      List<Episode> episodes, int rangeSize) {
    List<Map<String, List<Episode>>> result = [];
    int totalEpisodes = episodes.length;
    int start = 1;

    while (start <= totalEpisodes) {
      int end = (start + rangeSize - 1) > totalEpisodes
          ? totalEpisodes
          : (start + rangeSize - 1);
      result.add({
        '$start - $end': episodes.sublist(start - 1, end),
      });
      start += rangeSize;
    }

    return result;
  }

  Future<void> fetchData() async {
    try {
      List<Episode> result = await _animeService.fetchEpisodes(id: widget.id);
      setState(() {
        _episodes = result;
        _groupedEpisodes = _groupEpisodesByRange(_episodes, widget.rangeSize);
      });
    } catch (e) {
      // Handle Error later
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _selectedRangeIndex = 0;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Episodes",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<int>(
              menuMaxHeight: MediaQuery.of(context).size.height * 0.6,
              value: _selectedRangeIndex,
              icon: const Icon(
                Icons.view_list,
              ),
              onChanged: (int? newIndex) {
                setState(() {
                  _selectedRangeIndex = newIndex;
                });
              },
              selectedItemBuilder: (BuildContext context) {
                return _groupedEpisodes.map((group) {
                  String range = group.keys.first;
                  return Center(
                    child: Text(range),
                  );
                }).toList();
              },
              items: _groupedEpisodes.asMap().entries.map((entry) {
                int index = entry.key;
                String range = entry.value.keys.first;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(range),
                );
              }).toList(),
            ),
          ],
        ),
        if (_groupedEpisodes.isEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) => _buildShimmerPlaceholder(),
          ),
        if (_groupedEpisodes.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount:
                _groupedEpisodes[_selectedRangeIndex!].values.first.length,
            itemBuilder: (context, index) {
              Episode episode =
                  _groupedEpisodes[_selectedRangeIndex!].values.first[index];
              return Container(
                margin: EdgeInsets.only(bottom: 15.0),
                decoration: BoxDecoration(
                  color: episode.isFiller
                      ? Theme.of(context).splashColor
                      : Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  title: Text(
                    "EP : ${episode.number}${episode.isFiller ? " : FILLER" : ""}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    episode.title,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StreamScreen(
                          id: episode.episodeId,
                          title: episode.title,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    // Define what happens when an episode is tapped
                  },
                ),
              );
            },
          )
      ],
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.white,
        direction: ShimmerDirection.ltr,
        period: const Duration(milliseconds: 1000),
        enabled: true,
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.grey[800]!,
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }
}
