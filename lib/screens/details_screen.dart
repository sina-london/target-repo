import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/episodes_list.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String id;
  final String image;
  final String duration;
  const DetailsScreen(
      {super.key,
      required this.title,
      required this.id,
      required this.image,
      required this.duration});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late ScrollController _scrollController;
  late AnimeService _animeService;
  ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  AnimeData? info;
  bool _isLoading = true;
  String? error;

  static const int _collapsedLines = 3;

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      AnimeInfo? result = await _animeService.fetchAnimeInfoById(id: widget.id);
      print(result);
      setState(() {
        info = result?.data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Network error occurred';
        _isLoading = false;
      });
    }
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 70.0),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  const Color.fromARGB(255, 44, 41, 41),
                  Colors.black.withOpacity(0.2),
                  const Color.fromARGB(0, 178, 30, 30)
                ],
              ).createShader(rect);
            },
            blendMode: BlendMode.srcATop,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (info != null) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      runSpacing: 6,
                      spacing: 6,
                      children: [
                        _buildInfoChip(
                          (info?.anime?.info?.stats?.episodesSub?.toString() ??
                                  'N/A')
                              .toUpperCase(),
                        ),
                      ],
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (info?.anime?.moreInfo?.duration != null)
                        _buildQuickInfoItem(
                          Icons.timelapse,
                          'Duration',
                          info!.anime!.moreInfo!.duration!,
                        ),
                      if (info?.anime?.moreInfo?.japanese != null)
                        _buildQuickInfoItem(
                          Icons.translate,
                          'Other Name',
                          info!.anime!.moreInfo!.japanese!,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: label == 'DUB'
            ? Colors.purple.withOpacity(0.5)
            : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    if (info == null) return const Text("No details available.");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Details'),
        const SizedBox(height: 8),
        ValueListenableBuilder(
          valueListenable: _isDescriptionExpanded,
          builder: (context, isExpanded, child) {
            return AnimatedCrossFade(
              crossFadeState: _isDescriptionExpanded.value
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: const TextStyle(fontSize: 16, height: 1.4),
                maxLines: _collapsedLines,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            );
          },
        ),
        TextButton(
          onPressed: () {
            _isDescriptionExpanded.value = !_isDescriptionExpanded.value;
          },
          child: ValueListenableBuilder<bool>(
            valueListenable: _isDescriptionExpanded,
            builder: (context, isExpanded, child) {
              return Text(isExpanded ? 'Show Less' : 'Show More');
            },
          ),
        ),
        const SizedBox(height: 10),
        EpisodesList(id: widget.id, title: widget.title)
      ],
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animeService = AnimeService();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: fetchData,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(error!),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverAppBar(
                        expandedHeight: screenHeight * 0.6,
                        stretch: true,
                        floating: false,
                        pinned: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: _buildHeaderSection(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorDark,
                          ),
                          child: _buildDetailsSection(),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
