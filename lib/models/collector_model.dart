class WasteCollector {
  final String collectorId;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final double? longitude;
  final double? latitude;
  final String? profilePicture;
  final double? rating;
  final String vehicleNumber;

  WasteCollector(
      {required this.collectorId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.vehicleNumber,
      this.latitude,
      this.longitude,
      this.profilePicture,
      this.rating});

  factory WasteCollector.fromJson(Map<String, dynamic> json, String id) {
    return WasteCollector(
        collectorId: id,
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        rating: json['rating'] ?? 0.0,
        vehicleNumber: json['vehicle_number'] ?? '',
        profilePicture: json['profile_picture'] ?? '',
        latitude: json['location']['latitude'] ?? '',
        longitude: json['location']['longitude'] ?? '');
  }
}
