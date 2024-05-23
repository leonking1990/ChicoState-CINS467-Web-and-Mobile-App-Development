const String nullPoster =
    'https://firebasestorage.googleapis.com/v0/b/cinecritique-b9117.appspot.com/o/ComingSoon.jpg?alt=media&token=292bb9bd-21e7-484e-bf3a-6dc871aeef82';

class MovieDetail {
  final String id;
  final Ratings rating;
  final TitleText titleText;
  final int releaseYear;
  final String genres;
  final PrimaryImage primaryImage;
  final Caption caption;

  MovieDetail({
    required this.id,
    required this.rating,
    required this.titleText,
    required this.releaseYear,
    required this.genres,
    required this.primaryImage,
    required this.caption,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
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

    
    if (json.isNotEmpty) {
      return MovieDetail(
        id: json['id'],
        rating: Ratings(
            averageRating: json['ratingsSummary']['aggregateRating'],
            numVotes: json['ratingsSummary']['voteCount']),
        titleText: TitleText.fromJson(json['titleText']),
        releaseYear:
            json['releaseYear'] != null ? json['releaseYear']['year'] : 000,
        genres: genreOutput(json['genres']['genres']),
        primaryImage: json['primaryImage'] != null
            ? PrimaryImage.fromJson(json['primaryImage'])
            : PrimaryImage(url: nullPoster),
        caption: json['primaryImage'] != null
            ? Caption.fromJson(json['primaryImage']['caption'])
            : Caption(text: 'No Description'),
      );
    } else {
      return MovieDetail(
        id: '000',
        rating: Ratings(averageRating: 0, numVotes: 0),
        titleText: TitleText(text: 'No Results'),
        releaseYear: 000,
        genres: 'null',
        primaryImage: PrimaryImage(url: nullPoster),
        caption: Caption(text: 'No Description'),
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
  var averageRating;
  final int numVotes;

  Ratings({required this.averageRating, required this.numVotes});
}

class Caption {
  final String text;

  Caption({required this.text});
  factory Caption.fromJson(Map<String, dynamic> json) {
    return Caption(text: json['plainText']);
  }
}
