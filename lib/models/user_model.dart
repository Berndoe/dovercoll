class User {
  final String userId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final double? longitude;
  final double? latitude;
  final String? phoneNumber;
  final String? profilePicture;
  final double? rating;

  User(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.longitude,
      this.latitude,
      required this.phoneNumber,
      required this.rating,
      this.profilePicture});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['user_id'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        phoneNumber: json['phone_number'] ?? '',
        rating: json['rating'] ?? 0.0,
        profilePicture: json['profile_picture'] ?? '',
        latitude: json['location']['latitude'] ?? '',
        longitude: json['location']['longitude'] ?? '');
  }
}
