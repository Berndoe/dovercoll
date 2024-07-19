class Booking {
  final String bookingId;
  final String userId;
  final String? collectorId;
  final int numberOfBins;
  final dynamic pickupLocation;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.collectorId,
    required this.numberOfBins,
    required this.pickupLocation,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'] ?? '',
      userId: json['user_id'] ?? '',
      collectorId: json['collector_id'] ?? '',
      numberOfBins: json['number_of_bins'] ?? 0,
      pickupLocation: json['pickup_location'] ?? 0.0,
    );
  }
}
