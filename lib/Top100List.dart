class Top100List {
  final List<TopResult> results;

  Top100List({required this.results});

  factory Top100List.fromJson(List<dynamic> json) {
    return Top100List(
      results: List<TopResult>.from(
        json.map((x) => TopResult.fromJson(x)),
      ),
    );
  }

}

class TopResult {
  final int rank;  
  final String title;
  final String description;
  final String imageURL;
  final String rating;
  final int year;
  final String id;

  TopResult(
      {required this.rank,
      required this.title,
      required this.description,
      required this.imageURL,
      required this.rating,
      required this.year,
      required this.id});

  factory TopResult.fromJson(Map<String, dynamic> json) {
    return TopResult(
        rank: json['rank'],
        title: json['title'],
        description: json['description'],
        imageURL: json['image'],
        rating: json['rating'],
        year: json['year'],
        id: json['imdbid']);
  }
}
