import 'package:capstone/models/collector_model.dart';
import 'package:capstone/services/api_service.dart';
import 'package:capstone/utils/constants.dart';
import 'package:capstone/views/contact_card.dart';
import 'package:flutter/material.dart';

class WasteCollectors extends StatefulWidget {
  const WasteCollectors({super.key});

  @override
  State<WasteCollectors> createState() => _WasteCollectorsState();
}

class _WasteCollectorsState extends State<WasteCollectors> {
  late Future<List<WasteCollector>> _wasteCollectors;

  @override
  void initState() {
    super.initState();
    ApiService apiService = ApiService(Constants.baseUrl);
    _wasteCollectors = _fetchWasteCollectors(apiService);
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
      body: FutureBuilder<List<WasteCollector>>(
        future: _wasteCollectors,
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
            List<WasteCollector> wasteCollectors = snapshot.data!;
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

Future<List<WasteCollector>> _fetchWasteCollectors(
    ApiService apiService) async {
  final data = await apiService.get(Constants.collectorsEndpoint);
  if (data is Map<String, dynamic> && data['collectors'] is Map) {
    final collectorsMap = data['collectors'] as Map<String, dynamic>;
    List<WasteCollector> collectors = collectorsMap.entries.map((entry) {
      return WasteCollector.fromJson(entry.value, entry.key);
    }).toList();

    return collectors.toList();
  } else {
    throw Exception('Invalid data format');
  }
}
