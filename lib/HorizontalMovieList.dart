import 'package:final_project/networkRequests.dart';
import 'package:flutter/material.dart';
import "upcomingResponse.dart";
import 'package:cached_network_image/cached_network_image.dart';

class HorizontalMovieList extends StatelessWidget {
  final List<Result> upcomingList;
  const HorizontalMovieList({super.key, required this.upcomingList});

  @override
  Widget build(BuildContext context) {
    // This would be your list of movie data

    // Replace with actual data

    return SizedBox(
      height: 200, // Fixed height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: upcomingList.length > 10 ? 10 : upcomingList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => loadMoviePage(context, upcomingList[index].id),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl:
                            upcomingList[index].primaryImage.url ?? nullPoster,
                        width: 120,
                        height: 110,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const SizedBox(
                          height:
                              1.0, // Smaller height for a smaller indicator
                          width: 1.0, // Smaller width for a smaller indicator
                          child: CircularProgressIndicator(
                            strokeWidth: 2, // Reduce the line width
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                  width: 4,
                ),
                //Text(upcomingList[index].titleText.text),
              ],
            ),
          );
        },
      ),
    );
  }
}
