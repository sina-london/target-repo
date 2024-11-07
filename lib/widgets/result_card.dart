import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_model.dart';
import 'package:nekoflow/screens/details_screen.dart';

class ResultCard extends StatefulWidget {
  final AnimeResult anime;

  const ResultCard({super.key, required this.anime});

  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  Widget _buildTypeWidget(String type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNSFWWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'NSFW',
        style: TextStyle(
          fontSize: 12,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildSubtitlesWidget(int subCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.lightGreen.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.subtitles, size: 14, color: Colors.lightGreen),
          SizedBox(width: 4),
          Text(
            subCount.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.lightGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDubbingWidget(int dubCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.mic, size: 14, color: Colors.lightBlue),
          SizedBox(width: 4),
          Text(
            dubCount.toString(),
            style: TextStyle(
              fontSize: 12,
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEpisodeCountWidget(int episodeCount) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Icon(Icons.theaters, size: 14, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            '$episodeCount eps',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailsScreen(
            title: widget.anime.name,
            id: widget.anime.id,
            image: widget.anime.poster,
            duration: widget.anime.type,
          ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).hoverColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.anime.poster,
                    height: screenSize.width * 0.4,
                    width: screenSize.width * 0.25,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Center(child: CircularProgressIndicator(),),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.anime.name,
                        maxLines: 3,
                        style: TextStyle(
                          fontSize: 16,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        widget.anime.japaneseTitle ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          _buildTypeWidget(widget.anime.type),
                          SizedBox(width: 8),
                          if (widget.anime.nsfw!) _buildNSFWWidget(),
                        ],
                      ),
                      SizedBox(height: 4),
                      // Row(
                      //   children: [
                      //     _buildSubtitlesWidget(widget.anime.sub),
                      //     SizedBox(width: 10),
                      //     _buildDubbingWidget(widget.anime.dub),
                      //     SizedBox(width: 10),
                      //     _buildEpisodeCountWidget(widget.anime.episodes),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            right: 10,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Watch Now',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
