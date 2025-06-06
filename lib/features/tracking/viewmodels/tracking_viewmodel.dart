import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/tracking_repository.dart';
import '../../../models/tracking_data.dart';

class TrackingViewModel {
  final TrackingRepository _repository;

  TrackingViewModel(this._repository);

  Future<TrackingData> fetchTrackingData(String orderId) async {
    return await _repository.fetchTrackingData(orderId);
  }
}

final trackingViewModelProvider = Provider<TrackingViewModel>((ref) {
  return TrackingViewModel(TrackingRepository());
});