import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/Top100List.dart';
import 'package:final_project/networkRequests.dart';
import 'package:flutter/material.dart';

class Top5List extends StatelessWidget {
  final Top100List top100List;

  Top5List({required this.top100List});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics:
          const NeverScrollableScrollPhysics(), // To disable scrolling in ListView
      shrinkWrap: true, 
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: SizedBox(
              height: 130,
              child: InkWell(
                onTap: () {
                  loadMoviePage(context, top100List.results[index].id);
                },
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: top100List.results[index].imageURL,
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const SizedBox(
                          height:
                              100.0, // Smaller height for a smaller indicator
                          width: 100.0, // Smaller width for a smaller indicator
                          child: CircularProgressIndicator(
                            strokeWidth: 2, // Reduce the line width
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              top100List.results[index].title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              top100List.results[index].description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
