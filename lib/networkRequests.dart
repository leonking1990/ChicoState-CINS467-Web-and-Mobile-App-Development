import 'dart:convert';
import 'package:final_project/MovieDetailPage.dart';
import 'package:final_project/Top100List.dart';
import 'package:final_project/movieDetailResponse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "upcomingResponse.dart";
import 'searchResponse.dart';
import 'IMDBSearchResponse.dart';
import 'firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';



class TopList {
  static const _baseUrl = 'https://imdb-top-100-movies.p.rapidapi.com/';
  static final _headers = {
    'X-RapidAPI-Key': ApiKey,
    'X-RapidAPI-Host': 'imdb-top-100-movies.p.rapidapi.com'
  };

  static Future<Top100List> fetchTopList() async {
    var url = Uri.parse(_baseUrl);
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return Top100List.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

class IMDbApi {
  static const _baseUrl = 'https://imdb146.p.rapidapi.com/v1';
  static final  _headers = {
    'X-RapidAPI-Key': ApiKey,
    'X-RapidAPI-Host': 'imdb146.p.rapidapi.com'
  };
  static Future<Map<String, dynamic>> fetchMovieDetails(String movieID) async {
    var url =
        Uri.parse('$_baseUrl/title/').replace(queryParameters: {'id': movieID});
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<IMDBSearchResponse> fetchSearchRequest(String title) async {
    var url = Uri.parse('$_baseUrl/find/').replace(queryParameters: {
      'query': title,
    });
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return IMDBSearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<List<MovieDetail>> getList(List<dynamic> list) async {
    List<MovieDetail> moviesList = [];
    for (var i = 0; i < list.length; i++) {
      moviesList.add(MovieDetail.fromJson(await fetchMovieDetails(list[i])));
    }

    return moviesList;
  }
}

class MovieApi {
  static const _baseUrl = 'https://moviesdatabase.p.rapidapi.com';
  static final  _headers = {
    'X-RapidAPI-Key': ApiKey,
    'X-RapidAPI-Host': 'moviesdatabase.p.rapidapi.com'
  };

  static Future<UpcomingResponse> fetchUpcoming() async {
    var url = Uri.parse('$_baseUrl/titles/x/upcoming')
        .replace(queryParameters: {'titleType': 'movie'});
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return UpcomingResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<SearchResponse> fetchSearchRequest(String title) async {
    var url = Uri.parse('$_baseUrl/titles/search/title/$title')
        .replace(queryParameters: {
      'exact': 'false',
      'titleType': 'movie',
    });
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return SearchResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  static Future<Map<String, dynamic>> fetchMovieDetails(String movieID) async {
    var url = Uri.parse('$_baseUrl/titles/$movieID');
    try {
      var response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load data: HTTP ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }
}

Future<String> checkUser() async {
  final User? user = FirebaseAuth.instance.currentUser;
  if (kDebugMode) {
    print('this is the userID: ${user?.uid}');
  }
  if (user != null) {
    // User is signed in
    var userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    return userData.data()?['downloadURL'];
  }
  return '';
}

Future<void> logOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to the login page after logout
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login', // The named route you want to navigate to.
      (Route<dynamic> route) =>
          false, // Conditions for removing all other routes.
    );
  } catch (e) {
    if (kDebugMode) {
      print('Error signing out: $e');
    }
    // Handle any errors that occur during logout
  }
}

Future<List<Result>> loadUpcomingMovies() async {
  try {
    UpcomingResponse? upcomingMovies = await MovieApi.fetchUpcoming();
    if (kDebugMode) {
      print('Loaded ${upcomingMovies.results.length} movies.');
    }
    return upcomingMovies.results;
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
  }
  return [];
}

Future<void> loadMoviePage(BuildContext context, String movieID) async {
  try {
    Map<String, dynamic> json = await IMDbApi.fetchMovieDetails(movieID);
    //Ratings rating = await MovieApi.fetchRating(movieID);
    String? imageUrl = json['primaryImage']['url'];
    if (json['primaryImage']['url'] == null) {
      imageUrl = nullurl;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(
          movieID: json['id'],
          title: json['titleText']['text'],
          imageUrl: imageUrl!,
          releaseYear: json['releaseYear']['year'],
          genre: json['genres']['genres'],
          plot: json['plot']['plotText']['plainText'],
          rating: json['ratingsSummary']['aggregateRating'] != null
              ? (json['ratingsSummary']['aggregateRating']).toDouble()
              : 0, //rating.averageRating,
          moreLike: json['moreLikeThisTitles'],
          cast: json['cast']['edges'],
          videos: json['primaryVideos']['edges'],
        ),
      ),
    );
    //print(json['ratingSummary']);
  } catch (e) {}
}
