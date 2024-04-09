import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'getLocation.dart';
import 'cameraContoller.dart';
import 'imageGrid.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
   String _location = 'Unknown';
  List<XFile> pictures = [];

  Future<void> updateLocation() async {
    String location =
        await determinePosition(); // Await the Future inside an async function
    setState(() {
      _location = location; // Update the state with the obtained location
    });
  }

  Future<void> getPicture() async {
  try {
    
    XFile? image = await takePicture();
    setState(() {
      if(image != null) {
        pictures.add(image); 
      }
    });
  } catch (e) {
    print("Failed to take picture: $e");
    // Handle the error
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
                controller
                    ?.dispose(); // Dispose of the controller when done
              },
            ),
            FloatingActionButton(onPressed: () => getPicture(), child: const Icon(Icons.camera),)
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    updateLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Current Location: $_location'),
      ),
      body: ImagesGrid(pictures: pictures,),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCameraPopup(context),
        child: const Icon(Icons.camera),
      ),
    );
  }
}
