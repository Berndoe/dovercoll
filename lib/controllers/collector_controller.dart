import '../models/collector_model.dart';
import '../services/waste_collector_service.dart';

class CollectorController {
  final WasteCollectorService apiService;

  CollectorController(this.apiService);

  Future<WasteCollector> viewAccount(String collectorId) async {
    return apiService.viewAccountDetails(collectorId);
  }

  Future<WasteCollector> createAccount(String collectorId, String name,
      String email, String phoneNumber, String vehicleNumber) async {
    return apiService.createAccount(
        collectorId, name, email, phoneNumber, vehicleNumber);
  }

  Future<WasteCollector> editAccount(
      String collectorId, String name, String email, String phoneNumber) async {
    return apiService.editAccountDetails(collectorId, name, email, phoneNumber);
  }

  Future<WasteCollector> deleteAccount(String collectorId) async {
    return apiService.deleteAccount(collectorId);
  }

  Future<WasteCollector> viewCollectorHistory(String collectorId) async {
    return apiService.viewCollectorHistory(collectorId);
  }
}
