import 'package:capstone/models/booking_model.dart';
import 'package:capstone/services/booking_service.dart';

class BookingController {
  final BookingService bookingService;

  BookingController(this.bookingService);

  Future<List<Booking>> getBookings() async {
    return await bookingService.fetchBookings();
  }

  Future<Booking> getBooking(String bookingId) async {
    return await bookingService.fetchBooking(bookingId);
  }

  Future<Booking> createBooking(String userId, int numberOfBins,
      dynamic pickUpLocationLatitude, dynamic pickUpLocationLongitude) async {
    var response = await bookingService.bookCollector(
      userId,
      numberOfBins,
      pickUpLocationLatitude,
      pickUpLocationLongitude,
    );
    return response;
  }

  Future<Booking> updateBooking(
      String bookingId, Map<String, dynamic> data) async {
    return await bookingService.updateBooking(bookingId, data);
  }

  Future<Booking> deleteBooking(String bookingId) async {
    return await bookingService.cancelBooking(bookingId);
  }
}
