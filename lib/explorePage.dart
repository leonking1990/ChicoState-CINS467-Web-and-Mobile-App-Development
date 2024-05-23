import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/upcomingResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'networkRequests.dart';

class ExplorePage extends StatefulWidget {
  ExplorePage({super.key});

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<Result> movies = [];

  @override
  void initState() {
    super.initState();
    loadUpcomingMovies().then((value) => {
          setState(() {
            movies = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
      ),
      body: ListView.builder(
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                  onTap: () => loadMoviePage(context, movies[index].id),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: CachedNetworkImage(
                          imageUrl: movies[index].primaryImage.url!,
                          width: 75,
                          height: 110,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => SizedBox(
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(movies[index].titleText.text,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              //Text("Description: ${movies[index].caption?.caption}"),
                              Text(
                                  "Average Rating: ${movies[index].rating.averageRating}"),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          );
        },
      ),
    );
  }
}
