import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'firebase_options.dart';
import 'home.dart';
import 'loginPage.dart';
import 'signUp_page.dart';
import 'networkRequests.dart';
import 'SearchResults.dart';
import 'profilePage.dart';
import 'upcomingResponse.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter MovieApp Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignUpPage(),
          '/home': (context) => loadHomePage(),
          '/profile': (context) => const ProfilePage(),
          '/MovieList': (context) => MovieListPage(searchReq: ''),
        },
        home: loadHomePage());
  }

  Widget loadHomePage() {
    return FutureBuilder(
      future: Future.wait([
        FirebaseAuth.instance.authStateChanges().first,
        loadUpcomingMovies(), // Assuming this returns List<Result>
        checkUser(), // Assuming this returns String (image URL)
        TopList.fetchTopList()
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 1.0, // Smaller height for a smaller indicator
            width: 1.0, // Smaller width for a smaller indicator
            child: CircularProgressIndicator(
              strokeWidth: 2, // Reduce the line width
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var user = snapshot.data?[0] as User?;
          var upcomingMovies = snapshot.data?[1] as List<Result>;
          var userProfileImageUrl = snapshot.data?[2] as String;
          var topList = snapshot.data?[3];
          if (user != null) {
            return HomePage(
              userProfileImageUrl: userProfileImageUrl,
              upcomingResults: upcomingMovies,
              onProfileTap: () => Navigator.pushNamed(context, '/profile'),
              onSearchSubmit: (search) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieListPage(searchReq: search),
                ),
              ),
              top100List: topList,
            );
          } else {
            return LoginPage();
          }
        }
      },
    );
  }
}
