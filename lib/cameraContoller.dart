import 'package:camera/camera.dart';

List<CameraDescription>? cameras;
CameraController? controller;

Future<void> initCamera() async {
  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras!.first;

  // Create a CameraController.
  controller = CameraController(
    firstCamera,
    ResolutionPreset.medium,
  );

  // Next, initialize the controller. This returns a Future.
  await controller!.initialize();
}

Future<XFile?> takePicture() async {
  if (!controller!.value.isInitialized) {
    print('Error: select a camera first.');
    return null;
  }

  try {
    // Attempt to take a picture and log where it's been saved.
    final image = await controller!.takePicture();
    return image;
  } catch (e) {
    // If an error occurs, log the error to the console.
    print(e);
    return null;
  }
}
