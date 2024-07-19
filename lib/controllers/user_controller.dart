import 'package:capstone/models/user_model.dart';
import 'package:capstone/services/user_service.dart';

class UserController {
  final UserService userService;

  UserController(this.userService);

  Future<User> viewAccount(String userId) async {
    return userService.viewAccountDetails(userId);
  }

  Future<User> createAccount(
      String userId, String name, String email, String phoneNumber) async {
    return userService.createAccount(userId, name, email, phoneNumber);
  }

  Future<User> editAccount(
      String userId, String name, String email, String phoneNumber) async {
    return userService.editAccountDetails(userId, name, email, phoneNumber);
  }

  Future<User> deleteAccount(String userId) async {
    return userService.deleteAccount(userId);
  }
}
