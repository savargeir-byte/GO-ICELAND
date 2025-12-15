import 'package:geolocator/geolocator.dart';

double distanceKm(
  double lat1,
  double lng1,
  double lat2,
  double lng2,
) {
  return Geolocator.distanceBetween(
        lat1,
        lng1,
        lat2,
        lng2,
      ) /
      1000;
}

Future<Position?> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return null;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  return await Geolocator.getCurrentPosition();
}
