// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'dart:convert';

import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils//helpers.dart';
import 'package:capstone/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'widget_test.mocks.dart' as generated_mocks;

@GenerateMocks([http.Client, WasteCollectorService, CollectorController, Uri])
void main() {
  group('Helpers', () {
    late generated_mocks.MockClient mockClient;
    late generated_mocks.MockWasteCollectorService mockWasteCollectorService;
    late generated_mocks.MockCollectorController mockCollectorController;

    setUp(() {
      mockClient = generated_mocks.MockClient();
      mockWasteCollectorService = generated_mocks.MockWasteCollectorService();
      mockCollectorController = generated_mocks.MockCollectorController();
    });

    test('getAddress returns address', () async {
      final position = Position(
          latitude: 37.4219983,
          longitude: -122.084,
          timestamp: DateTime.now(),
          altitude: 0.0,
          accuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0);

      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.placesKey}";
      final response = {
        "results": [
          {
            "formatted_address":
                "1600 Amphitheatre Pkwy Building 43, Mountain View, CA 94043, USA"
          }
        ],
        "status": "OK"
      };

      when(mockClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      final address = await Helpers.getAddress(position);
      expect(address,
          "1600 Amphitheatre Pkwy Building 43, Mountain View, CA 94043, USA");
    });

    test('getAddress returns "No address Found" on error', () async {
      final position = Position(
          latitude: 37.4219983,
          longitude: -1222.084,
          timestamp: DateTime.now(),
          altitude: 0.0,
          accuracy: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0);

      final url =
          "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${Constants.placesKey}";

      when(mockClient.get(Uri.parse(url)))
          .thenAnswer((_) async => http.Response('Error', 400));

      final address = await Helpers.getAddress(position);
      expect(address, "No address Found");
    });

    test('getCollectorLocation returns collector location', () async {
      const collectorId = 'az9PK12EPhMRz99Yvl8xHbKoxBH2';
      final collector = WasteCollector(
        collectorId: collectorId,
        email: 'johndoe@abc.com',
        phoneNumber: '0208915108',
        latitude: 5.640125646579138,
        longitude: -0.15082962197793698,
        vehicleNumber: 'GW 1597-13',
        firstName: 'John',
        lastName: 'Doe',
      );

      when(mockWasteCollectorService.apiService).thenReturn(Helpers.apiService);
      when(mockCollectorController.viewAccount(collectorId))
          .thenAnswer((_) async => collector);

      final location = await Helpers.getCollectorLocation(collectorId);
      expect(location, isNotNull);
      expect(location!.latitude, collector.latitude);
      expect(location.longitude, collector.longitude);
    });
    test('formatDate returns formatted date', () {
      const date = "2024-07-29T00:00:00Z";
      final formattedDate = Helpers.formatDate(date);
      expect(formattedDate, "29/7/2024");
    });

    test('getCollectorName returns collector name', () async {
      const collectorId = 'az9PK12EPhMRz99Yvl8xHbKoxBH2';
      final collector = WasteCollector(
        collectorId: collectorId,
        email: 'johndoe@abc.com',
        phoneNumber: '0208915108',
        latitude: 5.640125646579138,
        longitude: -0.15082962197793698,
        vehicleNumber: 'GW 1597-13',
        firstName: 'John',
        lastName: 'Doe',
      );

      when(mockWasteCollectorService.apiService).thenReturn(Helpers.apiService);
      when(mockCollectorController.viewAccount(collectorId))
          .thenAnswer((_) async => collector);

      final name = await Helpers.getCollectorName(collectorId);
      expect(name, 'John Doe');
    });

    test('calculatePrice calculates price correctly', () {
      final priceForOneBin = Helpers.calculatePrice(1);
      final priceForMultipleBins = Helpers.calculatePrice(3);

      expect(priceForOneBin, Constants.basePrice);
      expect(priceForMultipleBins,
          3 * Constants.basePrice - 0.1 * (3 - Constants.basePrice));
    });
  });
}

class MockBuildContext extends Mock implements BuildContext {}
