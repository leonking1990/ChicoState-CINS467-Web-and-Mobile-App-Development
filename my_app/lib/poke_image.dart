import 'package:flutter/material.dart';

class PokeImage extends StatelessWidget {
  final String? imageUrl;

  const PokeImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 180.0,
      child: Center(
        // Center the image within the parent widget
        child: imageUrl == null
            ? Image.asset(
                'assets/images/pokéBall.png',
                // width: 150.00,
                // height: 150.00,
              )
            : Image.network(
                'https://img.pokemondb.net/artwork/vector/large/${imageUrl}.png',
                // width: 210.0,
                // height: 200.0,
                fit: BoxFit
                    .cover, // This ensures the image covers the space it's given, adjust according to your needs
                // Adding a loading placeholder or error widget is good practice
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  // Fallback widget in case of error loading the image
                  return const Icon(Icons.error);
                },
              ),
      ),
    );
  }
}
