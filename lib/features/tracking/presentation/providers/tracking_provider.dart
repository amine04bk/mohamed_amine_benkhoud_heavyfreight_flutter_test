import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../viewmodels/tracking_viewmodel.dart';
import '../../../../models/tracking_data.dart';

final trackingProvider =
    StateNotifierProvider<TrackingNotifier, AsyncValue<TrackingData>>((ref) {
  return TrackingNotifier(ref.read(trackingViewModelProvider));
});

class TrackingNotifier extends StateNotifier<AsyncValue<TrackingData>> {
  final TrackingViewModel _viewModel;

  TrackingNotifier(this._viewModel) : super(const AsyncValue.loading()) {
    fetchTrackingData();
  }

  Future<void> fetchTrackingData() async {
    try {
      state = const AsyncValue.loading();
      final data = await _viewModel.fetchTrackingData('ORD-123456789');
      state = AsyncValue.data(data);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}