import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'HorizontalMovieList.dart';
import 'Top5List.dart';
import 'SectionTitle.dart';
import "upcomingResponse.dart";
import 'Top100List.dart';
import 'networkRequests.dart';

class HomePage extends StatefulWidget {
  final String userProfileImageUrl;
  final List<Result>? upcomingResults;
  final TextEditingController _searchController = TextEditingController();
  final Function() onProfileTap;
  final Function(String) onSearchSubmit;
  final Top100List top100List;

  HomePage({
    Key? key,
    required this.userProfileImageUrl,
    this.upcomingResults,
    required this.top100List,
    required this.onProfileTap,
    required this.onSearchSubmit,
  }) : super(key: key);
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String userName = '';
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  Future<void> checkUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print('this is the userID: ${user!.uid}');
    }
    if (user != null) {
      // User is signed in
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        userName = userData.data()?['firstName'];
      });
    } else {
      logOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   //title: const Text('MovieHub'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(height: 100),
                  Text(
                    'Welcome $userName!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: widget.onProfileTap,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(widget.userProfileImageUrl),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: widget._searchController,
                decoration: InputDecoration(
                  labelText: 'Search movies',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      String temp = widget._searchController.text.trim();
                      widget._searchController.clear();
                      widget.onSearchSubmit(temp);
                    },
                    child: const Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SectionTitle(
              title: 'Upcoming',
              top100: widget.top100List,
            ),
            const SizedBox(height: 8),
            HorizontalMovieList(upcomingList: widget.upcomingResults ?? []),
            SizedBox(height: 16),
            SectionTitle(
              title: 'Top 5',
              top100: widget.top100List,
            ),
            //const SizedBox(height: 3),
            Top5List(
              top100List: widget.top100List,
            ),
          ],
        ),
      ),
    );
  }
}
