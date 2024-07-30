import '../models/booking_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class BookingService {
  ApiService apiService;

  BookingService(this.apiService);

  Future<List<Booking>> fetchBookings() async {
    final data = await apiService.get(Constants.bookingsEndpoint);
    return (data as List)
        .map((bookingJson) => Booking.fromJson(bookingJson))
        .toList();
  }

  Future<Booking> fetchBooking(String bookingId) async {
    final data =
        await apiService.get('${Constants.bookingsEndpoint}/$bookingId');
    return Booking.fromJson(data);
  }

  Future<List<Booking>> fetchUserHistory(String userId) async {
    final data =
        await apiService.get('${Constants.usersEndpoint}/$userId/history');
    return (data as List)
        .map((bookingJson) => Booking.fromJson(bookingJson))
        .toList();
  }

  Future<List<Booking>> fetchCollectorHistory(String collectorId) async {
    final data = await apiService
        .get('${Constants.collectorsEndpoint}/$collectorId/history');
    return (data as List)
        .map((bookingJson) => Booking.fromJson(bookingJson))
        .toList();
  }

  Future<Booking> bookCollector(String userId, int numberOfBins,
      double pickUpLocationLatitude, double pickUpLocationLongitude) async {
    final data = await apiService.post(Constants.bookingsEndpoint, {
      'user_id': userId,
      'number_of_bins': numberOfBins,
      'pickup_location': {
        'latitude': pickUpLocationLatitude,
        'longitude': pickUpLocationLongitude
      },
    });
    return Booking.fromJson(data);
  }

  Future<Booking> updateBooking(
      String bookingId, Map<String, dynamic> data) async {
    final response =
        await apiService.put('${Constants.bookingsEndpoint}/$bookingId', data);
    return Booking.fromJson(response);
  }

  // this is wrong
  Future<Booking> cancelBooking(String bookingId) async {
    final data =
        await apiService.delete('${Constants.bookingsEndpoint}/$bookingId');

    return Booking.fromJson(data);
  }
}
