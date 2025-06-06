import 'package:flutter_riverpod/flutter_riverpod.dart';

final deliveryInfoProvider = StateNotifierProvider<DeliveryInfoNotifier, bool>((ref) {
  return DeliveryInfoNotifier();
});

class DeliveryInfoNotifier extends StateNotifier<bool> {
  DeliveryInfoNotifier() : super(false);

  void updateDeliveryInfo(bool value) {
    state = value;
  }
}