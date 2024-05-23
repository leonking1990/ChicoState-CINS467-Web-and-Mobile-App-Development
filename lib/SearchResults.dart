import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'IMDBSearchResponse.dart';
import 'networkRequests.dart';

class MovieListPage extends StatefulWidget {
  final String searchReq;
  MovieListPage({super.key, required this.searchReq});

  @override
  _MovieListPageState createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  List<Movie> movies = [];

  @override
  void initState() {
    super.initState();
    IMDbApi.fetchSearchRequest(widget.searchReq).then((value) => {
          setState(() {
            movies = value.results;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: Expanded(
        child: ListView.builder(
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
                              Text(movies[index].titleText,
                                  style:
                                      Theme.of(context).textTheme.titleLarge),
                              //Text("Description: ${movies[index].caption?.caption}"),
                              Text(
                                  "Caption: ${movies[index].caption?.caption}"),
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
