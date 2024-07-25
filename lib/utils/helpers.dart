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
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpers {
  final Completer<GoogleMapController> firstController =
      Completer<GoogleMapController>();
  GoogleMapController? mapController;

  Position? currentUserPosition;
  ApiService apiService = ApiService(Constants.baseUrl);

  static Future<void> makePhoneCall(phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  static Future<String> getAddress(Position position) async {
    String address = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.placesKey}";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      address = jsonData["results"][0]["formatted_address"];
    } else {
      return "No address Found";
    }
    return address;
  }

  static Future<DirectionInformation?> getDirections(
      LatLng userLocation, LatLng collectorLocation) async {
    String directions =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${collectorLocation.latitude},${collectorLocation.longitude}&destination=${userLocation.latitude},${userLocation.longitude}&key=${Constants.placesKey}";

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
    ApiService apiService = ApiService(Constants.baseUrl);
    WasteCollectorService wasteCollectorService =
        WasteCollectorService(apiService);
    CollectorController collectorController =
        CollectorController(wasteCollectorService);

    WasteCollector collectorDetails =
        await collectorController.viewAccount(collectorId);

    return LatLng(collectorDetails.latitude!, collectorDetails.longitude!);
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

  Future<void> sendBinNotification(String userId) async {
    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Authorization': 'MjA4YTllM2YtOTI2OC00NmExLThjMWQtZjkwY2U2ZjQ2MjFh',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'app_id': Constants.oneSignalID,
        'include_player_ids': userId,
        'headings': {'en': 'DoverColl (Bin)'},
        'contents': {'en': 'Your bin is full'},
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully.');
    } else {
      print('Failed to send notification.');
    }
  }

  Future<void> rateCollector() async {}
  Future<void> rateUser() async {}

  static void payCollector(BuildContext context) {
    final uniqueTransRef = PayWithPayStack().generateUuidV4();

    PayWithPayStack().now(
        context: context,
        secretKey: "sk_live_XXXXXXXXXXXXXXXXXXX",
        customerEmail: "popekabu@gmail.com",
        reference: uniqueTransRef,
        currency: "GHS",
        amount: 20,
        transactionCompleted: () {
          print("Transaction Successful");
        },
        transactionNotCompleted: () {
          print("Transaction Not Successful!");
        },
        callbackUrl: '');
  }
}
