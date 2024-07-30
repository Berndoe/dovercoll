import 'package:capstone/controllers/booking_controller.dart';
import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/booking_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/booking_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/utils/helpers.dart';
import 'package:capstone/views/history_cards.dart';
import 'package:flutter/material.dart';

class UserHistory extends StatefulWidget {
  const UserHistory({super.key});

  @override
  State<UserHistory> createState() => _UserHistoryState();
}

class _UserHistoryState extends State<UserHistory> {
  String userId = 'E5ZIRRES8yQBB0tYxYgf4xH561z1';
  late ApiService apiService;
  late Future<List<Booking>> collectorTripHistory;
  late CollectorController collectorController;
  late WasteCollectorService wasteCollectorService;
  late BookingService bookingService;
  String name = '';

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Constants.baseUrl);
    bookingService = BookingService(apiService);
    wasteCollectorService = WasteCollectorService(apiService);
    collectorTripHistory =
        BookingController(bookingService).getUserBookings(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collector Trip History'),
      ),
      body: FutureBuilder<List<Booking>>(
        future: collectorTripHistory,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No booking history available.'));
          } else {
            List<Booking> bookings = snapshot.data!;
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                Booking booking = bookings[index];
                return HistoryCard(
                  date: booking.timeRequested,
                  price: booking.price,
                  bins: booking.numberOfBins,
                  collectorName:
                      Helpers.getCollectorName(booking.collectorId!) as String,
                );
              },
            );
          }
        },
      ),
    );
  }
}
