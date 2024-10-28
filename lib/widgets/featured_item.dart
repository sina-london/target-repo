import 'package:flutter/material.dart';
import 'package:nekoflow/screens/details.dart';

class FeaturedItem extends StatelessWidget {
  final Map<String, dynamic> anime;

  const FeaturedItem({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Details(
            id: anime['id'],
            image: anime['image'],
            title: anime['title'],
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(right: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              height: 300,
              child: RotatedBox(
                quarterTurns: 3,
                child: Text(
                  anime['title'],
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                anime['image'],
                width: MediaQuery.of(context).size.width * 0.5,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
