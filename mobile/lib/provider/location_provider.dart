import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  bool _isFetching = false;
  bool get isFetching => _isFetching;

  LocationProvider() {
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    _isFetching = true;
    notifyListeners();

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _isFetching = false;
      notifyListeners();
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _isFetching = false;
        notifyListeners();
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _isFetching = false;
      notifyListeners();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _isFetching = false;
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    await _fetchCurrentLocation();
  }
}
