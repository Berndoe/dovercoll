class Bin {
  final String id;
  final String? sensorId;
  final String? userId;

  Bin({required this.id, required this.sensorId, required this.userId});

  factory Bin.fromJson(Map<String, dynamic> json) {
    return Bin(
      id: json['id'],
      sensorId: json['sensorId'],
      userId: json['userId'],
    );
  }
}
