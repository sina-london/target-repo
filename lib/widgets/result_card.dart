import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/search_result.dart';
import 'package:nekoflow/screens/details_screen.dart';

class ResultCard extends StatelessWidget {
  final Anime anime;
  final int index;
  const ResultCard({super.key, required this.anime, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DetailsScreen(id: anime.id, image: anime.image, title: anime.title),
          ),
        );
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          height: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.only(right: 5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Hero(
                tag: 'anime_${anime.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: anime.image.isNotEmpty
                      ? Image.network(
                          anime.image,
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.4,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                ),
              ),
              const SizedBox(width: 12.0),

              // Content Section
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with Index
                    Text(
                      "${index + 1}. ${anime.title}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8.0),

                    // Release Date
                    if (anime.releaseDate.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              anime.releaseDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Tags Section
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        // Sub/Dub Tag
                        if (anime.subOrDub.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: anime.subOrDub.toLowerCase() == 'sub'
                                  ? Colors.blue
                                  : Colors.deepPurple,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              anime.subOrDub.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonBar(
                            children: [
                              ButtonBar(
                                children: [
                                  Text("Watch Now"),
                                  Icon(Icons.play_arrow)
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
