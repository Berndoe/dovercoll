import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageState with ChangeNotifier {
  bool _isLocationEntered = false;
  bool _isBookingInProgress = false;
  bool _isDriverDetailsVisible = false;
  String _distance = '';
  String _duration = '';
  double? pickUpLat;
  double? pickUpLng;
  double? driverLat;
  double? driverLng;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  bool get isLocationEntered => _isLocationEntered;
  bool get isBookingInProgress => _isBookingInProgress;
  bool get isDriverDetailsVisible => _isDriverDetailsVisible;
  String get distance => _distance;
  String get duration => _duration;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;

  void updateLocationEntered(bool value) {
    _isLocationEntered = value;
    notifyListeners();
  }

  void updateBookingInProgress(bool value) {
    _isBookingInProgress = value;
    notifyListeners();
  }

  void updateDriverDetailsVisible(bool value) {
    _isDriverDetailsVisible = value;
    notifyListeners();
  }

  void updateDistance(String value) {
    _distance = value;
    notifyListeners();
  }

  void updateDuration(String value) {
    _duration = value;
    notifyListeners();
  }

  void addMarker(Marker marker) {
    _markers.add(marker);
    notifyListeners();
  }

  void addPolyline(Polyline polyline) {
    _polylines.add(polyline);
    notifyListeners();
  }

  void clearMarkers() {
    _markers.clear();
    notifyListeners();
  }

  void clearPolylines() {
    _polylines.clear();
    notifyListeners();
  }
}
