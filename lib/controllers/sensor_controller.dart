import '../models/sensor_model.dart';
import '../services/sensor_service.dart';

class SensorController {
  final SensorService sensorService;

  SensorController(this.sensorService);

  Future<Sensor> getBinLevel(int sensorId) async {
    return sensorService.getBinLevel(sensorId);
  }
}
