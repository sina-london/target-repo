import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/details_model.dart';
import 'package:http/http.dart' as http;
import 'package:nekoflow/widgets/episodes_list.dart';

class Details extends StatefulWidget {
  final String id;
  final String image;
  final String title;

  const Details(
      {super.key, required this.id, required this.image, required this.title});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  ValueNotifier<bool> _isDescriptionExpanded = ValueNotifier(false);
  static const String baseUrl =
      "https://animaze-swart.vercel.app/anime/gogoanime/info";

  AnimeDetails? info;
  bool _isLoading = true;
  String? error;
  final ScrollController _scrollController = ScrollController();

  static const int _collapsedLines = 3;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      _isLoading = true;
      error = null;
    });

    try {
      final response = await http.get(Uri.parse("$baseUrl/${widget.id}"));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          info = AnimeDetails.fromJson(jsonData);
          _isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load anime details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error occurred';
        _isLoading = false;
      });
    }
  }

  Widget _buildHeaderSection() {
    return Stack(
      children: [
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black,
                Colors.black.withOpacity(0.2),
                Colors.transparent
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: Image.network(
            widget.image,
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 400,
              color: Colors.grey[300],
              child: Icon(Icons.error, size: 50, color: Colors.grey[600]),
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
                  const SizedBox(
                    height: 8,
                  ),
                  Wrap(
                    runSpacing: 6,
                    spacing: 6,
                    children: [
                      _buildInfoChip(info!.type),
                      _buildInfoChip(info!.status),
                      _buildInfoChip(info!.subOrDub.toUpperCase()),
                      ...(info!.genres.map((e) => _buildInfoChip(e)).toList())
                    ],
                  )
                ]
              ],
            ),
          ),
        )
      ],
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
    if (info == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickInfoItem(
              Icons.calendar_today,
              'Released',
              info!.releaseDate,
            ),
            _buildQuickInfoItem(
              Icons.list,
              'Episodes',
              info!.totalEpisodes.toString(),
            ),
            if (info!.otherName.isNotEmpty)
              _buildQuickInfoItem(
                Icons.translate,
                'Other Name',
                info!.otherName,
              ),
          ],
        ),
        const SizedBox(height: 24),

        _buildSectionTitle('Description'),
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
                  info!.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                  maxLines: _collapsedLines,
                  overflow: TextOverflow.ellipsis,
                ),
                secondChild: Text(
                  info!.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              );
            }),
        TextButton(
            onPressed: () {
              _isDescriptionExpanded.value = !_isDescriptionExpanded.value;
            },
            child: ValueListenableBuilder<bool>(
              valueListenable: _isDescriptionExpanded,
              builder: (context, isExpanded, child) {
                return Text(
                  isExpanded ? 'Show Less' : 'Show More',
                  style: const TextStyle(color: Colors.black),
                );
              },
            )),

        const SizedBox(
          height: 16,
        ),

        // Episodes
        EpisodesList(
          episodes: info!.episodes,
          title: widget.title,
        )
      ],
    );
  }

  Widget _buildQuickInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
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
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
                        expandedHeight: 300,
                        floating: true,
                        pinned: true,
                        flexibleSpace: FlexibleSpaceBar(
                          background: _buildHeaderSection(),
                        ),
                      ),
                      SliverToBoxAdapter(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: _buildDetailsSection(),
                      ))
                    ],
                  ),
      ),
    );
  }
}
