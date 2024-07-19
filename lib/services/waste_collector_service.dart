import '../models/collector_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class WasteCollectorService {
  ApiService apiService;

  WasteCollectorService(this.apiService);

  Future<WasteCollector> createAccount(String collectorId, String name,
      String email, String phoneNumber, String vehicleNumber) async {
    final data = await apiService.post(Constants.collectorsEndpoint, {
      'collector_id': collectorId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'vehicle_number': vehicleNumber
    });

    return WasteCollector.fromJson(data, collectorId);
  }

  Future<WasteCollector> viewAccountDetails(String collectorId) async {
    final data =
        await apiService.get('${Constants.collectorsEndpoint}/$collectorId');
    return WasteCollector.fromJson(data, collectorId);
  }

  Future<WasteCollector> editAccountDetails(
      String collectorId, String name, String email, String phoneNumber) async {
    final data =
        await apiService.put('${Constants.collectorsEndpoint}/$collectorId', {
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
    });
    return WasteCollector.fromJson(data, collectorId);
  }

  Future<WasteCollector> deleteAccount(String collectorId) async {
    final data =
        await apiService.delete('${Constants.collectorsEndpoint}/$collectorId');
    return WasteCollector.fromJson(data, collectorId);
  }

  Future<WasteCollector> viewCollectorHistory(String collectorId) async {
    final data = await apiService.get(
        '${Constants.collectorsEndpoint}/$collectorId/${Constants.history}');
    return WasteCollector.fromJson(data, collectorId);
  }
}
