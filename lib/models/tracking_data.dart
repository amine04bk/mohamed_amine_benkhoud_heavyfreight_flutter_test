class TrackingData {
  final String orderId;
  final String eta;
  final String driverName;
  final String pickupLocation;
  final String dropoffLocation;
  final double weight;

  TrackingData({
    required this.orderId,
    required this.eta,
    required this.driverName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.weight,
  });
}