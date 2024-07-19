class Sensor {
  final String id;
  final double wasteLevel;

  Sensor({required this.id, required this.wasteLevel});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(id: json['id'], wasteLevel: json['fill_percentage']);
  }
}
