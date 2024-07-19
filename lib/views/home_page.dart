import 'package:capstone/controllers/booking_controller.dart';
import 'package:capstone/controllers/user_controller.dart';
import 'package:capstone/models/user_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/booking_service.dart';
import 'package:capstone/services/user_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart' as loc;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BookingService _bookingService;
  late BookingController _bookingController;
  late UserService _userService;
  late UserController _userController;
  late Future<User> _user;
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  late ApiService _apiService;
  bool _isLocationEntered = false;
  String userId = 'E5ZIRRES8yQBB0tYxYgf4xH561z1';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _binNumberController =
      TextEditingController(text: '1');
  double? pickUpLat;
  double? pickUpLng;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void _updateButtonState() {
    setState(() {
      _isLocationEntered = _locationController.text.isNotEmpty;
    });
  }

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
    _locationController.addListener(_updateButtonState);

    _apiService = ApiService(Constants.baseUrl);
    _bookingService = BookingService(_apiService);
    _bookingController = BookingController(_bookingService);

    _userService = UserService(_apiService);
    _userController = UserController(_userService);
    _user = _userController.viewAccount(userId);
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
        child: FutureBuilder<User>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading user details'));
            } else {
              var user = snapshot.data!;
              return ListView(
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text('${user.firstName} ${user.lastName}'),
                    accountEmail: Text(user.email!),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicture!),
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
            Positioned(
              bottom: 150,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: placesAutoCompleteTextField(),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _binNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter number of bins',
                      labelText: 'Number of bins',
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isLocationEntered ? Colors.blue : Colors.grey,
                ),
                onPressed: () async {
                  _isLocationEntered ? bookCollector() : null;
                },
                child: Text(
                  'Request Waste Collector',
                  style: TextStyle(
                    color: _isLocationEntered ? Colors.white : Colors.black,
                  ),
                ),
              ),
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
            icon: Icon(Icons.car_repair_rounded),
            label: 'Drivers',
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

  Widget placesAutoCompleteTextField() {
    return GooglePlaceAutoCompleteTextField(
      textEditingController: _locationController,
      googleAPIKey: Constants.placesKey,
      inputDecoration: const InputDecoration(
        hintText: 'Enter location',
        fillColor: Colors.white,
        filled: true,
        isDense: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      ),
      debounceTime: 400,
      countries: const ["GH"],
      isLatLngRequired: true,
      getPlaceDetailWithLatLng: (Prediction prediction) {
        setState(() {
          pickUpLat = double.parse(prediction.lat!);
          pickUpLng = double.parse(prediction.lng!);
        });
      },
      itemClick: (Prediction prediction) {
        _locationController.text = prediction.description ?? "";
        _locationController.selection = TextSelection.fromPosition(
          TextPosition(offset: prediction.description?.length ?? 0),
        );
      },
      seperatedBuilder: const Divider(),
      isCrossBtnShown: true,
    );
  }

  void bookCollector() async {
    var booking = await _bookingController.createBooking(
      userId,
      int.parse(_binNumberController.text),
      pickUpLat!,
      pickUpLng!,
    );

    if (booking.bookingId.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Booking Created'),
            content: const Text('Your booking has been created successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      PolylinePoints polylinePoints = PolylinePoints();
      var updatedBooking = await _apiService.post(
        Constants.collectorsResponse,
        {
          "booking_id": booking.bookingId,
          "collector_id": "az9PK12EPhMRz99Yvl8xHbKoxBH2"
        },
      );

      if (updatedBooking['message'] == 'Booking accepted') {
        LatLng? collectorLocation =
            await Helpers.getCollectorLocation("az9PK12EPhMRz99Yvl8xHbKoxBH2");

        setState(() {
          _markers.add(Marker(
            markerId: const MarkerId('collector'),
            position: collectorLocation!,
          ));
        });

        if (pickUpLat != null && pickUpLng != null) {
          var directions = await Helpers.getDirections(
            LatLng(pickUpLat!, pickUpLng!),
            collectorLocation!,
          );

          List<PointLatLng> locationPoints =
              polylinePoints.decodePolyline(directions!.encodedPoints);

          setState(() {
            _polylines.add(Polyline(
              polylineId: const PolylineId('route'),
              points: locationPoints
                  .map((point) => LatLng(point.latitude, point.longitude))
                  .toList(),
              color: Colors.blue,
              width: 5,
            ));
          });
        }
      }
    }
  }
}
