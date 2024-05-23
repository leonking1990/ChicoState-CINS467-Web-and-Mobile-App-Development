import 'package:final_project/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoList extends StatelessWidget {
  final List<dynamic> videoList;
  const VideoList({super.key, required this.videoList});

  @override
  Widget build(BuildContext context) {
    // This would be your list of movie data

    // Replace with actual data

    return SizedBox(
      height: 200, // Fixed height for horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: videoList.length > 10 ? 10 : videoList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerScreen(
                            videoURL: videoList[index]['node']['playbackURLs']
                                [0]['url'],
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: videoList[index]['node']['thumbnail']['url'] ??
                          'path_to_default_image',
                      width: 200,
                      height: 280,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                  width: 4,
                ),
                Text(videoList[index]['node']['contentType']['displayName']['value'] ?? 'No title'),
              ],
            ),
          );
        },
      ),
    );
  }
}
