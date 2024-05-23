const String nullPoster =
    'https://firebasestorage.googleapis.com/v0/b/cinecritique-b9117.appspot.com/o/ComingSoon.jpg?alt=media&token=292bb9bd-21e7-484e-bf3a-6dc871aeef82';

class UpcomingResponse {
  final int page;
  final String next;
  final int entries;
  final List<Result> results;

  UpcomingResponse({
    required this.page,
    required this.next,
    required this.entries,
    required this.results,
  });

  factory UpcomingResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingResponse(
      page: json['page'],
      next: json['next'],
      entries: json['entries'],
      results:
          List<Result>.from(json['results'].map((x) => Result.fromJson(x))),
    );
  }
}

class Result {
  final String id;
  final Rating rating;
  final TitleText titleText;
  final int releaseYear;
  final PrimaryImage primaryImage;

  Result({
    required this.id,
    required this.rating,
    required this.titleText,
    required this.releaseYear,
    required this.primaryImage,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    //Ratings rating = Ratings(averageRating: 10);//await MovieApi.fetchRating(json['id']); // Fetch the rating asynchronously
    return Result(
      id: json['id'],
      rating: Rating(averageRating: 10, numVotes: 100),
      titleText: TitleText.fromJson(json['titleText']),
      releaseYear: json['releaseYear'] != null
          ? json['releaseYear']['year']
          : 000,
      primaryImage: json['primaryImage'] != null
          ? PrimaryImage.fromJson(json['primaryImage'])
          : PrimaryImage(url: nullPoster),
    );
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

class Rating {
  final double averageRating;
  final int numVotes;

  Rating({required this.averageRating, required this.numVotes});
  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
        averageRating: json['averageRating'], numVotes: json['numVotes']);
  }
}
