import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';


Future<String> getPlace(Position position) async {
  try {
    // Perform reverse geocoding to get address information from coordinates
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // Placemarks is a list of addresses, that takes the first one
    Placemark place = placemarks.first;

    // Return the city name
    return "${place.locality}, ${place.administrativeArea}";
  } catch (e) {
    print("Error occurred: $e");
    return "Unknown";
  }
}


Future<String> determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, notify the user
       return "Location services are disabled.";
      
      
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, notify the user
        
          return"Location permissions are denied";
        
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever.
      
            return "Location permissions are permanently denied, we cannot request permissions.";
      
    }

    // If the above checks pass, get the location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      
        return getPlace(position);
      
    } catch (e) {
      // Handle exception
      
        return "Failed to get location: ${e.toString()}";
      
    }
  }