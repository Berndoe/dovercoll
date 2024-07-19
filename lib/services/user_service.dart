import 'package:capstone/models/booking_model.dart';
import 'package:capstone/models/user_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/utils/constants.dart';

class UserService {
  ApiService apiService;

  UserService(this.apiService);

  Future<User> createAccount(
      String userId, String name, String email, String phoneNumber) async {
    final data = await apiService.post(Constants.usersEndpoint, {});

    return User.fromJson(data);
  }

  Future<User> viewAccountDetails(String userId) async {
    final data = await apiService.get('${Constants.usersEndpoint}/$userId');
    return User.fromJson(data);
  }

  Future<User> editAccountDetails(
      String userId, String name, String email, String phoneNumber) async {
    final data = await apiService.put('${Constants.usersEndpoint}/$userId', {});
    return User.fromJson(data);
  }

  Future<User> deleteAccount(String userId) async {
    final data = await apiService.delete('${Constants.usersEndpoint}/$userId');
    return User.fromJson(data);
  }

  Future<User> viewUserHistory(String userId) async {
    final data = await apiService
        .get('${Constants.usersEndpoint}/$userId/${Constants.history}');
    return User.fromJson(data);
  }

  Future<Booking> bookCollector() async {
    final data = apiService.post(Constants.bookingsEndpoint, {});
    return Booking.fromJson(data as Map<String, dynamic>);
  }

  Future<Booking> cancelBooking(String bookingId) async {
    final data =
        await apiService.delete('${Constants.bookingsEndpoint}/$bookingId');
    return Booking.fromJson(data);
  }
}
