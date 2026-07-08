import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/episodes_model.dart';
import 'package:nekoflow/data/models/stream_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:better_player/better_player.dart';

class StreamScreen extends StatefulWidget {
  final String title;
  final String id;
  final List<Episode> episodes;
  const StreamScreen({
    super.key,
    required this.title,
    required this.id,
    required this.episodes,
  });

  @override
  State<StreamScreen> createState() => _StreamScreenState();
}

class _StreamScreenState extends State<StreamScreen> {
  late AnimeService _animeService;
  BetterPlayerController? _playerController;
  String _selectedServer = "hd-1";
  String _selectedDubSub = "sub";
  String _selectedEpisodeId = "";
  EpisodeServersModel? _episodeServers;
  EpisodeStreamingLinksModel? _streamingLinks;

  Future<void> _fetchData() async {
    // Fetch anime data from the service
    _episodeServers =
        await _animeService.fetchEpisodeServers(animeEpisodeId: widget.id);
    await _fetchStreamingLinks(widget.id);
  }

 Future<void> initializePlayer() async {
  // Dispose of any existing controller before creating a new one
  _playerController?.dispose();
  _playerController = null;

  // Initialize only if there are streaming links available
  if (_streamingLinks != null && _streamingLinks!.sources.isNotEmpty) {
    final sourceUrl = _streamingLinks!.sources[0].url;
    List<BetterPlayerSubtitlesSource> subtitleSources =
        _streamingLinks!.tracks!
            .map(
              (track) => BetterPlayerSubtitlesSource(
                  type: BetterPlayerSubtitlesSourceType.network,
                  urls: [track.file],
                  name: track.kind),
            )
            .toList();

    _playerController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: true,
        autoDetectFullscreenAspectRatio: true,  // Automatically sets correct aspect ratio
        fit: BoxFit.contain, // Ensures video fits without stretching
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playIcon: Icons.play_arrow,
          pauseIcon: Icons.pause,
          controlBarColor: Colors.black54,
          enableProgressText: true,
          enableAudioTracks: false,
        ),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        sourceUrl,
        subtitles: subtitleSources,
      ),
    );
    setState(() {}); // Update UI after setting the player
  }
}
  Future<void> _fetchEpisodeServers(String episodeId) async {
    try {
      _episodeServers =
          await _animeService.fetchEpisodeServers(animeEpisodeId: episodeId);
      setState(() {});
    } catch (e) {
      print("Error fetching episode servers: $e");
    }
  }

  Future<void> _fetchStreamingLinks(String episodeId) async {
    if (episodeId.isEmpty) episodeId = widget.id;
    try {
      _streamingLinks = await _animeService.fetchEpisodeStreamingLinks(
        animeEpisodeId: episodeId,
        server: _selectedServer,
        category: _selectedDubSub,
      );
      setState(() {}); // Update UI after fetching links
      initializePlayer(); // Re-initialize the player with new links
    } catch (e) {
      print("Error fetching streaming links: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _animeService = AnimeService();
    _fetchData().then((_) => initializePlayer());
  }

  @override
  void dispose() {
    _animeService.dispose();
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.grey[900], // Darker grey for app bar
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Player area
            Container(
              color: Colors.black,
              height: 230,
              width: double.infinity,
              child: _playerController != null
                  ? BetterPlayer(controller: _playerController!)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            SizedBox(height: 20),

            // Subtitle / Dub selection buttons
            Row(
              children: [
                _buildChoiceButton(
                    "Sub", Colors.grey[700]!, _selectedDubSub == "sub", () {
                  setState(() {
                    _selectedDubSub = "sub";
                    _fetchStreamingLinks(_selectedEpisodeId);
                  });
                }),
                SizedBox(width: 15),
                _buildChoiceButton(
                    "Dub", Colors.grey[700]!, _selectedDubSub == "dub", () {
                  setState(() {
                    _selectedDubSub = "dub";
                    _fetchStreamingLinks(_selectedEpisodeId);
                  });
                }),
              ],
            ),
            SizedBox(height: 20),

            // "Servers" header
            Text(
              "Servers",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 10),

            // Server selection list
            SizedBox(
              height: 50,
              child: _episodeServers != null
                  ? ListView.builder(
                      itemCount: _selectedDubSub != "sub"
                          ? _episodeServers!.dub.length
                          : _episodeServers!.sub.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final serverLabel = _selectedDubSub != "sub"
                            ? _episodeServers!.dub[index].serverName
                            : _episodeServers!.sub[index].serverName;
                        return _buildServerCard(
                            serverLabel, serverLabel == _selectedServer, () {
                          setState(() {
                            _selectedServer = serverLabel;
                            _fetchStreamingLinks(_selectedEpisodeId);
                          });
                        });
                      },
                    )
                  : SizedBox.shrink(),
            ),
            SizedBox(height: 20),

            // Episode list
            Expanded(
              child: ListView.builder(
                itemCount:
                    widget.episodes.length, // Replace with actual episode count
                itemBuilder: (context, index) {
                  final episodeTitle = widget.episodes[index].title;
                  final episodeId = _selectedEpisodeId;
                  return _buildEpisodeCard(
                      episodeTitle, widget.episodes[index].number, episodeId);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a choice button (SUB/DUB)
  Widget _buildChoiceButton(
      String label, Color color, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purple : color.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
            ],
          ),
          child: Center(
            child: Text(
              label,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build the server cards
  Widget _buildServerCard(String label, bool isSelected, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(right: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isSelected
            ? Colors.purple
            : Colors.grey[600], // Darker grey for selected server
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  // Helper method to build the episode cards
  Widget _buildEpisodeCard(
      String episodeTitle, int episodeNumber, String episodeId) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedEpisodeId = episodeId;
            _fetchEpisodeServers(episodeId);
          });
        },
        child: Row(
          children: [
            Icon(Icons.play_arrow, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                episodeTitle,
                style: TextStyle(color: Colors.white, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              "#$episodeNumber",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
