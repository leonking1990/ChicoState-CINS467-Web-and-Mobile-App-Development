const String nullPoster =
    'https://firebasestorage.googleapis.com/v0/b/cinecritique-b9117.appspot.com/o/ComingSoon.jpg?alt=media&token=292bb9bd-21e7-484e-bf3a-6dc871aeef82';

class SearchResponse {
  final int page;
  final String next;
  final int entries;
  final List<Movie> results;

  SearchResponse({
    required this.page,
    required this.next,
    required this.entries,
    required this.results,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['entries'] > 0) {
      return SearchResponse(
        page: json['page'],
        next: json['next'],
        entries: json['entries'],
        results:
            List<Movie>.from(json['results'].map((x) => Movie.fromJson(x))),
      );
    } else {
      return SearchResponse(
        page: 0,
        next: 'null',
        entries: 0,
        results:
            List<Movie>.from(json['results'].map((x) => Movie.fromJson(x))),
      );
    }
  }
}

class Movie {
  final String id;
  final Ratings rating;
  final TitleText titleText;
  final int releaseYear;
  final PrimaryImage primaryImage;
  final Caption? caption;

  Movie({
    required this.id,
    required this.rating,
    required this.titleText,
    required this.releaseYear,
    required this.primaryImage,
    required this.caption,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    //Ratings rating = Ratings(averageRating: 10);//await MovieApi.fetchRating(json['id']); // Fetch the rating asynchronously
    if (json.isNotEmpty) {
      return Movie(
        id: json['id'],
        rating: Ratings(averageRating: 10, numVotes: 100),
        titleText: TitleText.fromJson(json['titleText']),
        releaseYear:
            json['releaseYear'] != null ? json['releaseYear']['year'] : 000,
        primaryImage: json['primaryImage'] != null
            ? PrimaryImage.fromJson(json['primaryImage'])
            : PrimaryImage(url: nullPoster),
        caption: json['primaryImage'] != null
            ? Caption.fromJson(json['primaryImage']['caption'])
            : Caption(caption: 'No Description'),
      );
    } else {
      return Movie(
        id: '000',
        rating: Ratings(averageRating: 0, numVotes: 0),
        titleText: TitleText(text: 'No Results'),
        releaseYear: 000,
        primaryImage: PrimaryImage(url: nullPoster),
        caption: Caption(caption: 'No Description'),
      );
    }
  }
}

class TitleText {
  final String text;

  TitleText({required this.text});

  factory TitleText.fromJson(Map<String, dynamic> json) {
    return TitleText(text: json['text']);
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

class Ratings {
  final double averageRating;
  final int numVotes;

  Ratings({required this.averageRating, required this.numVotes});
  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
        averageRating: json['averageRating'], numVotes: json['numVotes']);
  }
}

class Caption {
  final String? caption;

  Caption({required this.caption});
  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(caption: json['plainText']);
  }
}
