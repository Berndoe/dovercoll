import 'dart:async';

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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late BookingService _bookingService;
  late BookingController _bookingController;
  late UserService _userService;
  late UserController _userController;
  late Future<User> _user;
  GoogleMapController? _mapController;
  final loc.Location _location = loc.Location();
  late ApiService _apiService;
  bool _isLocationEntered = false;
  bool _isBookingInProgress = false;
  bool _isDriverDetailsVisible = false;
  String userId = 'E5ZIRRES8yQBB0tYxYgf4xH561z1';
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _binNumberController =
      TextEditingController(text: '1');
  double? pickUpLat;
  double? pickUpLng;
  double? driverLat;
  double? driverLng;
  String _distance = '';
  String _duration = '';
  String bookingId = '';

  TabController? _tabController;
  int _currentIndex = 0;

  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
      _tabController!.index = _currentIndex;
    });
  }

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
            zoom: 17,
          ),
        ),
      );

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

    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _binNumberController.dispose();
    super.dispose();
  }

  Future<void> bookCollector() async {
    var booking = await _bookingController.createBooking(
      userId,
      int.parse(_binNumberController.text),
      pickUpLat!,
      pickUpLng!,
    );

    if (booking.bookingId.isNotEmpty) {
      var updatedBooking = await _apiService.post(
        Constants.collectorsResponse,
        {
          "booking_id": booking.bookingId,
          "collector_id": "az9PK12EPhMRz99Yvl8xHbKoxBH2"
        },
      );

      if (updatedBooking['message'] == 'Booking accepted') {
        bookingId = booking.bookingId;
        LatLng? collectorLocation =
            await Helpers.getCollectorLocation("az9PK12EPhMRz99Yvl8xHbKoxBH2");

        if (collectorLocation != null) {
          try {
            var directions = await Helpers.getDirections(
                LatLng(pickUpLat!, pickUpLng!), collectorLocation);

            PolylinePoints polylinePoints = PolylinePoints();
            List<PointLatLng> locationPoints =
                polylinePoints.decodePolyline(directions!.encodedPoints);

            setState(() {
              _distance = directions.distanceText;
              _duration = '${directions.durationText}';

              _polylines.add(Polyline(
                polylineId: const PolylineId('route'),
                points: locationPoints
                    .map((point) => LatLng(point.latitude, point.longitude))
                    .toList(),
                color: Colors.blue,
                width: 5,
              ));
              _markers.add(Marker(
                flat: true,
                markerId: const MarkerId('collector'),
                position: collectorLocation,
                infoWindow: const InfoWindow(
                  title: 'Collector',
                  snippet: 'Your assigned collector',
                ),
              ));
              _isDriverDetailsVisible = true;
            });

            // Calculate the bounds for the polyline
            LatLngBounds bounds = LatLngBounds(
              southwest: LatLng(
                locationPoints
                    .map((point) => point.latitude)
                    .reduce((a, b) => a < b ? a : b),
                locationPoints
                    .map((point) => point.longitude)
                    .reduce((a, b) => a < b ? a : b),
              ),
              northeast: LatLng(
                locationPoints
                    .map((point) => point.latitude)
                    .reduce((a, b) => a > b ? a : b),
                locationPoints
                    .map((point) => point.longitude)
                    .reduce((a, b) => a > b ? a : b),
              ),
            );

            // Animate camera to fit the bounds
            _mapController?.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 50),
            );
          } catch (e) {
            print(e);
          }
        }
      }
    }
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
        backgroundColor: Colors.white,
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
                zoom: 17,
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
                        zoom: 17,
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
            if (!_isBookingInProgress)
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
            if (_isBookingInProgress)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () async {
                    // Handle cancel booking
                    setState(() {
                      _isBookingInProgress = false;
                      _isDriverDetailsVisible = false;
                      _markers.clear();
                      _polylines.clear();
                    });
                  },
                  child: const Text(
                    'Cancel Collection',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLocationEntered
                      ? (_isBookingInProgress ? Colors.red : Colors.blue)
                      : Colors.grey,
                ),
                onPressed: () async {
                  if (_isLocationEntered) {
                    if (_isBookingInProgress) {
                      await _bookingController.deleteBooking(bookingId);
                      setState(() {
                        _isBookingInProgress = false;
                        _isDriverDetailsVisible = false;
                        _markers.clear();
                        _polylines.clear();
                      });
                    } else {
                      showBookingDetailsSheet();
                    }
                  }
                },
                child: Text(
                  _isBookingInProgress
                      ? 'Cancel Booking'
                      : 'Request Waste Collector',
                  style: TextStyle(
                    color: _isLocationEntered
                        ? (_isBookingInProgress ? Colors.white : Colors.white)
                        : Colors.black,
                  ),
                ),
              ),
            ),
            if (_isDriverDetailsVisible)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Driver Location: ${driverLat ?? ''}, ${driverLng ?? ''}'),
                      Text('Distance: $_distance'),
                      Text('Duration: $_duration'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            _isBookingInProgress = false;
                            _isDriverDetailsVisible = false;
                            _markers.clear();
                            _polylines.clear();
                            _bookingController.deleteBooking(bookingId);
                          });
                        },
                        child: const Text(
                          'Cancel Booking',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
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

  void showBookingDetailsSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Number of bins: ${_binNumberController.text}'),
              Text('Location: ${_locationController.text}'),
              // Replace with actual price calculation logic
              const Text('Price: \$20'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pop(); // Close the booking details sheet
                  setState(() {
                    _isBookingInProgress = true;
                  });
                  await bookCollector(); // Proceed with booking
                },
                child: const Text('Confirm'),
              ),
            ],
          ),
        );
      },
    );
  }
}
