import 'package:flutter/material.dart';
import 'package:nekoflow/data/models/anime_interface.dart';
import 'package:nekoflow/screens/details_screen.dart';

class AnimeCard extends StatelessWidget {
  final Anime anime;
  const AnimeCard({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsScreen(
                    id: anime.id,
                    image: anime.poster,
                    title: anime.name,
                    duration: "24min",
                  ))),
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                anime.poster,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(child: Text('Image Not Available')),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8), // Slightly transparent black
                    Colors.black.withOpacity(0.0), // Fully transparent
                  ],
                  stops: [0.2, 1], // Adjust gradient distribution
                ),
              ),
              child: Text(
                anime!.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: Colors.pink),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.pink,
                        size: 12,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      anime.type,
                      style: TextStyle(
                          letterSpacing: -0.1, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
