import 'package:capstone/views/collector_main_page.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Permission.locationWhenInUse.isDenied.then((valueOfPermission) {
  //   if (valueOfPermission) {
  //     Permission.locationWhenInUse.request();
  //   }
  // });
//   //Remove this method to stop OneSignal Debugging
//   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//
//   OneSignal.initialize(Constants.oneSignalID);
//
// // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
//   OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DoverColl',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CollectorMainPage(),
    );
  }
}
