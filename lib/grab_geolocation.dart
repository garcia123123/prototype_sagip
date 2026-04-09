import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prototype_sagip/authenticate.dart';

class GrabGeolocation {
  Future<String> sendLocationToDatabase() async {
    bool serviceEnabled;
    LocationPermission permission;

    //Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    //Check/Request permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    //Get current position and send to Firestore
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      final User? user = Authenticate().currentUser;

      if (user != null) {
        // This targets: users -> {uid} -> location_history (collection) -> {new document}
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('location_history')
            .add({
          'latitude': position.latitude,
          'longitude': position.longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Optional: Also update the LATEST location on the main user document for easy access
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'last_known_location': {
            'latitude': position.latitude,
            'longitude': position.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          }
        });

        return 'Location updated in user profile!';
      }
      return 'Error: No user logged in.';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
