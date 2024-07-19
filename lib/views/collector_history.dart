import 'package:capstone/controllers/collector_controller.dart';
import 'package:capstone/models/collector_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/services/waste_collector_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/views/contact_card.dart';
import 'package:flutter/material.dart';

class CollectorHistory extends StatefulWidget {
  const CollectorHistory({super.key});

  @override
  State<CollectorHistory> createState() => _CollectorHistoryState();
}

class _CollectorHistoryState extends State<CollectorHistory> {
  String collectorId = '';
  late CollectorController _collectorController;
  late Future<WasteCollector> _wasteCollector;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService(Constants.baseUrl);
    WasteCollectorService wasteCollectorService =
        WasteCollectorService(apiService);
    _collectorController = CollectorController(wasteCollectorService);
    _wasteCollector = _collectorController.viewCollectorHistory(collectorId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Center(
          child: Text(
            'Waste Collectors',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<WasteCollector>(
        future: _wasteCollector,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<WasteCollector> wasteCollectors =
                snapshot.data! as List<WasteCollector>;
            return ListView.builder(
              itemCount: wasteCollectors.length,
              itemBuilder: (context, index) {
                final wasteCollector = wasteCollectors[index];
                return ContactCard(
                  profileImage: wasteCollector.profilePicture,
                  name:
                      '${wasteCollector.firstName} ${wasteCollector.lastName}',
                  phoneNumber: wasteCollector.phoneNumber,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No drivers found'),
            );
          }
        },
      ),
    );
  }
}
