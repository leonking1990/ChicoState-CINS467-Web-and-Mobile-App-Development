import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/networkRequests.dart';
import 'package:flutter/material.dart';
import "upcomingResponse.dart";

class MoreLikeThis extends StatelessWidget {
  final List<dynamic> likeThis;
  const MoreLikeThis({super.key, required this.likeThis});

  @override
  Widget build(BuildContext context) {
    // This would be your list of movie data

    // Replace with actual data

    return SizedBox(
      height: 200, // Fixed height for horizontal list
      child: Expanded(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: likeThis.length > 10 ? 10 : likeThis.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          loadMoviePage(context, likeThis[index]['node']['id']),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: likeThis[index]['node']['primaryImage']
                                      ['url'] !=
                                  null
                              ? likeThis[index]['node']['primaryImage']['url']!
                              : nullPoster,
                          width: 120,
                          height: 110,
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
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                    width: 4,
                  ),
                  //Text(upcomingList[index].titleText.text),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
