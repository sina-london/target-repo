import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nekoflow/data/models/info_model.dart';
import 'package:nekoflow/data/models/watchlist/watchlist_model.dart';
import 'package:nekoflow/data/services/anime_service.dart';
import 'package:nekoflow/widgets/episodes_list.dart';
import 'package:nekoflow/widgets/favorite_button.dart';
import 'package:shimmer/shimmer.dart';

class DetailsScreen extends StatefulWidget {
  final String title;
  final String id;
  final String image;
  final String type;
  final dynamic tag;

  const DetailsScreen({
    super.key,
    required this.title,
    required this.id,
    required this.image,
    required this.tag,
    this.type = 'N/A',
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  late final AnimeService _animeService = AnimeService();
  late final Box<WatchlistModel> _watchlistBox = Hive.box<WatchlistModel>('user_watchlist');
  final ScrollController _scrollController = ScrollController();
  AnimeData? info;
  String? error;

  Future<AnimeInfo?> fetchData() async {
    try {
      return await _animeService.fetchAnimeInfoById(id: widget.id);
    } catch (_) {
      setState(() => error = 'Network error occurred');
      return null;
    }
  }

  Widget _buildHeaderSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 85.0),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                const Color.fromARGB(255, 44, 41, 41),
                Colors.black.withOpacity(0.2),
                const Color.fromARGB(0, 178, 30, 30),
              ],
            ).createShader(rect),
            blendMode: BlendMode.srcATop,
            child: Hero(
              tag: 'poster-${widget.id}-${widget.tag}',
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 400,
                      color: Colors.grey[300],
                      child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  shadows: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      offset: Offset(1, 2),
                      blurRadius: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String label, String? value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 2),
          value == null
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[800]!,
                  highlightColor: Colors.grey[600]!,
                  child: Container(
                    width: 50,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                )
              : Text(
                  value.isEmpty ? 'N/A' : value,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }

  Widget _buildDetailsSection({bool isLoading = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildQuickInfoItem(Icons.timelapse, "Duration", isLoading ? null : info?.anime?.moreInfo?.duration),
            _buildQuickInfoItem(Icons.translate, "Japanese", isLoading ? null : info?.anime?.moreInfo?.japanese),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Details',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: _isDescriptionExpanded,
          builder: (_, isExpanded, __) {
            return AnimatedCrossFade(
              crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
              firstChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              secondChild: Text(
                info?.anime?.info?.description ?? 'Description not available',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          },
        ),
        TextButton(
          onPressed: () => _isDescriptionExpanded.value = !_isDescriptionExpanded.value,
          child: ValueListenableBuilder<bool>(
            valueListenable: _isDescriptionExpanded,
            builder: (_, isExpanded, __) => Text(isExpanded ? 'Show Less' : 'Show More'),
          ),
        ),
        const SizedBox(height: 10),
        EpisodesList(
          id: widget.id,
          title: widget.title,
          poster: widget.image,
          type: info?.anime?.info?.stats?.type ?? 'N/A',
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _isDescriptionExpanded.dispose();
    _animeService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      body: FutureBuilder<AnimeInfo?>(
        future: fetchData(),
        builder: (context, snapshot) {
          final bool isLoading = snapshot.connectionState == ConnectionState.waiting;
          info = snapshot.data?.data;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: screenHeight * 0.6,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.navigate_before, size: 40),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildHeaderSection(),
                ),
                actions: [
                  FavoriteButton(
                    animeId: widget.id,
                    title: widget.title,
                    image: widget.image,
                    type: widget.type,
                  ),
                  const SizedBox(width: 10)
                ],
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: _buildDetailsSection(isLoading: isLoading),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
