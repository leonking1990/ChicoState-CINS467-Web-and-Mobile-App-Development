import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/movieDetailResponse.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'networkRequests.dart';
import 'cameraContoller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  XFile? profileImage;
  String userProfileImageUrl = '';

  List<MovieDetail> likedMovies = [], dislikedMovies = [];

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
      List<MovieDetail> temp1 = [], temp2 = [];
      
      temp1 = await IMDbApi.getList(userData.data()?['favMovies']);
      temp2 = await IMDbApi.getList(userData.data()?['disMovies']);
      setState(() {
        userProfileImageUrl = userData.data()?['downloadURL'];
        likedMovies = temp1;
        dislikedMovies = temp2;
      });
    } else {
      logOut(context);
    }
  }

  Future<void> _cropImage(String imagePath) async {
    try {
      File? cropped = await ImageCropper().cropImage(
        sourcePath: imagePath,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop your image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
          title: 'Crop your image',
          aspectRatioLockEnabled: false,
        ),
        cropStyle: CropStyle.circle,
      );
      if (cropped != null) {
        setState(() {
          profileImage = XFile(cropped.path);
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cropping image: $e');
      }
      // Handle error in UI, e.g., show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          PopupMenuButton<String>(
              onSelected: (String result) {
                // Handle the menu item click
                switch (result) {
                  case 'Logout':
                    logOut(context);
                    break;
                  case 'Delete':
                    // add delete worning message and function.
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Logout',
                      child: Text('Logout'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Delete',
                      child: Text(
                        'Delete Account',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
              icon: const Icon(Icons.settings)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(userProfileImageUrl),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      showCameraPopup(context);
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
              'My Movie Preferences',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to customize profile
              },
              child: Text('Customize Profile'),
            ),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //     children: [
            //       Column(
            //         children: [
            //           Icon(Icons.movie),
            //           Text('556 Movies Watched'),
            //         ],
            //       ),
            //       Column(
            //         children: [
            //           Icon(Icons.star),
            //           Text('Top Critics Picks'),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            const Divider(),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'Favorite'),
                      Tab(text: 'Disliked'),
                      //Tab(text: 'Must-see'),
                    ],
                  ),
                  SizedBox(
                    height: 475, // Adjust the height to fit content
                    child: TabBarView(
                      children: [
                        _buildTabContent(
                            likedMovies), // Replace with actual content
                        _buildTabContent(dislikedMovies),
                        //_buildTabContent(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload() async {
    // Generate a v4 (random) id (universally unique identifier)
    Uuid uuid = Uuid();
    final String uid = uuid.v4();
    // Upload image file to storage (using uid) and generate a downloadURL
    final String downloadURL = await _uploadFile(uid);
    // Add downloadURL (ref to the image) to the database
    await _addItem(downloadURL, uid);
  }

  Future<void> getPicture() async {
    try {
      XFile? image = await takePicture();
      if (image != null) {
        setState(() {
          profileImage = image;
        });
        //_cropImage(image.path);
        await _upload();
      }
    } catch (e) {
      if (kDebugMode) {
        print("Failed to take picture: $e");
      }
      // Handle the error
    }
    setState(() {
      profileImage = null;
    });
  }

  Future<String> _uploadFile(String filename) async {
    // Android
    // Create a reference to file location in Google Cloud Storage object
    Reference ref = FirebaseStorage.instance.ref().child('$filename.jpg');
    // Add metadata to the image file
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      contentLanguage: 'en',
    );
    // Upload the file to Storage
    File file = File(profileImage!.path);
    final UploadTask uploadTask = ref.putFile(file, metadata);
    TaskSnapshot uploadResult = await uploadTask;
    // After the upload task is complete, get a (String) download URL
    final String downloadURL = await uploadResult.ref.getDownloadURL();
    // Return the download URL (to be used in the database entry)
    return downloadURL;
  }

  Future<void> _addItem(String downloadURL, String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      logOut(context);
    } else {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'downloadURL': downloadURL,
          'title': id,
          'timestamp': DateTime.now(),
        }, SetOptions(merge: true));
        checkUser();
      } catch (e) {
        if (kDebugMode) {
          print("Firestore error: $e");
        }
      }
    }
  }

  Future<void> showCameraPopup(BuildContext context) async {
    await initCamera(); // Initialize the camera

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            child: CameraPreview(controller!), // Display the camera preview
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                controller?.dispose(); // Dispose of the controller when done
              },
            ),
            FloatingActionButton(
              onPressed: () =>
                  getPicture().then((value) => Navigator.of(context).pop()),
              child: const Icon(Icons.camera),
            )
          ],
        );
      },
    );
  }

  Widget _buildTabContent(List<MovieDetail> moviesList) {
    // This should be replaced with your actual content for each tab
    // For now, we'll just create a placeholder ListView
    return ListView.builder(
      itemCount: moviesList.length, // Replace with actual item count
      itemBuilder: (context, index) {
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: moviesList[index].primaryImage.url!,
              width: 50,
              height: 100,
              fit: BoxFit.fill,
              placeholder: (context, url) => const SizedBox(
                height: 1.0, // Smaller height for a smaller indicator
                width: 1.0, // Smaller width for a smaller indicator
                child: CircularProgressIndicator(
                  strokeWidth: 2, // Reduce the line width
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          title: Text(
              moviesList[index].titleText.text), // Replace with actual data
          subtitle: Text(moviesList[index].caption.text, maxLines: 3, overflow: TextOverflow.ellipsis,),
          trailing: Icon(Icons.chevron_right),
          onTap: () {
            loadMoviePage(context, moviesList[index].id);
          },
        );
      },
    );
  }
}
