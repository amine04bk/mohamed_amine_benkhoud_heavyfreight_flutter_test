import '../../../models/tracking_data.dart';

class TrackingRepository {
  Future<TrackingData> fetchTrackingData(String orderId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    return TrackingData(
      orderId: orderId,
      eta: '30-45 min',
      driverName: 'Karim Younes',
      pickupLocation: '24 Av. Omar Ibn El...',
      dropoffLocation: 'Your Address',
      weight: 6.0,
    );
  }
}