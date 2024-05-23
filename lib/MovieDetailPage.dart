import 'package:cached_network_image/cached_network_image.dart';
import 'package:final_project/castList.dart';
import 'package:final_project/networkRequests.dart';
import 'package:final_project/videoList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'MoreLikeThis.dart';
import 'FirestoreService.dart';

class MovieDetailPage extends StatefulWidget {
  final String movieID;
  final String title;
  final String imageUrl;
  final int releaseYear;
  final List<dynamic>? genre;
  final String plot;
  final double rating;
  final Map<String, dynamic> moreLike;
  final List<dynamic> cast;
  final List<dynamic> videos;

  MovieDetailPage({
    Key? key,
    required this.movieID,
    required this.title,
    required this.imageUrl,
    required this.releaseYear,
    required this.genre,
    required this.plot,
    required this.rating,
    required this.moreLike,
    required this.cast,
    required this.videos,
  }) : super(key: key);
  @override
  _MovieDetailPage createState() => _MovieDetailPage();
}

class _MovieDetailPage extends State<MovieDetailPage> {
  bool liked = false;
  bool disliked = false;

  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      liked =
          await FirestoreServices().searchUsersByFavoriteMovie(widget.movieID);
      disliked =
          await FirestoreServices().searchUsersByDislikedMovie(widget.movieID);
      setState(() {
        liked = liked;
        disliked = disliked;
      });
    } else {
      logOut(context);
    }
  }

  String genreOutput(List<dynamic>? text) {
    if (text != null) {
      if (text.length > 1) {
        String temp = text[0]['text'];

        for (var i = 1; i < text.length; i++) {
          temp += ' / ${text[i]['text']}';
        }
        return temp;
      } else {
        return text[0]['text'];
      }
    }
    return '';
  }

  void _updateFavDisList() {
    if (liked) {
      FirestoreServices().addFavoriteMovie(widget.movieID, context);
    } else {
      FirestoreServices().removeFavoriteMovie(widget.movieID, context);
    }
    if (disliked) {
      FirestoreServices().addDislikeMovie(widget.movieID, context);
    } else {
      FirestoreServices().removeDislikeMovie(widget.movieID, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    widget.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: widget.title.length > 30 ? 20 : 24,
                    ),
                  ),
                ),
              ),
              Center(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10.0), // Adjust the radius here
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    width: 375,
                    height: 525,
                    fit: BoxFit.fill,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            liked = !liked;
                            disliked = false;
                          });
                          _updateFavDisList();
                        },
                        child: liked
                            ? Icon(Icons.thumb_up)
                            : Icon(Icons.thumb_up_outlined)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                          onTap: () {
                            setState(() {
                              disliked = !disliked;
                              liked = false;
                            });
                            _updateFavDisList();
                          },
                          child: disliked
                              ? Icon(Icons.thumb_down)
                              : Icon(Icons.thumb_down_outlined)),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Release Year: ${widget.releaseYear}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Genre: ${genreOutput(widget.genre)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Rating: ${widget.rating}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Plot',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(widget.plot, style: const TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text('Cast',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    // TextButton(
                    //   child: const Text('explore >'),
                    //   onPressed: () {
                    //     //     Navigator.push(
                    //     //         context,
                    //     //         MaterialPageRoute(
                    //     //           builder: (context) => ExplorePage(),))
                    //   },
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CastList(castList: widget.cast),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text('Videos',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    // TextButton(
                    //   child: const Text('explore >'),
                    //   onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ExplorePage(),
                    //         ));
                    //   },
                    // ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: VideoList(
                  videoList: widget.videos,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text('More like this',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    // TextButton(
                    //   child: const Text('explore >'),
                    //   onPressed: () {
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => ExplorePage(),
                    //         ));
                    //   },
                    // ),
                  ],
                ),
              ),
              //const SectionTitle(title: 'More like this'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: MoreLikeThis(
                  likeThis: widget.moreLike['edges'],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
