import 'package:capstone/models/booking_model.dart';
import 'package:capstone/services/booking_service.dart';

class BookingController {
  final BookingService bookingService;

  BookingController(this.bookingService);

  Future<List<Booking>> getBookings() {
    return bookingService.fetchBookings();
  }

  Future<Booking> getBooking(String bookingId) {
    return bookingService.fetchBooking(bookingId);
  }

  Future<List<Booking>> getUserBookings(String userId) {
    return bookingService.fetchUserHistory(userId);
  }

  Future<List<Booking>> getCollectorBookings(String collectorId) {
    return bookingService.fetchCollectorHistory(collectorId);
  }

  Future<Booking> createBooking(String userId, int numberOfBins,
      dynamic pickUpLocationLatitude, dynamic pickUpLocationLongitude) {
    var response = bookingService.bookCollector(
      userId,
      numberOfBins,
      pickUpLocationLatitude,
      pickUpLocationLongitude,
    );
    return response;
  }

  Future<Booking> updateBooking(String bookingId, Map<String, dynamic> data) {
    return bookingService.updateBooking(bookingId, data);
  }

  Future<Booking> deleteBooking(String bookingId) {
    return bookingService.cancelBooking(bookingId);
  }
}
