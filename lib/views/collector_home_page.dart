import 'dart:async';
import 'dart:convert';

import 'package:capstone/controllers/booking_controller.dart';
import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/booking_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';

class CollectorHomePage extends StatefulWidget {
  const CollectorHomePage({super.key});

  @override
  _CollectorHomePageState createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends State<CollectorHomePage> {
  late BookingService _bookingService;
  late BookingController _bookingController;
  late WasteCollectorService _wasteCollectorService;
  late Future<WasteCollector> _wasteCollector;
  late CollectorController _wasteCollectorController;
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  String collectorId = 'az9PK12EPhMRz99Yvl8xHbKoxBH2';
  final TextEditingController _locationController = TextEditingController();
  double? pickUpLat = 37.7749; // Example pickup location
  double? pickUpLng = -122.4194; // Example pickup location

  double? driverLat; // Real-time driver location
  double? driverLng; // Real-time driver location
  Marker? driverMarker;
  Timer? driverLocationUpdateTimer;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  double? distance;
  String? eta;

  void _startUpdatingDriverLocation() {
    driverLocationUpdateTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) {
      _updateDriverLocation();
      _calculateDistanceAndETA();
    });
  }

  Future<void> _updateDriverLocation() async {
    loc.LocationData currentLocation = await _location.getLocation();
    setState(() {
      driverLat = currentLocation.latitude;
      driverLng = currentLocation.longitude;
      driverMarker = Marker(
        markerId: const MarkerId('driver'),
        position: LatLng(driverLat!, driverLng!),
        infoWindow: const InfoWindow(title: 'Driver'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });
  }

  Future<void> _openGoogleMaps() async {
    final Uri uri = Uri.parse(
      'google.navigation:q=$pickUpLat,$pickUpLng&key=${Constants.placesKey}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      _trackDriverArrival();
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _calculateDistanceAndETA() async {
    if (driverLat != null &&
        driverLng != null &&
        pickUpLat != null &&
        pickUpLng != null) {
      final Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$driverLat,$driverLng&destinations=$pickUpLat,$pickUpLng&key=${Constants.placesKey}',
      );
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          distance = data['rows'][0]['elements'][0]['distance']['value'] /
              1000; // Convert to kilometers
          eta = data['rows'][0]['elements'][0]['duration']['text'];
        });
      }
    }
  }

  void _trackDriverArrival() {
    driverLocationUpdateTimer =
        Timer.periodic(const Duration(seconds: 3), (timer) {
      if (driverLat != null &&
          driverLng != null &&
          pickUpLat != null &&
          pickUpLng != null) {
        double distanceInMeters = Geolocator.distanceBetween(
          driverLat!,
          driverLng!,
          pickUpLat!,
          pickUpLng!,
        );
        if (distanceInMeters < 50) {
          // Driver has arrived (within 50 meters)
          timer.cancel();
          Navigator.pop(context); // Switch back to the app
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startUpdatingDriverLocation();
    _location.onLocationChanged
        .listen((loc.LocationData currentLocation) async {
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation.latitude!, currentLocation.longitude!),
            zoom: 15,
          ),
        ),
      );
    });

    ApiService apiService = ApiService(Constants.baseUrl);
    _bookingService = BookingService(apiService);
    _bookingController = BookingController(_bookingService);

    _wasteCollectorService = WasteCollectorService(apiService);
    _wasteCollectorController = CollectorController(_wasteCollectorService);
    _wasteCollector = _wasteCollectorController
        .viewAccount(collectorId); // Initialize the future
  }

  @override
  void dispose() {
    _locationController.dispose();
    driverLocationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Home Screen',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: FutureBuilder<WasteCollector>(
          future: _wasteCollector,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading user details'));
            } else {
              var wasteCollector = snapshot.data!;
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                        '${wasteCollector.firstName} ${wasteCollector.lastName}'),
                    accountEmail: Text(wasteCollector.email),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: wasteCollector.profilePicture != null
                          ? NetworkImage(wasteCollector.profilePicture!)
                          : null,
                      backgroundColor: wasteCollector.profilePicture == null
                          ? Colors.blue
                          : null,
                    ),
                    decoration: const BoxDecoration(color: Colors.blue),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: const Text('About'),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {},
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(0.0, 0.0),
                zoom: 15,
              ),
              mapType: MapType.terrain,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                _location
                    .getLocation()
                    .then((loc.LocationData currentLocation) {
                  _mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(
                      CameraPosition(
                        target: LatLng(currentLocation.latitude!,
                            currentLocation.longitude!),
                        zoom: 15,
                      ),
                    ),
                  );
                });
              },
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              markers: driverMarker != null ? {driverMarker!} : {},
              polylines: _polylines,
            ),
            Positioned(
              bottom: 100,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  if (distance != null && eta != null)
                    Text(
                        'Distance: ${distance!.toStringAsFixed(2)} km, ETA: $eta'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _openGoogleMaps,
                    child: const Text('Open in Google Maps'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
