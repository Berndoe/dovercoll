class Booking {
  final String bookingId;
  final String userId;
  final String? collectorId;
  final int numberOfBins;
  final double price;
  final dynamic pickupLocation;
  final String timeRequested;
  final double? collectorRating;
  final double? userRating;

  Booking(
      {required this.bookingId,
      required this.userId,
      required this.collectorId,
      required this.numberOfBins,
      required this.price,
      required this.pickupLocation,
      required this.timeRequested,
      required this.collectorRating,
      this.userRating});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
        bookingId: json['booking_id'] ?? '',
        userId: json['user_id'] ?? '',
        collectorId: json['collector_id'] ?? '',
        numberOfBins: json['number_of_bins'] ?? 0,
        price: json['price'],
        pickupLocation: json['pickup_location'] ?? 0.0,
        timeRequested: json['time_requested'],
        collectorRating: json['collector_rating'] ?? 0.0,
        userRating: json['user_rating'] ?? 0.0);
  }
}
