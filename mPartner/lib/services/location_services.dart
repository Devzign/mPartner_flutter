import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/app_constants.dart';

determineGeoCode() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // permission = await Geolocator.requestPermission();
    // if (permission == LocationPermission.denied) {
    return Future.error('Location permissions are denied');
    // }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  Position currPos = await Geolocator.getCurrentPosition();
  logger.d("Latitude: ${currPos.latitude} Longitude: ${currPos.longitude}");
  geoCode = "${currPos.latitude},${currPos.longitude}";
}

getAddress() async {
  List<String> coordinates = geoCode.split(",");
  double latitude = double.tryParse(coordinates[0]) ?? 0;
  double longitude = double.tryParse(coordinates[1]) ?? 0;
  List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
  logger.d("City: ${placemarks[0].locality}");
  if (placemarks != null) {
    location = (placemarks[0].locality != null || placemarks[0].locality != ""
        ? placemarks[0].locality
        : placemarks[0].subAdministrativeArea)!;
  }
}
