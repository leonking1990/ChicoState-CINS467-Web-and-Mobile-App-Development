import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CastList extends StatelessWidget {
  final List<dynamic> castList;
  const CastList({super.key, required this.castList});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200, // Fixed height for horizontal list
        child: Expanded(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: castList.length,
            itemBuilder: (context, index) {
              var item = castList[index]; // Cache the item access
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: CachedNetworkImage(
                          imageUrl: item['node']['name']['primaryImage'] == null
                              ? 'path_to_default_image'
                              : item['node']['name']['primaryImage']['url'] ??
                                  'path_to_default_image',
                          width: 150,
                          height: 200,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const SizedBox(
                            height:
                                20.0, // Smaller height for a smaller indicator
                            width:
                                20.0, // Smaller width for a smaller indicator
                            child: CircularProgressIndicator(
                              strokeWidth: 2, // Reduce the line width
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['node']['name']['nameText']['text'] ?? 'Unknown',
                      style: const TextStyle(fontSize: 14), // Avoid overly small text
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
