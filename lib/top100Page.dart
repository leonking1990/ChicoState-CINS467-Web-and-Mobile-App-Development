import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/networkRequests.dart';

import 'Top100List.dart';
import 'package:flutter/material.dart';

class Top100Page extends StatelessWidget {
  final Top100List top100List;

  Top100Page({super.key, required this.top100List});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 100'),
      ),
      body: Expanded(
        child: ListView.builder(
          itemCount: top100List.results.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: () =>
                      loadMoviePage(context, top100List.results[index].id),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: top100List.results[index].imageURL,
                          width: 75,
                          height: 110,
                          fit: BoxFit.fill,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
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
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5),
                              //Text("Description: ${movies[index].caption?.caption}"),
                              Text(
                                "Description: ${top100List.results[index].description}",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
