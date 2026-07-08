import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/main/stream_screen.dart';
import 'package:shimmer/shimmer.dart';

class EpisodesList extends StatefulWidget {
  final String id;
  final String title;
  final int rangeSize;

  const EpisodesList({
    Key? key,
    required this.id,
    required this.title,
    this.rangeSize = 50,
  }) : super(key: key);

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  List<Episode> _episodes = [];
  List<Map<String, List<Episode>>> _groupedEpisodes = [];
  late final AnimeService _animeService;
  int _selectedRangeIndex = 0;

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _fetchData();
  }

  // Fetch episode data and group by range
  Future<void> _fetchData() async {
    try {
      final result = await _animeService.fetchEpisodes(id: widget.id);
      if (mounted) {
        setState(() {
          _episodes = result;
          _groupedEpisodes = _groupEpisodesByRange(_episodes, widget.rangeSize);
        });
      }
    } catch (e) {
      if (mounted) setState(() {}); // For any error handling you plan to add later
    }
  }

  // Group Episodes by range
  List<Map<String, List<Episode>>> _groupEpisodesByRange(
      List<Episode> episodes, int rangeSize) {
    final result = <Map<String, List<Episode>>>[];
    for (var start = 1; start <= episodes.length; start += rangeSize) {
      final end = (start + rangeSize - 1).clamp(1, episodes.length);
      result.add({'$start - $end': episodes.sublist(start - 1, end)});
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        if (_groupedEpisodes.isEmpty)
          _buildShimmerList()
        else
          _buildEpisodeList(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Episodes",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<int>(
          value: _selectedRangeIndex,
          icon: const Icon(Icons.view_list),
          onChanged: (newIndex) {
            setState(() {
              _selectedRangeIndex = newIndex!;
            });
          },
          items: _groupedEpisodes.asMap().entries.map((entry) {
            final index = entry.key;
            final range = entry.value.keys.first;
            return DropdownMenuItem<int>(
              value: index,
              child: Text(range),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (_, __) => _buildShimmerPlaceholder(),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[800]!,
        highlightColor: Colors.white,
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

  Widget _buildEpisodeList() {
    final episodes = _groupedEpisodes[_selectedRangeIndex].values.first;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: episodes.length,
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return _buildEpisodeTile(context, episode);
      },
    );
  }

  Widget _buildEpisodeTile(BuildContext context, Episode episode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
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
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          "EP : ${episode.number}${episode.isFiller ? " : FILLER" : ""}",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          episode.title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_circle_fill),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StreamScreen(
                id: episode.episodeId,
                title: episode.title,
                episodes: _episodes,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
