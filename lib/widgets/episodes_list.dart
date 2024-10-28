import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/details_model.dart';
import 'package:nekoflow/screens/stream.dart';

class EpisodesList extends StatelessWidget {
  final List<Episode> episodes;
  final String title;

  const EpisodesList({
    super.key,
    required this.episodes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: MediaQuery.of(context).size.width * 0.15,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: episodes.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final episode = episodes[index];
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Stream(
                  id: episode.id,
                  title: title,
                ),
              ),
            );
          },
          child: Center(
            child: Text(
              episode.number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
