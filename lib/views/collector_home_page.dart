import 'package:capstone/controllers/booking_controller.dart';
import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/booking_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BookingService _bookingService;
  late BookingController _bookingController;
  late WasteCollectorService _wasteCollectorService;
  late Future<WasteCollector> _wasteCollector;
  late CollectorController _wasteCollectorController;
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  String collectorId = 'az9PK12EPhMRz99Yvl8xHbKoxBH2';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _binNumberController =
      TextEditingController(text: '1');
  double? pickUpLat;
  double? pickUpLng;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
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

      // Get address from current location
      String address = await Helpers.getAddress(Position(
        latitude: currentLocation.latitude!,
        longitude: currentLocation.longitude!,
        timestamp: DateTime.now(),
        altitude: currentLocation.altitude ?? 0.0,
        accuracy: currentLocation.accuracy ?? 0.0,
        heading: currentLocation.heading ?? 0.0,
        speed: currentLocation.speed ?? 0.0,
        altitudeAccuracy: currentLocation.verticalAccuracy ?? 0.0,
        headingAccuracy: currentLocation.headingAccuracy ?? 0.0,
        speedAccuracy: currentLocation.speedAccuracy ?? 0.0,
      ));
      setState(() {
        _locationController.text = address;
        pickUpLat = currentLocation.latitude;
        pickUpLng = currentLocation.longitude;
      });
    });

    ApiService apiService = ApiService(Constants.baseUrl);
    _bookingService = BookingService(apiService);
    _bookingController = BookingController(_bookingService);

    _wasteCollectorService = WasteCollectorService(apiService);
    _wasteCollectorController = CollectorController(_wasteCollectorService);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _binNumberController.dispose();
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
                      backgroundImage:
                          NetworkImage(wasteCollector.profilePicture!),
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
              markers: _markers,
              polylines: _polylines,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My Profile',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: (index) {
          // Handle navigation here
        },
      ),
    );
  }
}
