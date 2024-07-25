// profile_page.dart
import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/controllers/user_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/models/user_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/user_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/utils/profile_type.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final ProfileType profileType;

  const ProfilePage({super.key, required this.profileType});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userId = 'E5ZIRRES8yQBB0tYxYgf4xH561z1';

  late UserController _userController;
  late CollectorController _collectorController;
  late Future<dynamic> _profile;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService(Constants.baseUrl);

    if (widget.profileType == ProfileType.user) {
      UserService userService = UserService(apiService);
      _userController = UserController(userService);
      _profile = _userController.viewAccount(userId);
    } else if (widget.profileType == ProfileType.collector) {
      WasteCollectorService collectorService =
          WasteCollectorService(apiService);
      _collectorController = CollectorController(collectorService);
      _profile = _collectorController.viewAccount(userId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<dynamic>(
          future: _profile,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              if (widget.profileType == ProfileType.user) {
                User user = snapshot.data!;
                return buildProfile(user.profilePicture, user.firstName!,
                    user.lastName!, user.email, user.rating);
              } else if (widget.profileType == ProfileType.collector) {
                WasteCollector collector = snapshot.data!;
                return buildProfile(
                    collector.profilePicture,
                    collector.firstName,
                    collector.lastName,
                    collector.email,
                    collector.rating);
              }
            }
            return const Center(child: Text('No data'));
          }),
    );
  }

  Widget buildProfile(String? profilePicture, String firstName, String lastName,
      String? email, double? rating) {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            color: Colors.blue,
            height: 300,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundImage: NetworkImage(profilePicture!),
                ),
                const SizedBox(height: 10),
                Text(
                  '$firstName $lastName',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  email!,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: 'First Name', hintText: firstName),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    hintText: lastName,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: email,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Rating',
                    hintText: rating != null ? '$rating' : '0.0',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Update Profile'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Log Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
