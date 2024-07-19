import 'dart:async';
import 'dart:convert';

import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/models/directions.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class Helpers {
  final Completer<GoogleMapController> firstController =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;

  Position? currentUserPosition;

  static Future<String> getAddress(Position position) async {
    String address = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.placesKey}";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      address = jsonData["results"][0]["formatted_address"];
    }
    return address;
  }

  static Future<DirectionInformation?> getDirections(
      LatLng userLocation, LatLng driverLocation) async {
    String directions =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${driverLocation.longitude},"
        " ${driverLocation.latitude}&destination=${userLocation.longitude}, ${userLocation.latitude}&key=${Constants.placesKey}";

    var response = await http.get(Uri.parse(directions));

    if (response.statusCode == 200) {
      String jSonData = response.body;
      var directions = jsonDecode(jSonData);

      int distanceValue =
          directions["routes"][0]["legs"][0]["distance"]["value"];
      String distanceText =
          directions["routes"][0]["legs"][0]["distance"]["text"];

      int durationValue =
          directions["routes"][0]["legs"][0]["distance"]["value"];
      String durationText =
          directions["routes"][0]["legs"][0]["distance"]["text"];

      String encodedPoints =
          directions["routes"][0]["overview_polyline"]["points"];

      DirectionInformation directionInformation = DirectionInformation(
          distanceValue: distanceValue,
          durationValue: durationValue,
          distanceText: distanceText,
          durationText: durationText,
          encodedPoints: encodedPoints);

      return directionInformation;
    } else {
      return null;
    }
  }

  static Future<LatLng?> getCollectorLocation(String collectorId) async {
    ApiService apiService = ApiService(Constants.collectorsEndpoint);
    WasteCollectorService wasteCollectorService =
        WasteCollectorService(apiService);
    CollectorController collectorController =
        CollectorController(wasteCollectorService);

    WasteCollector collectorDetails =
        await collectorController.viewAccount(collectorId);

    return LatLng(collectorDetails.latitude!, collectorDetails.latitude!);
  }

  // Helper function to show a snackbar
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  // Helper function to convert JSON date to readable format
  static String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.day}/${parsedDate.month}/${parsedDate.year}';
  }
}
