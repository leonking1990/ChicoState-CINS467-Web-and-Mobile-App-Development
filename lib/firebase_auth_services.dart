import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/networkRequests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class FirebaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("some error occurred");
    }
    return null;
  }

  Future<User?> sigIinWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("error $e occurred");
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> checkUser(context) async {
    final User? user = FirebaseAuth.instance.currentUser;
    String url = '';
    if (kDebugMode) {
      print('this is the userID: ${user!.uid}');
    }
    if (user != null) {
      // User is signed in
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      url = userData.data()?['downloadURL'] ?? '';
    } else {
      logOut(context);
    }
    return url;
  }
}
