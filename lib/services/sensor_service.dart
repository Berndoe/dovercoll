import '../models/sensor_model.dart';
import '../services/api_service.dart';
import '../utils/constants.dart';

class SensorService {
  ApiService apiService;

  SensorService(this.apiService);

  Future<Sensor> getBinLevel(int sensorId) async {
    final data = await apiService.get('${Constants.sensorsEndpoint}/$sensorId');
    return Sensor.fromJson(data['wasteLevel']);
  }
}
