const String nullPoster =
    'https://firebasestorage.googleapis.com/v0/b/cinecritique-b9117.appspot.com/o/ComingSoon.jpg?alt=media&token=292bb9bd-21e7-484e-bf3a-6dc871aeef82';

class IMDBSearchResponse {
  // final int page;
  // final String next;
  // final int entries;
  final List<Movie> results;

  IMDBSearchResponse({
    // required this.page,
    // required this.next,
    // required this.entries,
    required this.results,
  });

  factory IMDBSearchResponse.fromJson(Map<String, dynamic> json) {
    return IMDBSearchResponse(
      // page: json['page'],
      // next: json['next'],
      // entries: json['entries'],
      results:
          List<Movie>.from(json['titleResults']['results'].map((x) => Movie.fromJson(x))),
    );
  }
}

class Movie {
  final String id;
  final String titleText;
  final int releaseYear;
  final PrimaryImage primaryImage;
  final Caption? caption;

  Movie({
    required this.id,
    required this.titleText,
    required this.releaseYear,
    required this.primaryImage,
    required this.caption,
  });

  factory Movie.fromJson(Map<String, dynamic> results) {
    
    if (results.isNotEmpty) {
      return Movie(
        id: results['id'],
        titleText: results['titleNameText'],
        releaseYear: results['titleReleaseYear'] ?? 000,
        primaryImage: results['titlePosterImageModel'] != null
            ? PrimaryImage.fromJson(results['titlePosterImageModel'])
            : PrimaryImage(url: nullPoster),
        caption: results['titlePosterImageModel'] != null
            ? Caption.fromJson(results['titlePosterImageModel'])
            : Caption(caption: 'No Description'),
      );
    } else {
      return Movie(
        id: '000',
        titleText: 'No Results',
        releaseYear: 000,
        primaryImage: PrimaryImage(url: nullPoster),
        caption: Caption(caption: 'No Description'),
      );
    }
  }
}

class PrimaryImage {
  final String? url;

  PrimaryImage({this.url});

  factory PrimaryImage.fromJson(Map<String, dynamic> json) {
    return PrimaryImage(
      url: json['url'],
    );
  }
}

class Caption {
  final String? caption;

  Caption({required this.caption});
  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(caption: json['caption']);
  }
}
