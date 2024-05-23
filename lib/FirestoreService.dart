import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/networkRequests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirestoreServices {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addFavoriteMovie(String id, context) async {
    DocumentReference userRef = _db.collection('users').doc(user?.uid);
    if (user == null) {
      logOut(context);
    } else {
      userRef
          .update({
            'favMovies': FieldValue.arrayUnion([id])
          })
          .then(
              (value) => {if (kDebugMode) print("Movie added from favorites.")})
          .catchError((error) => {
                if (kDebugMode) {print("Failed to add favorite: $error")}
              });
      checkUser();
    }
  }

  Future<bool> searchUsersByFavoriteMovie(String movieId) async {
    // Fetch the snapshot from Firestore
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('favMovies', arrayContains: movieId)
        .get();

    // Check if any documents were returned
    if (querySnapshot.docs.isNotEmpty) {
      return true; // Return true if at least one document contains the movieId in 'favMovies'
    }

    return false; // Return false if no documents were found
  }

  Future<bool> searchUsersByDislikedMovie(String movieId) async {
    // Fetch the snapshot from Firestore
    QuerySnapshot querySnapshot = await _db
        .collection('users')
        .where('disMovies', arrayContains: movieId)
        .get();

    // Check if any documents were returned
    if (querySnapshot.docs.isNotEmpty) {
      return true; // Return true if at least one document contains the movieId in 'favMovies'
    }

    return false; // Return false if no documents were found
  }

  Future<void> removeFavoriteMovie(String movieId, context) async {
    DocumentReference userRef = _db.collection('users').doc(user?.uid);
    if (user == null) {
      logOut(context);
    } else {
      userRef
          .update(
            {
              'favMovies': FieldValue.arrayRemove([movieId])
            },
          )
          .then(
            (_) => {
              if (kDebugMode) print("Movie removed from favorites."),
            },
          )
          .catchError(
            (error) => {
              if (kDebugMode)
                {
                  print("Failed to remove favorite: $error"),
                }
            },
          );
    }
  }

  Future<void> addDislikeMovie(String id, context) async {
    DocumentReference userRef = _db.collection('users').doc(user?.uid);
    if (user == null) {
      logOut(context);
    } else {
      userRef
          .update({
            'disMovies': FieldValue.arrayUnion([id])
          })
          .then(
              (value) => {if (kDebugMode) print("Movie added from favorites.")})
          .catchError((error) => {
                if (kDebugMode) {print("Failed to add favorite: $error")}
              });
      checkUser();
    }
  }

  Future<void> removeDislikeMovie(String movieId, context) async {
    DocumentReference userRef = _db.collection('users').doc(user?.uid);
    if (user == null) {
      logOut(context);
    } else {
      userRef
          .update(
            {
              'disMovies': FieldValue.arrayRemove([movieId])
            },
          )
          .then(
            (_) => {
              if (kDebugMode) print("Movie removed from favorites."),
            },
          )
          .catchError(
            (error) => {
              if (kDebugMode)
                {
                  print("Failed to remove favorite: $error"),
                }
            },
          );
    }
  }
}
