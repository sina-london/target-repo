import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/screens/main/stream/stream_screen.dart';
import 'package:shimmer/shimmer.dart';

class EpisodesList extends StatefulWidget {
  final String id;
  final String name;
  final String poster;
  final int rangeSize;
  final String type;

  const EpisodesList({
    super.key,
    required this.id,
    required this.poster,
    required this.name,
    required this.type,
    this.rangeSize = 50,
  });

  @override
  State<EpisodesList> createState() => _EpisodesListState();
}

class _EpisodesListState extends State<EpisodesList> {
  final ValueNotifier<List<Episode>> _episodes =
      ValueNotifier<List<Episode>>([]);
  final ValueNotifier<List<Map<String, List<Episode>>>> _groupedEpisodes =
      ValueNotifier<List<Map<String, List<Episode>>>>([]);
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<int> _selectedRangeIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _isGridLayout =
      ValueNotifier<bool>(false); // Layout toggle

  // late final Box<WatchlistModel> _watchlistBox;
  late final AnimeService _animeService;

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final result = await _animeService.fetchEpisodes(id: widget.id);
      if (!mounted) return;
      _episodes.value = result;
      _groupedEpisodes.value = _groupEpisodesByRange(result, widget.rangeSize);
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        _isLoading.value = false;
      }
    }
  }

  List<Map<String, List<Episode>>> _groupEpisodesByRange(
      List<Episode> episodes, int rangeSize) {
    return List.generate(
      (episodes.length / rangeSize).ceil(),
      (index) {
        final start = index * rangeSize + 1;
        final end = (start + rangeSize - 1).clamp(1, episodes.length);
        return {
          '$start - $end': episodes.sublist(
            index * rangeSize,
            (index + 1) * rangeSize > episodes.length
                ? episodes.length
                : (index + 1) * rangeSize,
          )
        };
      },
    );
  }

  void _navigateToStreamScreen(Episode episode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StreamScreen(
          id: widget.id,
          name: widget.name,
          episodeId: episode.episodeId,
          poster: widget.poster,
          episode: episode.number,
          title: episode.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        ValueListenableBuilder<bool>(
          valueListenable: _isLoading,
          builder: (context, isLoading, _) {
            return isLoading ? _buildShimmerList() : _buildEpisodesView();
          },
        ),
        SizedBox(height: 25,)
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Episodes",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Row(
          children: [
            IconButton(
              icon: ValueListenableBuilder<bool>(
                valueListenable: _isGridLayout,
                builder: (context, isGrid, _) {
                  return Icon(
                    isGrid ? Icons.view_list : Icons.grid_view,
                  );
                },
              ),
              onPressed: () => _isGridLayout.value = !_isGridLayout.value,
            ),
            ValueListenableBuilder<List<Map<String, List<Episode>>>>(
              valueListenable: _groupedEpisodes,
              builder: (context, groupedEpisodes, _) {
                if (groupedEpisodes.isEmpty) return const SizedBox.shrink();

                return ValueListenableBuilder<int>(
                  valueListenable: _selectedRangeIndex,
                  builder: (context, selectedIndex, _) {
                    return DropdownButton<int>(
                      value: selectedIndex,
                      icon: Icon(
                        Icons.view_list,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      onChanged: (newIndex) {
                        if (newIndex != null) {
                          _selectedRangeIndex.value = newIndex;
                        }
                      },
                      items: groupedEpisodes.asMap().entries.map((entry) {
                        return DropdownMenuItem<int>(
                          value: entry.key,
                          child: Text(
                            entry.value.keys.first,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      highlightColor: Theme.of(context).colorScheme.secondary,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: Container(
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.grey[800]!,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodesView() {
    return ValueListenableBuilder<bool>(
      valueListenable: _isGridLayout,
      builder: (context, isGrid, _) {
        return isGrid ? _buildGridEpisodes() : _buildListEpisodes();
      },
    );
  }

  Widget _buildListEpisodes() {
    return ValueListenableBuilder<List<Map<String, List<Episode>>>>(
      valueListenable: _groupedEpisodes,
      builder: (context, groupedEpisodes, _) {
        if (groupedEpisodes.isEmpty) {
          return const Center(child: Text('No episodes available'));
        }

        return ValueListenableBuilder<int>(
          valueListenable: _selectedRangeIndex,
          builder: (context, selectedIndex, _) {
            final episodes = groupedEpisodes[selectedIndex].values.first;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: episodes.length,
              itemBuilder: (context, index) =>
                  _buildEpisodeTile(episodes[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildGridEpisodes() {
    return ValueListenableBuilder<List<Map<String, List<Episode>>>>(
      valueListenable: _groupedEpisodes,
      builder: (context, groupedEpisodes, _) {
        if (groupedEpisodes.isEmpty) {
          return const Center(child: Text('No episodes available'));
        }

        return ValueListenableBuilder<int>(
          valueListenable: _selectedRangeIndex,
          builder: (context, selectedIndex, _) {
            final episodes = groupedEpisodes[selectedIndex].values.first;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemCount: episodes.length,
              itemBuilder: (context, index) => _buildEpisodeGridTile(
                episodes[index],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEpisodeTile(Episode episode) {
    ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          colors: [
            !episode.isFiller
                ? themeData.colorScheme.primary.withOpacity(0.4)
                : themeData.colorScheme.tertiary, // Start color
            !episode.isFiller
                ? themeData.colorScheme.secondary.withOpacity(0.7)
                : themeData.colorScheme.tertiary, // End color
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          episode.title,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.play_circle_fill,
          ),
          onPressed: () => _navigateToStreamScreen(episode),
        ),
      ),
    );
  }

  Widget _buildEpisodeGridTile(Episode episode) {
    ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => _navigateToStreamScreen(episode),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          gradient: LinearGradient(
          colors: [
            !episode.isFiller
                ? themeData.colorScheme.primary.withOpacity(0.5)
                : themeData.colorScheme.tertiary, // Start color
            !episode.isFiller
                ? themeData.colorScheme.secondary.withOpacity(0.8)
                : themeData.colorScheme.tertiary, // End color
          ],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        ),
        child: Center(
          child: Text(
            "${episode.number}",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
